set pagesize 10000 linesize 300 tab off
 
col tablespace_name format A22              heading "Tablespace"
col ts_type         format A13              heading "TS Type"
col segments        format 999999           heading "Segments"
col files           format 9999
col allocated_mb    format 9,999,990.000    heading "Allocated Size|(Mb)"
col used_mb         format 9,999,990.000    heading "Used Space|(Mb)"
col Free_mb         format 999,990.000      heading "Free Space|(Mb)"
col used_pct        format 999              heading "Used|%"
col max_ext_mb      format 99,999,990.000   heading "Max Size|(Mb)"
col max_free_mb     format 9,999,990.000    heading "Max Free|(Mb)"
col max_used_pct    format 999              heading "Max Used|(%)"
 
BREAK ON REPORT
COMPUTE SUM LABEL "TOTAL SUM ==========>" AVG LABEL "AVERAGE   ==========>" OF segments files allocated_mb used_mb Free_MB max_ext_mb ON REPORT
 
WITH df AS (SELECT tablespace_name, SUM(bytes) bytes, COUNT(*) cnt, DECODE(SUM(DECODE(autoextensible,'NO',0,1)), 0, 'NO', 'YES') autoext, sum(DECODE(maxbytes,0,bytes,maxbytes)) maxbytes FROM dba_data_files GROUP BY tablespace_name), 
     tf AS (SELECT tablespace_name, SUM(bytes) bytes, COUNT(*) cnt, DECODE(SUM(DECODE(autoextensible,'NO',0,1)), 0, 'NO', 'YES') autoext, sum(DECODE(maxbytes,0,bytes,maxbytes)) maxbytes FROM dba_temp_files GROUP BY tablespace_name), 
     tm AS (SELECT tablespace_name, used_percent FROM dba_tablespace_usage_metrics),
     ts AS (SELECT tablespace_name, COUNT(*) segcnt FROM dba_segments GROUP BY tablespace_name)
SELECT d.tablespace_name, 
       d.status,
       DECODE(d.contents,'PERMANENT',DECODE(d.extent_management,'LOCAL','LM','DM'),'TEMPORARY','TEMP',d.contents)||'-'||DECODE(d.allocation_type,'UNIFORM','UNI','SYS')||'-'||decode(d.segment_space_management,'AUTO','ASSM','MSSM') ts_type,
       a.cnt files,  
       NVL(s.segcnt,0) segments,
       ROUND(NVL(a.bytes / 1024 / 1024, 0), 3) Allocated_MB, 
       ROUND(NVL(a.bytes - NVL(f.bytes, 0), 0)/1024/1024,3) Used_MB, 
       ROUND(NVL(f.bytes, 0) / 1024 / 1024, 3) Free_MB, 
       ROUND(NVL((a.bytes - NVL(f.bytes, 0)) / a.bytes * 100, 0), 2) Used_pct, 
       ROUND(a.maxbytes / 1024 / 1024, 3)  max_ext_mb,
       ROUND(NVL(m.used_percent,0), 2) Max_used_pct
  FROM dba_tablespaces d, df a, tm m, ts s, (SELECT tablespace_name, SUM(bytes) bytes FROM dba_free_space GROUP BY tablespace_name) f 
 WHERE d.tablespace_name = a.tablespace_name(+) 
   AND d.tablespace_name = f.tablespace_name(+) 
   AND d.tablespace_name = m.tablespace_name(+) 
   AND d.tablespace_name = s.tablespace_name(+)
   AND NOT d.contents = 'UNDO'
   AND NOT ( d.extent_management = 'LOCAL' AND d.contents = 'TEMPORARY' ) 
UNION ALL
-- TEMP TS
SELECT d.tablespace_name, 
       d.status, 
       DECODE(d.contents,'PERMANENT',DECODE(d.extent_management,'LOCAL','LM','DM'),'TEMPORARY','TEMP',d.contents)||'-'||DECODE(d.allocation_type,'UNIFORM','UNI','SYS')||'-'||decode(d.segment_space_management,'AUTO','ASSM','MSSM') ts_type, 
       a.cnt, 
       0,
       ROUND(NVL(a.bytes / 1024 / 1024, 0), 3) Allocated_MB, 
       ROUND(NVL(t.ub*d.block_size, 0)/1024/1024, 3) Used_MB, 
       ROUND((NVL(a.bytes ,0)/1024/1024 - NVL((t.ub*d.block_size), 0)/1024/1024), 3) Free_MB,
       ROUND(NVL((t.ub*d.block_size) / a.bytes * 100, 0), 2) Used_pct,
       ROUND(a.maxbytes / 1024 / 1024, 3)  max_size_mb, 
       ROUND(NVL(m.used_percent,0), 2) Max_used_pct
  FROM dba_tablespaces d, tf a, tm m, (SELECT ss.tablespace_name , sum(ss.used_blocks) ub FROM gv$sort_segment ss GROUP BY ss.tablespace_name) t 
 WHERE d.tablespace_name = a.tablespace_name(+) 
   AND d.tablespace_name = t.tablespace_name(+) 
   AND d.tablespace_name = m.tablespace_name(+) 
   AND d.extent_management = 'LOCAL'
   AND d.contents = 'TEMPORARY'  
UNION ALL
-- UNDO TS
SELECT d.tablespace_name, 
       d.status, 
       DECODE(d.contents,'PERMANENT',DECODE(d.extent_management,'LOCAL','LM','DM'),'TEMPORARY','TEMP',d.contents)||'-'||DECODE(d.allocation_type,'UNIFORM','UNI','SYS')||'-'||decode(d.segment_space_management,'AUTO','ASSM','MSSM') ts_type, 
       a.cnt, 
       NVL(s.segcnt,0) segments,
       ROUND(NVL(a.bytes / 1024 / 1024, 0), 3) Allocated_MB, 
       ROUND(NVL(u.bytes, 0) / 1024 / 1024, 3) Used_MB, 
       ROUND(NVL(a.bytes - NVL(u.bytes, 0), 0)/1024/1024, 3) Free_MB,
       ROUND(NVL(u.bytes / a.bytes * 100, 0), 2) Used_pct, 
       ROUND(a.maxbytes / 1024 / 1024, 3)  max_size_mb,
       ROUND(NVL(m.used_percent,0), 2) Max_used_pct
FROM dba_tablespaces d, df a, tm m, ts s, (SELECT tablespace_name, SUM(bytes) bytes FROM dba_undo_extents where status in ('ACTIVE','UNEXPIRED') GROUP BY tablespace_name) u 
WHERE d.tablespace_name = a.tablespace_name(+) 
AND d.tablespace_name = u.tablespace_name(+) 
AND d.tablespace_name = m.tablespace_name(+) 
AND d.tablespace_name = s.tablespace_name(+)
AND d.contents = 'UNDO'
ORDER BY 1 
/
 
prompt * Tablespace (TS) types: 
prompt .  - LM/DM     - Local/Dictionary Managed 
prompt .  - SYS/UNI   - SYStem/UNIform Extent Management (LM only)
prompt .  - ASSM/MSSM - Automatic/Manual Segment Space Management (ASSM -> LM only)


col name for a90
col Mb format 99999990
set heading on
set line 150

select name, block_size * file_size_blks/1024/1024 Mb from v$controlfile
union 
select name, bytes/1024/1024 Mb from v$datafile
union
select name, bytes/1024/1024 from v$tempfile
union
select f.MEMBER, g.BYTES/1024/1024 from v$logfile f, v$log g
where f.GROUP#=g.GROUP#
order by 1; 


select name, c.BLOCK_SIZE*c.FILE_SIZE_BLKS/1024/1024 from v$controlfile c

col file_name for a100
col Mb format 99999990
set heading on
set line 150
select file_name, AUTOEXTENSIBLE,bytes/1024/1024 Mb
from dba_data_files where file_name like '/u21%';


select file_name, AUTOEXTENSIBLE,bytes/1024/1024 Mb
from dba_data_files where tablespace_name like 'APPS_UNDOTS1';

select file_name, AUTOEXTENSIBLE,bytes/1024/1024 Mb
from dba_data_files where tablespace_name like 'SYSAUX';

select file_name, AUTOEXTENSIBLE,bytes/1024/1024 Mb, 'alter database datafile '||''''||file_name||''''||' resize '||10 *1024||' M;'
from dba_data_files where tablespace_name like 'APPS_TS_TX_DATA';

select  'alter database datafile '||''''||file_name||''''||' resize '||15 *1024||' M;'
from dba_data_files where tablespace_name like 'APPS_TS_TX_DATA' and bytes/1024/1024 <13*1024;

select  'alter database datafile '||''''||file_name||''''||' resize '|| 20 *1024||' M;'
from dba_data_files where tablespace_name like 'APPS_UNDOTS1' and bytes/1024/1024 <= 20*1024;

select  'alter database datafile '||''''||file_name||''''||||' resize '||10 *1024||' M;'
from dba_data_files where tablespace_name like 'APPS_TS_MEDIA';

select  'alter database datafile '||''''||file_name||''''||' resize '||3*1024||' M;'
from dba_data_files where tablespace_name like 'SYSTEM';


select  'alter database datafile '||''''||file_name||''''||' resize '||8*1024||' M;'
from dba_data_files where tablespace_name like 'APPS_TS_TX_IDX';

--SET heading OFF
--SET line 150
SELECT --File_Name,
       --Autoextensible,
       --Bytes / 1024 / 1024 Mb,
       'alter database datafile ' || '''' || File_Name || '''' ||
       ' resize ' || ( (ROUND( BYTES/1024/1024/1024,0) +2) * 1024 ) || ' M;'
  FROM Dba_Data_Files f
 WHERE Tablespace_Name LIKE 'TABSPC_CHISO'
   AND f.Bytes / 1024 / 1024 / 1024 + 2 <= 16
 ORDER BY Bytes DESC;



alter database  datafile '/u02/oradata/vasgateh/undotbs01.dbf' autoextend off

col tablespace_name for a20
set heading on
set line 1000

SELECT a.Tablespace_Name "Tablespace_name",
       Nvl(Round(b.Bytes / (1024 * 1024)),
           0) " Free|(Mb)",
       Round(a.User_Bytes / (1024 * 1024)) "Size|(Mb)",
       Nvl(Round(100 * b.Bytes / a.User_Bytes,
                 2),
           0) "Free %"
  FROM (SELECT Tablespace_Name, SUM(User_Bytes) User_Bytes
          FROM Dba_Data_Files
         GROUP BY Tablespace_Name) a,
       (SELECT Tablespace_Name, SUM(Bytes) Bytes
          FROM Dba_Free_Space
         GROUP BY Tablespace_Name) b
 WHERE a.Tablespace_Name = b.Tablespace_Name(+)
UNION ALL
SELECT c.Tablespace_Name "Tablespace_name",
       Round((c.User_Bytes) / (1024 * 1024)) -
       Round(d.Bytes / (1024 * 1024)) "Free|(Mb)",
       Round((c.User_Bytes) / (1024 * 1024)) "Size|Mb",
       Round(100 * (c.User_Bytes - d.Bytes) / c.User_Bytes,
             2) "Free %"
  FROM (SELECT Tablespace_Name, SUM(f.Bytes) User_Bytes
          FROM Dba_Temp_Files f
         GROUP BY Tablespace_Name) c,
       (SELECT Tablespace_Name, (SUM(Total_Blocks) * 8192) Bytes
          FROM V$sort_Segment
         GROUP BY Tablespace_Name) d
 WHERE c.Tablespace_Name = d.Tablespace_Name(+)
 ORDER BY 4


 drop tablespace DEV1_MDS including contents and datafiles;

-- Alter database datafile 
--   '/u02/app/oracle/product/8.1.6/oradata/nna1/temp01.dbf'
-- resize 400M;   
--alter tablespace undo add datafile '/ICT/undotbs/undotbs02.dbf' size 1024M

--alter database  datafile '/u02/oradata/vasgateh/undotbs01.dbf' resize 2048Mb

--alter tablespace DATA_IND add datafile '/htc/htc_app/oracle/oradata/HTCPRD1B/data_ind03.dbf' size 3072

CREATE TABLESPACE APPS_TS_XLA_DATA
DATAFILE '/rpool/ERPSPC/db/apps_st/data/apps_ts_xla_data_fno_01.dbf' SIZE 5G;

alter tablespace APPS_TS_TX_IDX add datafile '/rpool/ERPSPC/db/apps_st/data/apps_ts_tx_idx_fno_79.dbf' size 6G;

alter tablespace APPS_TS_TX_DATA add datafile '/rpool/ERPSPC/db/apps_st/data/apps_ts_tx_data_fno_87.dbf' size 6G;

alter tablespace APPS_UNDOTS1 add datafile '/rsoft/ERPNPC/db/apps_st/data/undots1_fno-86.dbf' size 16G;

alter tablespace TEMP1 add tempfile 
'/u02/erphan/db/apps_st/data/temp01a.dbf' reuse;

alter tablespace TEMP1 drop tempfile 
'/rpool/erphan/db/apps_st/data/temp01a.dbf' ;

alter tablespace TEMP1 drop tempfile 
'/rpool/erphan/db/apps_st/data/temp01b.dbf' ;


alter tablespace TEMP01 add tempfile '/rpool/ERPSPC/db/apps_st/data/temp01d.dbf' size 10240M;

/rpool/ERPSPC/db/apps_st/data/temp01b.dbf


alter tablespace SYSAUX add datafile
'/rpool/ERPSPC/db/apps_st/data/sysaux_fno_64.dbf' size 10240M;

--alter tablespace DEV01_TEMP add tempfile 
--'/u01/oradata/vasgateh/VASGATE_TMP_002.dbf' size 1024M

alter database tempfile  '/rbackup/QANPC/db/apps_st/data/temp02.dbf' resize 1024M

--alter database  datafile '/u02/oradata/vasgateh/undotbs01.dbf' autoextend off

--alter database tempfile '/u02/oradata/vasgateh/DEV01_TEMP_01.dbf' autoextend off

--alter tablespace APPS_TS_TX_DATA add datafile '/dev/md/ebsdb-ds/rdsk/d423' reuse

alter database datafile '/u03/oradata/users02.dbf' resize 2048M

alter database datafile '/data/oradata/nmsruim/users01.dbf' resize 2048M

alter database datafile '/apps/oradata/user05.dbf' resize 1024M

alter database datafile '/var/oradata/users04.dbf' resize 128M

alter database datafile '/u03/oradata/indx02.dbf' resize 10240M

alter database datafile '/data/oradata/nmsruim/users01.dbf' resize 1024M

alter database datafile '/oradata/stagedb/RTBS_OWNER_DF_TBS_07.dbf' resize 2560M


alter database RENAME FILE '/var/oradata/users04.dbf'  to '/u03/oradata/users04.dbf'

alter database RENAME FILE '/apps/oradata/ASCS_DEFAULT_001.dbf' to '/u03/oradata/ASCS_DEFAULT_001.dbf'

alter database RENAME FILE '/apps/oradata/indx04.dbf' to '/u03/oradata/indx04.dbf'

alter database RENAME FILE '/apps/oradata/UNDO01.dbf' to '/u03/oradata/UNDO01.dbf'

alter database RENAME FILE '/apps/oradata/user05.dbf' to '/u03/oradata/user05.dbf'

alter database RENAME FILE '/apps/oradata/TEMP02.dbf' to '/u03/oradata/TEMP02.dbf'

ALTER DATABASE TEMPFILE  'temp01.dbf'  DROP INCLUDING DATAFILES;

alter database TEMPFILE  '/apps/oradata/TEMP02.dbf' DROP;

ALTER TABLESPACE TEMP01 ADD TEMPFILE '/u03/oradata/TEMP02.dbf' reuse


SELECT Total.name "Tablespace Name",
       nvl(Free_space, 0) Free_space,
       nvl(total_space-Free_space, 0) Used_space, 
       total_space
FROM
  (select tablespace_name, sum(bytes/1024/1024) Free_Space
     from sys.dba_free_space
    group by tablespace_name
  ) Free,
  (select b.name,  sum(bytes/1024/1024) TOTAL_SPACE
     from sys.v_$datafile a, sys.v_$tablespace B
    where a.ts# = b.ts#
    group by b.name
  ) Total
WHERE Free.Tablespace_name(+) = Total.name
ORDER BY Total.name
/

SELECT   SUBSTR (df.NAME, 1, 40) file_name, df.bytes / 1024 / 1024 allocated_mb,
         ((df.bytes / 1024 / 1024) - NVL (SUM (dfs.bytes) / 1024 / 1024, 0))
               used_mb,
         NVL (SUM (dfs.bytes) / 1024 / 1024, 0) free_space_mb
    FROM v$datafile df, dba_free_space dfs
   WHERE df.file# = dfs.file_id(+)
GROUP BY dfs.file_id, df.NAME, df.file#, df.bytes
ORDER BY file_name;


select 'alter table ' ||owner||'.'||table_name||' move tablespace ' ||u.default_tablespace ||';' 
from dba_tables t , dba_users u
where 
t.owner=u.username
and ( t.owner <> 'SYSTEM' and t.owner<>'SYS')
and t.tablespace_name='SYSTEM';

select u.username,  s.tablespace_name ,u.default_tablespace, round(sum(s.bytes)/1024/1024 ,2)Mb
from dba_segments s,
dba_users u
where u.username=s.owner
group by u.username, s.tablespace_name , u.default_tablespace
order by u.username, s.tablespace_name 

set line 1000
select 
'alter database datafile ' || ''''||d.name||''''||' resize ' ||trunc(bytes*0.9/1024/1024)||'M ;' sql_clause,
bytes/1024/1024 old_size,trunc(bytes*1.4/1024/1024) new_size,
trunc(bytes*1.4/1024/1024)- bytes/1024/1024 chenh_lech
from v$datafile  d, v$tablespace ts ,
              (select a.tablespace_name tablespace_name,
                            round(b.bytes/(1024*1024)) "Used",
                            round(a.user_bytes/(1024*1024)) "Size" ,
                            round(100*b.bytes/a.user_bytes,2) usage1
               from       ( select tablespace_name,sum(user_bytes)  user_bytes
                                   from  dba_data_files
                                    group by tablespace_name
                                   union 
                                 select tablespace_name,sum(user_bytes)  user_bytes
                                   from  dba_temp_files
                                    group by tablespace_name) a,
                                ( select tablespace_name, sum(bytes)   bytes
                                          from dba_segments
                                          group by tablespace_name
                union
                                 select tablespace_name,(sum(total_blocks)*8192) bytes 
                                           from v$sort_segment
                        group by tablespace_name) b
              where a.tablespace_name=b.tablespace_name (+)
              order by a.tablespace_name) v
where d.TS# =ts.TS# 
and ts.NAME=v.tablespace_name
and v.usage1<80

--Temp file
SELECT   SUBSTR (df.NAME, 1, 40) file_name, df.bytes / 1024 / 1024 allocated_mb,
         ((df.bytes / 1024 / 1024) - NVL (SUM (dfs.bytes) / 1024 / 1024, 0))
               used_mb,
         NVL (SUM (dfs.bytes) / 1024 / 1024, 0) free_space_mb
    FROM v$tempfile df, dba_free_space dfs
   WHERE df.file# = dfs.file_id(+)
GROUP BY dfs.file_id, df.NAME, df.file#, df.bytes
ORDER BY file_name;

--Tempfile
SELECT b.tablespace_name Tablespace,
       a.name Data_File,
       a.avail "Total|Space [MB]",
       NVL(b.free,0) "Free|Space [MB]",
       NVL(ROUND(((free/avail)*100),2),0) "Free|%"
  FROM (SELECT t.TS#,
               t.NAME,
               t.FILE#,
               ROUND(SUM(bytes/(1024*1024)),3) avail
          FROM v$tempfile t
      GROUP BY t.TS#,
               t.NAME,
               t.FILE#) a,
       (SELECT tablespace_name,
               file_id,
               ROUND(SUM(bytes/(1024*1024)),3) free
          FROM sys.dba_free_space
      GROUP BY tablespace_name, file_id) b
WHERE a.FILE# = b.file_id (+)
ORDER BY 1, 2
/

select ddf.file_name
          ,ddf.tablespace_name
          ,sum(dfs.bytes)/1024/1024 free_space
    from dba_data_files ddf, dba_free_space dfs
    where ddf.file_id = dfs.file_id
      and ddf.tablespace_name like 'APPS_TS_TX_DATA'
    group by ddf.file_name,ddf.tablespace_name
    /

	SELECT g.Group#, f.Member, g.Bytes / 1024 / 1024 Mb, g.STATUS
  FROM V$log g, V$logfile f
 WHERE g.Group# = f.Group#
 ORDER BY 1;
 
--ALTER DATABASE DROP LOGFILE GROUP 3; 
 
ALTER SYSTEM SWITCH LOGFILE; 

ALTER SYSTEM ARCHIVE LOG ALL;


ALTER DATABASE 
  ADD LOGFILE GROUP 13 ('/rsoft/ERPNPC/db/apps_st/data/redolog13a.dbf', '/rtemp/ERPNPC/db/apps_st/data/redolog13b.dbf')
      SIZE 512M;
	  
SELECT f.FILE#, t.Ts#, t.Name tname, f.Name fname, f.Bytes / 1024 / 1024/1024 SizeGb
  FROM V$tablespace t, V$datafile f
 WHERE 1=1 AND t.Ts# = f.Ts#
--AND t.NAME='APPS_TS_TX_IDX'
 ORDER BY f.NAME;
 
CREATE TABLESPACE APPS_TS_XLA_IDX DATAFILE '/rsoft/ERPNPC/db/apps_st/data/apps_ts_xla_idx_fno_01.dbf' SIZE 5 G

ALTER TABLESPACE APPS_TS_XLA_IDX ADD DATAFILE '/rsoft/ERPNPC/db/apps_st/data/apps_ts_xla_idx_fno_02.dbf' SIZE 5 G

CREATE TABLESPACE APPS_TS_AP_IDX DATAFILE '/rsoft/ERPNPC/db/apps_st/data/apps_ts_ap_idx_fno_01.dbf' SIZE 5 G

ALTER TABLESPACE APPS_TS_AP_IDX ADD DATAFILE '/rsoft/ERPNPC/db/apps_st/data/apps_ts_ap_idx_fno_02.dbf' SIZE 5 G


CREATE TABLESPACE APPS_TS_XLA_DATA
DATAFILE '/rpool/ERPSPC/db/apps_st/data/apps_ts_xla_data_fno_01.dbf' SIZE 5G;

alter tablespace APPS_TS_XLA_DATA add datafile '/rpool/ERPSPC/db/apps_st/data/apps_ts_xla_data_fno_02.dbf' size 6G;

alter tablespace APPS_TS_XLA_DATA add datafile '/rpool/ERPSPC/db/apps_st/data/apps_ts_xla_data_fno_03.dbf' size 6G;

alter tablespace APPS_TS_XLA_DATA add datafile '/rpool/ERPSPC/db/apps_st/data/apps_ts_xla_data_fno_04.dbf' size 6G;

alter tablespace APPS_TS_XLA_DATA add datafile '/rpool/ERPSPC/db/apps_st/data/apps_ts_xla_data_fno_05.dbf' size 6G;

alter tablespace APPS_TS_XLA_DATA add datafile '/rpool/ERPSPC/db/apps_st/data/apps_ts_xla_data_fno_06.dbf' size 6G;


CREATE TABLESPACE APPS_TS_XLA_IDX 
DATAFILE '/rpool/ERPSPC/db/apps_st/data/apps_ts_xla_idx_fno_01.dbf' SIZE 5G;


alter tablespace APPS_TS_XLA_IDX add datafile '/rpool/ERPSPC/db/apps_st/data/apps_ts_xla_idx_fno_07.dbf' size 6G;

alter tablespace APPS_TS_XLA_IDX add datafile '/rpool/ERPSPC/db/apps_st/data/apps_ts_xla_idx_fno_08.dbf' size 6G;

alter tablespace APPS_TS_XLA_IDX add datafile '/rpool/ERPSPC/db/apps_st/data/apps_ts_xla_idx_fno_09.dbf' size 6G;

alter tablespace APPS_TS_XLA_IDX add datafile '/rpool/ERPSPC/db/apps_st/data/apps_ts_xla_idx_fno_10.dbf' size 6G;

alter tablespace APPS_TS_XLA_IDX add datafile '/rpool/ERPSPC/db/apps_st/data/apps_ts_xla_idx_fno_06.dbf' size 6G;

GRANT RESOURCE TO xla

ALTER TABLESPACE  APPS_TS_AR_DATA ONLINE;

ALTER DATABASE RENAME FILE  '/rdata/ERPNPC/db/apps_st/data/apps_ts_bom_data_fno_02.dbf' to '/rdata/ERPNPC/db/apps_st/data/apps_ts_ar_data_fno_04.dbf'


SELECT
  '/* '||to_char(CEIL((f.blocks-e.hwm)*(f.bytes/f.blocks)/1024/1024),99999999)||' M */ ' ||
  'alter database datafile '''||file_name||''' resize '||CEIL(e.hwm*(f.bytes/f.blocks)/1024/1024)||'M;' SQL
FROM
  DBA_DATA_FILES f,
  SYS.TS$ t,
  (SELECT ktfbuefno relative_fno,ktfbuesegtsn ts#,
  MAX(ktfbuebno+ktfbueblks) hwm FROM sys.x$ktfbue GROUP BY ktfbuefno,ktfbuesegtsn) e
WHERE
  f.relative_fno=e.relative_fno and t.name=f.tablespace_name and t.ts#=e.ts#
  and f.blocks-e.hwm > 1000
ORDER BY f.blocks-e.hwm DESC
/


CREATE TABLESPACE APPS_TS_BOM_DATA DATAFILE '/rpool/ERPSPC/db/apps_st/data/apps_ts_bom_data_fno_01.dbf' SIZE 10G;

alter tablespace APPS_TS_BOM_DATA add datafile '/rpool/ERPSPC/db/apps_st/data/apps_ts_bom_data_fno_02.dbf' size 10G;

alter tablespace APPS_TS_BOM_DATA add datafile '/rpool/ERPSPC/db/apps_st/data/apps_ts_bom_data_fno_03.dbf' size 10G;

CREATE TABLESPACE APPS_TS_BOM_IDX DATAFILE '/rpool/ERPSPC/db/apps_st/data/apps_ts_bom_idx_fno_01.dbf' SIZE 10G;

alter tablespace APPS_TS_BOM_IDX add datafile '/rpool/ERPSPC/db/apps_st/data/apps_ts_bom_idx_fno_02.dbf' size 10G;

alter tablespace APPS_TS_BOM_IDX add datafile '/rpool/ERPSPC/db/apps_st/data/apps_ts_bom_idx_fno_03.dbf' size 10G;

CREATE TABLESPACE APPS_TS_INV_DATA DATAFILE '/rpool/ERPSPC/db/apps_st/data/apps_ts_inv_data_fno_01.dbf' SIZE 10G;

alter tablespace APPS_TS_INV_DATA add datafile '/rpool/ERPSPC/db/apps_st/data/apps_ts_inv_data_fno_02.dbf' size 10G;

alter tablespace APPS_TS_INV_DATA add datafile '/rpool/ERPSPC/db/apps_st/data/apps_ts_inv_data_fno_03.dbf' size 10G;

CREATE TABLESPACE APPS_TS_INV_IDX DATAFILE '/rpool/ERPSPC/db/apps_st/data/apps_ts_inv_idx_fno_01.dbf' SIZE 10G;

alter tablespace APPS_TS_INV_IDX add datafile '/rpool/ERPSPC/db/apps_st/data/apps_ts_inv_idx_fno_02.dbf' size 10G;

alter tablespace APPS_TS_INV_IDX add datafile '/rpool/ERPSPC/db/apps_st/data/apps_ts_inv_idx_fno_03.dbf' size 10G;

CREATE TABLESPACE APPS_TS_FA_DATA DATAFILE '/rpool/ERPSPC/db/apps_st/data/apps_ts_fa_data_fno_01.dbf' SIZE 10G;

alter tablespace APPS_TS_FA_DATA add datafile '/rpool/ERPSPC/db/apps_st/data/apps_ts_fa_data_fno_02.dbf' size 10G;

alter tablespace APPS_TS_FA_DATA add datafile '/rpool/ERPSPC/db/apps_st/data/apps_ts_fa_data_fno_03.dbf' size 10G;

CREATE TABLESPACE APPS_TS_FA_IDX DATAFILE '/rpool/ERPSPC/db/apps_st/data/apps_ts_fa_idx_fno_01.dbf' SIZE 10G;

alter tablespace APPS_TS_FA_IDX add datafile '/rpool/ERPSPC/db/apps_st/data/apps_ts_fa_idx_fno_02.dbf' size 10G;

alter tablespace APPS_TS_FA_IDX add datafile '/rpool/ERPSPC/db/apps_st/data/apps_ts_fa_idx_fno_03.dbf' size 10G;

set line 1000
set heading off
select 
'alter database datafile ' || ''''||d.name||''''||' resize ' ||trunc(bytes*0.9/1024/1024)||'M ;' sql_clause
from v$datafile  d, v$tablespace ts ,
              (select a.tablespace_name tablespace_name,
                            round(b.bytes/(1024*1024)) "Used",
                            round(a.user_bytes/(1024*1024)) "Size" ,
                            round(100*b.bytes/a.user_bytes,2) usage1
               from       ( select tablespace_name,sum(user_bytes)  user_bytes
                                   from  dba_data_files
                                    group by tablespace_name
                                   union 
                                 select tablespace_name,sum(user_bytes)  user_bytes
                                   from  dba_temp_files
                                    group by tablespace_name) a,
                                ( select tablespace_name, sum(bytes)   bytes
                                          from dba_segments
                                          group by tablespace_name
                union
                                 select tablespace_name,(sum(total_blocks)*8192) bytes 
                                           from v$sort_segment
                        group by tablespace_name) b
              where a.tablespace_name=b.tablespace_name (+)
              order by a.tablespace_name) v
where d.TS# =ts.TS# 
and ts.NAME=v.tablespace_name
and v.usage1<90;
