# Lush API (Supabase)

- Banco: Postgres do Supabase (tabelas photos, combos e meta) -> arquivo 1-tabelas.sql
- API: Edge Function "looks" em TypeScript (Deno), roda na nuvem do Supabase
- Agendamento: pg_cron chama POST /looks/refresh 1x por hora -> arquivo 2-agendamento.sql

App chama:
GET https://SEU-PROJETO.supabase.co/functions/v1/looks?palette=autumnDeep&style=work&limit=21

palette: springClear, springWarn, springLight, summerSoft, summerCool, summerLight,
         autumnSoft, autumnWarn, autumnDeep, winterClear, winterCool, winterDeep
style:   all, casual, work, gym, summer, party

Resposta no mesmo formato do Pexels: { "photos": [ { id, url, photographer, alt, src: { portrait, large } } ] }

Regras do Pexels respeitadas: reserva de 40 requisições/hora, no máximo 2 combinações
renovadas por hora (14 requisições), cada combinação só a cada 7 dias, só links (sem imagens).
