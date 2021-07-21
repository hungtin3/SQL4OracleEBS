set pagesize 600
set linesize 150
set head on
set echo off
set feedback on
SET VERIFY OFF


col USER_ID  form a10 
col User_Name form a25
col Creation_Date form a22
col Start_Date form a22
col End_Date  form a22
col start_date  form a22
col Last_Logon_Date   form a22

    SELECT u.User_Id,
       u.User_Name,
       u.Creation_Date,
       u.Start_Date,
       u.End_Date,
       u.Last_Logon_Date
  FROM Fnd_User u
 WHERE 1 = 1
   AND u.Creation_Date >= '01-JAN-2010'
   AND (u.End_Date IS NULL OR u.End_Date >= SYSDATE)
  AND (u.Last_Logon_Date IS NULL OR SYSDATE - u.Last_Logon_Date > 365)
  and (SYSDATE - u.Creation_Date > 365)
 ORDER BY u.Creation_Date DESC;