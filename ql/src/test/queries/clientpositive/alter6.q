create table default_alter6 (a int) partitioned by (p string);

alter table default.default_alter6 rename to alter6;
describe default.alter6;

alter table default.alter6 add columns (b int);
describe default.alter6;

alter table default.alter6 replace columns (a int, b int, c string);
describe default.alter6;

alter table default.alter6 change column c cc int;
describe default.alter6;

show partitions alter6;
alter table default.alter6 add partition (p='p1');
alter table default.alter6 add partition (p='p2');
show partitions alter6;

alter table default.alter6 touch partition(p='p1');

set hive.archive.enabled = true;
alter table default.alter6 archive partition (p='p1');
describe extended alter6 partition (p='p1');

alter table default.alter6 unarchive partition (p='p1');
describe extended alter6 partition (p='p1');
show partitions alter6;

alter table default.alter6 drop partition (p='p1');

alter table default.alter6 set tblproperties('s1'='1');
describe extended alter6;

alter table default.alter6 unset tblproperties('s1'='1');
describe extended alter6;

alter table default.alter6 partition (p='p2') set fileformat orc;
show create table alter6;

alter table default.alter6 partition column (p int);
describe default.alter6;

create table exchange_alter6 like alter6;
show partitions exchange_alter6;
show partitions alter6;
alter table default.alter6 exchange partition (p='p2') with table exchange_alter6;
show partitions exchange_alter6;
show partitions alter6;
drop table exchange_alter6;

alter table default.alter6 skewed by (a) on ('skew_a') stored as directories;
describe formatted alter6;
alter table default.alter6 not stored as directories;
describe formatted alter6;
alter table default.alter6 not skewed;
describe formatted alter6;

drop table alter6;
