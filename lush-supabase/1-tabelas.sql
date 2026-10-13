-- =============================================================
-- Lush API (Supabase) - PARTE 1: tabelas e função de sorteio
-- Cole no SQL Editor do Supabase e clique em "Run".
-- Guarda só links e créditos das fotos do Pexels (nada de imagens).
-- =============================================================

-- Fotos guardadas por paleta + estilo
create table if not exists photos (
  palette      text        not null,   -- ex.: autumnDeep
  style        text        not null,   -- ex.: work
  photo_id     bigint      not null,   -- id da foto no Pexels
  color_hex    text        not null,   -- cor da paleta usada na busca
  image_url    text        not null,   -- foto em pé (card)
  large_url    text        not null,   -- foto maior (detalhe)
  photographer text        not null,
  pexels_url   text        not null,   -- página da foto no Pexels (crédito)
  alt          text,                   -- descrição (acessibilidade)
  fetched_at   timestamptz not null default now(),
  primary key (palette, style, photo_id)
);

-- Quando cada combinação foi atualizada pela última vez
create table if not exists combos (
  palette    text        not null,
  style      text        not null,
  updated_at timestamptz not null,
  page       int         not null default 1,   -- próxima página a buscar (variedade)
  primary key (palette, style)
);

-- Limite do Pexels (lido dos cabeçalhos das respostas)
create table if not exists meta (
  key   text primary key,
  value text not null
);

-- Segurança: ninguém lê as tabelas direto pela internet.
-- Só a Edge Function (que usa a chave de serviço) acessa.
alter table photos enable row level security;
alter table combos enable row level security;
alter table meta   enable row level security;

-- Sorteia N fotos de uma combinação
create or replace function random_photos(p_palette text, p_style text, p_limit int)
returns setof photos
language sql stable
as $$
  select * from photos
  where palette = p_palette and style = p_style
  order by random()
  limit p_limit;
$$;
