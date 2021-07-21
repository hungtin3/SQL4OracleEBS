set pagesize 600
set linesize 150
set head on
set echo off
set feedback on
SET VERIFY OFF

column sql_stm format A120
SELECT distinct 
       User_Id,
                Host,
                Ip_Address,
                'insert into Login_Ctl values(' || '''' || User_Id || '''' || ',' || '''' || Host || '''' || ',' || '''' ||
                nvl(ip_address,'*') || '' || '''' ||','||'''' ||'Descr'||''''||');' sql_stm
  FROM System.User_Log Ul
 WHERE 1 = 1
      --AND Host LIKE 'ERPDB01'
   AND Ul.Login_Date >= SYSDATE - 90
 ORDER BY --ul.login_date desc,
 User_Id, host ;
