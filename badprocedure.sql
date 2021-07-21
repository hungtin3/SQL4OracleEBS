set pagesize 600
set linesize 150
set head on
set echo off
SET feedback off
SET VERIFY off
rem @E:\GoogleDrive\runall\badprocedure.sql

COLUMN Owner FORMAT A10
COLUMN Name FORMAT A30
COLUMN Type FORMAT A20
COLUMN Text FORMAT A75
COLUMN TIMESTAMP FORMAT A20
COLUMN User_Type FORMAT A12

prompt ***** Bad Object Execute immediate*****
SELECT s.Owner, s.Name, s.Type, trim(s.Text) Text, a.TIMESTAMP
  FROM All_Source s, All_Objects a
 WHERE Upper(s.Text) LIKE '%EXECUTE%IMMEDIATE%'
   AND s.Owner NOT IN ('SYS',
                       'APPLSYS ',
                       'CTXSYS',
                       'SYSTEM')
   AND a.Owner NOT IN ('SYS',
                       'APPLSYS ',
                       'CTXSYS',
                       'SYSTEM')
   AND a.Object_Type IN ('PACKAGE',
                         'FUNCTION',
                         'PROCEDURE',
                         'TRIGGER',
                         'VIEW')
   AND s.Owner = a.Owner
   AND s.Name = a.Object_Name
   AND a.Object_Name NOT LIKE '%$%'
   AND To_Date(a.Timestamp,
               'YYYY-MM-DD:HH24:MI:SS') >= Trunc(SYSDATE - 365*2)
 ORDER BY a.Timestamp DESC;

 prompt ***** Bad Object Decrypt password*****
 SELECT s.Owner, s.Name, s.Type, trim(s.Text) Text, a.TIMESTAMP
  FROM All_Source s, All_Objects a
 WHERE Upper(s.Text) LIKE '%WEBSESSIONMANAGERPROC.DECRYPT%'
   AND s.Owner NOT IN ('SYS',
                       'APPLSYS',
                       'CTXSYS',
                       'SYSTEM')
   AND a.Owner NOT IN ('SYS',
                       'APPLSYS',
                       'CTXSYS',
                       'SYSTEM')
   AND a.Object_Type IN ('PACKAGE',
                         'FUNCTION',
                         'PROCEDURE',
                         'TRIGGER',
                         'VIEW')
   AND s.Owner = a.Owner
   AND s.Name = a.Object_Name
   AND a.Object_Name NOT LIKE '%$%'
   AND To_Date(a.Timestamp,
               'YYYY-MM-DD:HH24:MI:SS') >= Trunc(SYSDATE - 365*3)
 ORDER BY a.Timestamp DESC;
