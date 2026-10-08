-- =============================================================
-- Lush API (Supabase) - PARTE 2: agendamento de hora em hora
-- Rode DEPOIS de publicar a função "looks".
-- Antes, ative as extensões pg_cron e pg_net (Database > Extensions).
-- Troque SEU-PROJETO e SEU-SEGREDO-DO-CRON antes de rodar.
-- =============================================================

select cron.schedule(
  'lush-refresh',            -- nome do agendamento
  '15 * * * *',              -- minuto 15 de cada hora
  $$
  select net.http_post(
    url     := 'https://SEU-PROJETO.supabase.co/functions/v1/looks/refresh',
    headers := jsonb_build_object('x-cron-secret', 'SEU-SEGREDO-DO-CRON'),
    body    := '{}'::jsonb
  );
  $$
);

-- Para conferir: select * from cron.job;
-- Para remover:  select cron.unschedule('lush-refresh');
