set pagesize 600
set linesize 150
set head on
set echo off
SET VERIFY OFF

prompt ***** Database object changed*****
col last_ddl_time form a25 
col last_change form a25 
col Full_Object_Name form a40
col OBJECT_TYPE form a20
col status form a20
col enable_trace  form a15 
col start_date  form a15
col end_date   form a15
col Instance_Name form a15

SELECT i.Instance_Name,
       a.Timestamp Last_Change,
       a.Owner || '.' || a.Object_Name "Full_Object_Name",
       a.Object_Type,
       a.Status
  FROM All_Objects a,
       V$instance  i
 WHERE 1 = 1
   AND Owner NOT IN ('SYS', 'APPLSYS', 'CTXSYS')
   AND Object_Type IN
       ('PACKAGE', 'FUNCTION', 'PROCEDURE', 'TRIGGER', 'VIEW', 'INDEX ')
   AND a.Object_Name NOT LIKE '%$%'
      --AND to_date(a.LAST_DDL_TIME) >= trunc(SYSDATE - 30)
   AND To_Date(a.Timestamp, 'YYYY-MM-DD:HH24:MI:SS') >= Trunc(SYSDATE - 30)
 ORDER BY a.Timestamp DESC;

