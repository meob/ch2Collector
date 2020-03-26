# CH2coll
# by mail@meo.bogliolo.name
# 0.0.1  2019-04-01 First collector version based on the MySQL one
#
# cron: */10 * * * * /home/ch/ch2coll.sh

clickhouse-client -mn --user=batch <<EOF
-- Create Database, Tables for My2 dashboard
create database IF NOT EXISTS my2;
use my2;
CREATE TABLE IF NOT EXISTS my2.status (timestamp DateTime,  metric String,  value Int64)
 ENGINE = MergeTree
 PARTITION BY toYYYYMM(timestamp)
 ORDER BY (metric, timestamp)
 SETTINGS index_granularity = 8192;

-- Collect data
insert into my2.status
select now() timestamp, metric, value
  from system.metrics
union all
select now(), metric, cast(value, 'Int64')
  from system.asynchronous_metrics
union all
select now(), event, cast(value, 'Int64')
  from system.events;
EOF




