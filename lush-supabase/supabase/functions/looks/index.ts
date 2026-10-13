// API Lush (Supabase Edge Function): cache de sugestões de looks do Pexels.
//
// - O app chama GET /functions/v1/looks?palette=autumnDeep&style=work
// - A função responde com fotos guardadas no banco, sem gastar requisição do Pexels.
// - O Pexels só é chamado quando uma combinação ainda não tem fotos,
//   ou pelo agendamento (POST /looks/refresh, 1x por hora), que renova
//   aos poucos as combinações com mais de 7 dias.
// - Sempre dentro do limite do Pexels (200/hora e 20.000/mês), lido dos cabeçalhos.

import { createClient } from "npm:@supabase/supabase-js@2";
import { PALETTES, type PaletteColor } from "./palettes.ts";

// Filtros do app → termo de busca no Pexels
const STYLES: Record<string, string> = {
  all: "women fashion outfit",
  casual: "casual women outfit",
  work: "women office outfit",
  gym: "women gym outfit",
  party: "women party dress",
};

const DAY = 24 * 60 * 60 * 1000;
const REFRESH_AFTER = 7 * DAY;     // renova cada combinação a cada 7 dias
const DELETE_AFTER = 30 * DAY;     // apaga links com mais de 30 dias
const PHOTOS_PER_COLOR = 15;       // fotos pedidas por cor em cada busca
const MAX_PAGES = 5;               // gira entre as páginas 1 a 5 para variar
const COMBOS_PER_CRON = 2;         // combinações renovadas por hora (2 x 7 = 14 requisições)
const RESERVE = 40;                // requisições/hora sempre guardadas

// Variáveis que o Supabase já fornece + segredos configurados por vocês
const db = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);
const PEXELS_API_KEY = Deno.env.get("PEXELS_API_KEY") ?? "";
const CRON_SECRET = Deno.env.get("CRON_SECRET") ?? "";

type PexelsPhoto = {
  id: number;
  url: string;
  photographer: string;
  alt: string | null;
  src: { portrait: string; large: string };
};

Deno.serve(async (request) => {
  const url = new URL(request.url);

  try {
    // Agendamento: POST /looks/refresh (protegido pelo segredo do cron)
    if (url.pathname.endsWith("/refresh")) {
      if (request.headers.get("x-cron-secret") !== CRON_SECRET || CRON_SECRET === "") {
        return json({ error: "não autorizado" }, 401);
      }
      const refreshed = await refreshStale();
      return json({ ok: true, refreshed });
    }

    // App: GET /looks?palette=autumnDeep&style=work&limit=21
    if (request.method === "GET") {
      return await getLooks(url);
    }

    return json({ error: "not found" }, 404);
  } catch (error) {
    console.error(error);
    return json({ error: "erro interno" }, 500);
  }
});

// Devolve fotos guardadas (sorteadas). Busca no Pexels só se a combinação estiver vazia.
async function getLooks(url: URL): Promise<Response> {
  const palette = url.searchParams.get("palette") ?? "";
  const style = url.searchParams.get("style") ?? "all";
  const limit = Math.min(Number(url.searchParams.get("limit") ?? 21) || 21, 50);

  if (!PALETTES[palette] || !STYLES[style]) {
    return json({ error: "palette ou style inválido" }, 400);
  }

  let photos = await randomPhotos(palette, style, limit);

  if (photos.length === 0 && (await canSpend(7))) {
    await refreshCombo(palette, style);
    photos = await randomPhotos(palette, style, limit);
  }

  return json({ photos });
}

// Sorteia fotos no mesmo formato da resposta do Pexels (o app decodifica igual)
async function randomPhotos(palette: string, style: string, limit: number) {
  const { data, error } = await db.rpc("random_photos", {
    p_palette: palette,
    p_style: style,
    p_limit: limit,
  });
  if (error) throw error;

  return (data ?? []).map((row: Record<string, unknown>) => ({
    id: row.photo_id,
    url: row.pexels_url,
    photographer: row.photographer,
    alt: row.alt,
    src: { portrait: row.image_url, large: row.large_url },
  }));
}

// Busca as 7 cores da paleta no Pexels e guarda os links
async function refreshCombo(palette: string, style: string): Promise<void> {
  const { data: combo } = await db
    .from("combos")
    .select("page")
    .eq("palette", palette)
    .eq("style", style)
    .maybeSingle();
  const page = combo?.page ?? 1;
  const now = new Date().toISOString();
  const rows: Record<string, unknown>[] = [];

  for (const color of PALETTES[palette]) {
    const photos = await searchPexels(color, STYLES[style], page);
    if (photos === null) break;   // limite acabou: para por aqui

    const womenPhotos = photos.filter((photo) => !isMale(photo));
    for (const photo of preferMatching(womenPhotos, color)) {
      rows.push({
        palette,
        style,
        photo_id: photo.id,
        color_hex: color.hex,
        image_url: photo.src.portrait,
        large_url: photo.src.large,
        photographer: photo.photographer,
        pexels_url: photo.url,
        alt: photo.alt,
        fetched_at: now,
      });
    }
  }

  // A mesma foto pode vir em duas cores: mantém só a primeira vez
  const seen = new Set<unknown>();
  const uniqueRows = rows.filter((row) => {
    if (seen.has(row.photo_id)) return false;
    seen.add(row.photo_id);
    return true;
  });

  if (uniqueRows.length > 0) {
    const { error } = await db.from("photos").upsert(uniqueRows, { onConflict: "palette,style,photo_id" });
    if (error) throw error;
  }

  const { error } = await db.from("combos").upsert(
    { palette, style, updated_at: now, page: (page % MAX_PAGES) + 1 },
    { onConflict: "palette,style" },
  );
  if (error) throw error;
}

// Descarta fotos de homens, adolescentes e crianças (pela descrição em inglês).
// O \b exige palavra inteira, então "woman" e "women" NÃO são descartadas.
const MALE_WORDS = /\b(man|men|male|boy|boys|guy|guys|gentleman|businessman|groom|teen|teens|teenage|teenager|child|children|kid|kids)\b/i;
function isMale(photo: PexelsPhoto): boolean {
  return MALE_WORDS.test(photo.alt ?? "");
}

// Prefere fotos cuja descrição cita a cor ("woman in burgundy dress"): foca na roupa, não no fundo
function preferMatching(photos: PexelsPhoto[], color: PaletteColor): PexelsPhoto[] {
  const matching = photos.filter((photo) => {
    const description = (photo.alt ?? "").toLowerCase();
    return color.keywords.some((word) => description.includes(word));
  });
  return matching.length > 0 ? matching : photos.slice(0, 5);
}

// Uma busca no Pexels. Devolve null se o limite acabou ou deu erro.
async function searchPexels(color: PaletteColor, query: string, page: number): Promise<PexelsPhoto[] | null> {
  const params = new URLSearchParams({
    query: `${color.name} ${query}`,
    color: color.hex,
    orientation: "portrait",
    per_page: String(PHOTOS_PER_COLOR),
    page: String(page),
  });

  const response = await fetch(`https://api.pexels.com/v1/search?${params}`, {
    headers: { Authorization: PEXELS_API_KEY },
  });

  if (response.status === 429) {
    // Limite atingido: não tenta de novo pela próxima hora
    await saveLimit(0, Date.now() + 60 * 60 * 1000);
    return null;
  }
  if (!response.ok) return null;

  // Cabeçalhos com o limite restante (só vêm em respostas de sucesso)
  const remaining = Number(response.headers.get("X-Ratelimit-Remaining"));
  const reset = Number(response.headers.get("X-Ratelimit-Reset")) * 1000; // vem em segundos
  if (!Number.isNaN(remaining)) await saveLimit(remaining, reset || Date.now() + 60 * 60 * 1000);

  const body = await response.json() as { photos?: PexelsPhoto[] };
  return body.photos ?? [];
}

async function saveLimit(remaining: number, resetAt: number): Promise<void> {
  await db.from("meta").upsert([
    { key: "remaining", value: String(remaining) },
    { key: "reset_at", value: String(resetAt) },
  ]);
}

// Só busca no Pexels se, depois disso, ainda sobrar a reserva
async function canSpend(requests: number): Promise<boolean> {
  const { data } = await db.from("meta").select("key, value");
  const meta = Object.fromEntries((data ?? []).map((row) => [row.key, row.value]));

  if (meta.remaining === undefined) return true;           // ainda não sabemos: pode
  if (Date.now() > Number(meta.reset_at)) return true;       // o limite já renovou
  return Number(meta.remaining) - requests >= RESERVE;
}

// Agendamento: apaga links antigos e renova até 2 combinações vencidas
async function refreshStale(): Promise<string[]> {
  const now = Date.now();
  await db.from("photos").delete().lt("fetched_at", new Date(now - DELETE_AFTER).toISOString());

  const { data } = await db.from("combos").select("palette, style, updated_at");
  const updated = new Map(
    (data ?? []).map((row) => [`${row.palette}|${row.style}`, new Date(row.updated_at).getTime()]),
  );

  const stale: { palette: string; style: string; updatedAt: number }[] = [];
  for (const palette of Object.keys(PALETTES)) {
    for (const style of Object.keys(STYLES)) {
      const updatedAt = updated.get(`${palette}|${style}`) ?? 0;
      if (now - updatedAt > REFRESH_AFTER) stale.push({ palette, style, updatedAt });
    }
  }
  stale.sort((a, b) => a.updatedAt - b.updatedAt);

  const refreshed: string[] = [];
  for (const combo of stale.slice(0, COMBOS_PER_CRON)) {
    if (!(await canSpend(7))) break;
    await refreshCombo(combo.palette, combo.style);
    refreshed.push(`${combo.palette}/${combo.style}`);
  }
  return refreshed;
}

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json; charset=utf-8" },
  });
}
