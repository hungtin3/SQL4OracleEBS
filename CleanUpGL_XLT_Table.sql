rem @E:\runall\CleanUpGL_XLT_Table.sql
set heading off
set feedback off
set pagesize 600
set linesize 150
set echo off
SET VERIFY OFF

spool compile_all.sql

SELECT 'drop ' || Object_Type || ' ' || a.Owner || '.' || a.Object_Name || ' ;' Sqlst
  FROM All_Objects a
 WHERE 1 = 1
   AND 
   ((Owner ='GL' and Object_Type  ='TABLE')
   OR (Owner ='APPS' and Object_Type  ='SYNONYM'))
   AND (Object_Name LIKE 'XLA_GLT%' or object_name like 'GL_CONS_INTERFACE%')
   AND To_Date(a.Timestamp,
               'YYYY-MM-DD:HH24:MI:SS') <= Trunc(SYSDATE - 15)
 ORDER BY To_Date(a.Timestamp,
                  'YYYY-MM-DD:HH24:MI:SS') DESC;
spool off

set heading on
set feedback on
set echo on
set timing on
SET VERIFY on
start compile_all.sql

