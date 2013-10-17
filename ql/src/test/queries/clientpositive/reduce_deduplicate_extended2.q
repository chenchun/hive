set hive.optimize.reducededuplication=true;
set hive.optimize.reducededuplication.min.reducer=1;
set hive.map.aggr=true;

-- HIVE-2340 deduplicate RS followed by RS
-- hive.optimize.reducededuplication : wherther using this optimization
-- hive.optimize.reducededuplication.min.reducer : number of reducer of deduped RS should be this at least

create table src9 (key string, value string);
load data local inpath '../data/files/kv9.txt' into table src9;

-- RS-mGBY-RS-rGBY
explain select key, value from (select key, value from src9 order by key, value) t group by value, key;
-- mGBY-RS-rGBY-RS
-- should not be optimized
explain select key, sum(key) as value from src9 group by key order by value, key;
explain select key, value from (select key, value from src9 group by key, value) t order by key desc, value;
explain select key, value from (select key, value from src9 group by key, value) t order by value, key;
-- mGBY-RS-rGBY-mGBY-RS-rGBY
explain select k2, k4, count(k1), sum(k3) from (select k1, k2, k3, k4 from (select key k1, key k2, key k3, key k4 from src9) t group by k1, k2, k3, k4) t group by k2, k4;

select key, value from (select key, value from src9 order by key, value) t group by value, key;
select key, sum(key) as value from src9 group by key order by value, key;
select key, value from (select key, value from src9 group by key, value) t order by key desc, value;
select key, value from (select key, value from src9 group by key, value) t order by value, key;
select k2, k4, count(k1), sum(k3) from (select k1, k2, k3, k4 from (select key k1, key k2, key k3, key k4 from src9) t group by k1, k2, k3, k4) t group by k2, k4;

set hive.map.aggr=false;

-- RS-RS-GBY
explain select key, value from (select key, value from src9 order by key, value) t group by value, key;
-- RS-GBY-RS
-- should not be optimized
explain select key, sum(key) as value from src9 group by key order by value, key;
explain select key, value from (select key, value from src9 group by key, value) t order by key desc, value;
explain select key, value from (select key, value from src9 group by key, value) t order by value, key;
-- RS-GBY-RS-GBY
explain select k2, k4, count(k1), sum(k3) from (select k1, k2, k3, k4 from (select key k1, key k2, key k3, key k4 from src9) t group by k1, k2, k3, k4) t group by k2, k4;

select key, value from (select key, value from src9 order by key, value) t group by value, key;
select key, sum(key) as value from src9 group by key order by value, key;
select key, value from (select key, value from src9 group by key, value) t order by key desc, value;
select key, value from (select key, value from src9 group by key, value) t order by value, key;
select k2, k4, count(k1), sum(k3) from (select k1, k2, k3, k4 from (select key k1, key k2, key k3, key k4 from src9) t group by k1, k2, k3, k4) t group by k2, k4;

drop table src9;
