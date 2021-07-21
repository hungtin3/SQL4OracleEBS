set echo off
SET VERIFY off
SET feedback off
set heading off
spool  killsniped.log

select 'alter system disconnect session '||''''||sid||','||serial#||''''||' immediate;'
from v$session where schemaname='KTEVNIT';

spool off

set echo on
SET VERIFY on
SET feedback on
set heading on

@@killsniped.log
