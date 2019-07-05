# ch2Collector
ClickHouse statistics data collector

ch2coll.sh is a simple script to collect usage statistics for ClickHouse in a ClickHouse table.
ClickHouse is a very fast, Open Source, columnar database.

The script uses a simple table in the my2 schema to collect data.
ch2coll collects from system.metrics, system.asynchronous_metrics, and system.events:
insert into my2.status
select now() timestamp, metric, value
  from system.metrics
union all
select now(), metric, cast(value, 'Int64')
  from system.asynchronous_metrics
union all
select now(), event, cast(value, 'Int64')
  from system.events;
  
Collecting data allows usage analysis and visualization...
