#!/usr/bin/env bash
# QuestDB tables
curl -G \
  --data-urlencode 'query=CREATE TABLE IF NOT EXISTS coinbase (currency symbol CAPACITY 1000 INDEX, amount float, `timestamp` timestamp) TIMESTAMP("timestamp") PARTITION BY DAY;'\
  http://localhost:9000/exec
curl -G \
  --data-urlencode 'query=CREATE TABLE IF NOT EXISTS moving_averages (currency symbol CAPACITY 1000 INDEX, amount float, `timestamp` timestamp) TIMESTAMP("timestamp") PARTITION BY DAY;'\
  http://localhost:9000/exec
# Clickhouse tables
curl -u "default:password" -XPOST \
  --data 'CREATE TABLE IF NOT EXISTS coinbase (currency LowCardinality(String), amount double CODEC(Gorilla), `timestamp` DateTime CODEC(DoubleDelta)) ENGINE = ReplacingMergeTree(`timestamp`) PARTITION BY toDate(`timestamp`) ORDER BY (currency, `timestamp`) PRIMARY KEY (currency, `timestamp`);'\
  http://localhost:8123
curl -u "default:password" -XPOST \
  --data 'CREATE TABLE IF NOT EXISTS moving_averages (currency LowCardinality(String), amount double CODEC(Gorilla), `timestamp` DateTime CODEC(DoubleDelta)) ENGINE = ReplacingMergeTree(`timestamp`) PARTITION BY toDate(`timestamp`) ORDER BY (currency, `timestamp`) PRIMARY KEY (currency, `timestamp`);'\
  http://localhost:8123
# Citus Data tables
psql "postgres://postgres:password@localhost:5432/postgres" -f docker-compose/citus/pg_table.sql
for filename in docker-compose/**/*.json; do
  curl -X DELETE "http://localhost:8083/connectors/`basename ${filename} .json`"
  curl -X POST -H "Accept:application/json" -H "Content-Type:application/json" --data "@${filename}" http://localhost:8083/connectors | jq
done
