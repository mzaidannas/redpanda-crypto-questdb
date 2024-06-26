-- CREATE EXTENSION pg_cron;

-- Coinbase table
CREATE TABLE IF NOT EXISTS coinbase (currency varchar, amount float, "timestamp" timestamp without time zone) PARTITION BY RANGE("timestamp");

SELECT create_distributed_table('coinbase', 'currency');

SELECT create_time_partitions(
  table_name         := 'coinbase',
  partition_interval := '1 day',
  start_from         := date_trunc('day', now()),
  end_at             := date_trunc('day', now() + interval '12 days')
);

CALL alter_old_partitions_set_access_method(
  'coinbase',
   date_trunc('day', now() + interval '12 days') /* older_than */,
  'columnar'
);

CREATE INDEX index_coinbase_on_currency_hash ON coinbase USING hash(currency);
CREATE INDEX index_coinbase_on_timestamp_hash ON coinbase USING hash("timestamp");
CREATE INDEX index_coinbase_on_timestamp_btree ON coinbase USING btree("timestamp");

-- Moving Averages Table
CREATE TABLE IF NOT EXISTS moving_averages (currency varchar, amount float, "timestamp" timestamp without time zone) PARTITION BY RANGE("timestamp");

SELECT create_distributed_table('moving_averages', 'currency');

SELECT create_time_partitions(
  table_name         := 'moving_averages',
  partition_interval := '1 day',
  start_from         := date_trunc('day', now()),
  end_at             := date_trunc('day', now() + interval '12 days')
);

CALL alter_old_partitions_set_access_method(
  'moving_averages',
   date_trunc('day', now() + interval '12 days') /* older_than */,
  'columnar'
);

CREATE INDEX index_moving_averages_on_currency_hash ON moving_averages USING hash(currency);
CREATE INDEX index_moving_averages_on_timestamp_hash ON moving_averages USING hash("timestamp");
CREATE INDEX index_moving_averages_on_timestamp_btree ON moving_averages USING btree("timestamp");

-- Schedule partition creation for the next 12 days
-- SELECT cron.schedule('create-partitions', '0 1 * * *', $$
--   SELECT create_time_partitions(
--       table_name         := 'github_events',
--       partition_interval := '1 day',
--       end_at             := date_trunc('day', now() + interval '12 days')
--   )
-- $$);

-- Schedule partition conversion to columar for the next 12 days
-- SELECT cron.schedule('compress-partitions', '2 1 * * *', $$
--   CALL alter_old_partitions_set_access_method(
--     'github_columnar_events',
--     date_trunc('day', now() + interval '12 days') /* older_than */,
--     'columnar'
--   );
-- $$);
