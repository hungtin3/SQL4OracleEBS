set pagesize 600
set linesize 150
set head on
set echo off
SET feedback off
SET VERIFY off
rem @E:\GoogleDrive\runall\NewDBAudit.sql

prompt ***** User with default password *****
COLUMN Instance_Name FORMAT A45
COLUMN Created FORMAT A12

/*SELECT i.Instance_Name, d.*, trunc(u.Created) Created
  FROM Dba_Users_With_Defpwd d, Sys.Dba_Users u, V$instance i
 WHERE d.Username = u.Username
 ORDER BY u.Created DESC;*/
 
prompt ***** Count user with default password *****
COLUMN Instance_Name FORMAT A10

SELECT i.Instance_Name, count(*) 
  FROM Dba_Users_With_Defpwd d, Sys.Dba_Users u, V$instance i
 WHERE d.Username = u.Username
 group by i.Instance_Name
 ;
 
prompt ***** Old/New User *****
COLUMN Instance_Name FORMAT A10
COLUMN User_Id FORMAT A12
COLUMN Username FORMAT A25
COLUMN Account_Status FORMAT A25
COLUMN Default_Tablespace FORMAT A25
COLUMN User_Type FORMAT A12

SELECT i.Instance_Name,
       u.User_Id,
       u.Username,
       u.Account_Status,
       u.Default_Tablespace,
       trunc(u.Created) Created,
       CASE
          WHEN u.Created > '01-JAN-2012' THEN
           'New User'
          ELSE
           'Default User'
       END User_Type
  FROM Sys.Dba_Users u, V$instance i
  where
  CASE
          WHEN u.Created > '01-JAN-2012' THEN
           'New User'
          ELSE
           'Default User'
       END ='New User'
 ORDER BY u.Created DESC;

prompt ***** Old/New User count*****
COLUMN Instance_Name FORMAT A20
COLUMN User_Id FORMAT A12
COLUMN Username FORMAT A12
COLUMN Account_Status FORMAT A12
COLUMN Default_Tablespace FORMAT A12
COLUMN User_Type FORMAT A12

select Instance_Name, User_Type,  count(*)
from
(
SELECT i.Instance_Name,
       u.User_Id,
       u.Username,
       u.Account_Status,
       u.Default_Tablespace,
       trunc(u.Created) Created,
       CASE
          WHEN u.Created > '01-JAN-2012' THEN
           'New User'
          ELSE
           'Default User'
       END User_Type
  FROM Sys.Dba_Users u, V$instance i
 ORDER BY u.Created DESC
 )
 group by Instance_Name,User_Type order by user_type;

prompt ***** Old/New User Roles *****
COLUMN Instance_Name FORMAT A10
COLUMN Role FORMAT A30
COLUMN Authentication_Type FORMAT A12
COLUMN Created FORMAT A12
COLUMN Default_Tablespace FORMAT A12
COLUMN Role_Type FORMAT A12
 
 SELECT i.Instance_Name,
       r.Role,
       r.Authentication_Type,
       To_Char(c.Ctime,
               'DD-MON-YYYY') Created,
       CASE
          WHEN c.Ctime > '01-JAN-2012' THEN
           'New Role'
          ELSE
           'Default Role'
       END Role_Type
  FROM Sys.Dba_Roles r, Sys.User$ c, V$instance i
 WHERE r.Role = c.Name
 and 
 CASE
          WHEN c.Ctime > '01-JAN-2012' THEN
           'New Role'
          ELSE
           'Default Role'
       END ='New Role'
 ORDER BY c.Ctime DESC;
 
prompt ***** Bad Roles grant*****
COLUMN Instance_Name FORMAT A10
COLUMN Grantee FORMAT A30
COLUMN Granted_Role FORMAT A30
COLUMN Admin_Option FORMAT A12
COLUMN Default_Tablespace FORMAT A12
COLUMN Role_Type FORMAT A12
 
SELECT i.Instance_Name, Grantee, Granted_Role, Admin_Option
  FROM Sys.Dba_Role_Privs, V$instance i
 WHERE 1 = 1
   AND (Granted_Role IN ('DBA',
                         'AQ_ADMINISTRATOR_ROLE',
                         'EXP_FULL_DATABASE',
                         'IMP_FULL_DATABASE',
                         'OEM_MONITOR','CONNECT', 'RESOURCE') OR
       Granted_Role IN (SELECT r.Role
                           FROM Sys.Dba_Roles r, Sys.User$ c, V$instance i
                          WHERE r.Role = c.Name
                            AND CASE
                                   WHEN c.Ctime > '01-JAN-2012' THEN
                                    'New Role'
                                   ELSE
                                    'Default Role'
                                END = 'New Role'))
   AND Grantee NOT IN ('SYS',
                       'SYSTEM',
                       'OUTLN',
                       'AQ_ADMINISTRATOR_ROLE',
                       'DBA',
                       'EXP_FULL_DATABASE',
                       'IMP_FULL_DATABASE',
                       'OEM_MONITOR',
                       'CTXSYS',
                       'DBSNMP',
                       'IFSSYS',
                       'IFSSYS$CM',
                       'MDSYS',
                       'ORDPLUGINS',
                       'ORDSYS',
                       'TIMESERIES_DBA',
					   'DATAPUMP_EXP_FULL_DATABASE',
					   'DATAPUMP_IMP_FULL_DATABASE',
					   'EXECUTE_CATALOG_ROLE',
					   'SPATIAL_CSW_ADMIN_USR',
					   'SPATIAL_WFS_ADMIN_USR',
					   'HS_ADMIN_ROLE')
 ORDER BY Grantee;
 
prompt ***** Bad PRIVILEGES grant*****
COLUMN Instance_Name FORMAT A10
COLUMN Grantee FORMAT A30
COLUMN Privilege FORMAT A30
COLUMN Admin_Option FORMAT A12
COLUMN Default_Tablespace FORMAT A12
COLUMN Role_Type FORMAT A12

/*
SELECT Dsp.Grantee,
       Dsp.Privilege,
       Decode(Admin_Option,
              'YES',
              'WITH ADMIN OPTION') Admin_Option,
       'revoke ' || Dsp.Privilege || ' from ' || Dsp.Grantee || ';' Revoke_Sql
  FROM Dba_Sys_Privs Dsp
 WHERE 1 = 1
   AND (Privilege = 'CREATE USER' OR Privilege = 'BECOME USER' OR
       Privilege = 'ALTER USER' OR Privilege = 'DROP USER' OR
       Privilege = 'CREATE ROLE' OR Privilege = 'ALTER ANY ROLE' OR
       Privilege = 'DROP ANY ROLE' OR Privilege = 'GRANT ANY ROLE' OR
       Privilege = 'CREATE PROFILE' OR Privilege = 'ALTER PROFILE' OR
       Privilege = 'DROP PROFILE' OR Privilege = 'CREATE ANY TABLE' OR
       Privilege = 'ALTER ANY TABLE' OR Privilege = 'DROP ANY TABLE' OR
       Privilege = 'INSERT ANY TABLE' OR Privilege = 'UPDATE ANY TABLE' OR
       Privilege = 'DELETE ANY TABLE' OR
       Privilege = 'CREATE ANY PROCEDURE' OR
       Privilege = 'ALTER ANY PROCEDURE' OR
       Privilege = 'DROP ANY PROCEDURE' OR
       Privilege = 'CREATE ANY TRIGGER' OR Privilege = 'ALTER ANY TRIGGER' OR
       Privilege = 'DROP ANY TRIGGER' OR Privilege = 'CREATE TABLESPACE' OR
       Privilege = 'ALTER TABLESPACE' OR Privilege = 'DROP TABLESPACES' OR
       Privilege = 'ALTER DATABASE' OR Privilege = 'ALTER SYSTEM' OR
       Privilege LIKE '%ANY%')
       --AND Dsp.Grantee IN (SELECT c.Name
       --             FROM Sys.User$ c
       --            WHERE CASE
       --                     WHEN c.Ctime > '01-JAN-2012' THEN
       --                      'New Role'
       --                     ELSE
       --                      'Default Role'
       --                  END = 'New Role')
	   --AND Sp.Grantee NOT IN
	   --(SELECT u.Username FROM Sys.Dba_Users u WHERE u.User_Id <= 300)
 ORDER BY Dsp.Grantee;
*/

select Instance_Name,Grantee, count(*) from 
(
SELECT i.Instance_Name,Dsp.Grantee,
       Dsp.Privilege,
       Decode(Admin_Option,
              'YES',
              'WITH ADMIN OPTION') Admin_Option,
       'revoke ' || Dsp.Privilege || ' from ' || Dsp.Grantee || ';' Revoke_Sql
  FROM Dba_Sys_Privs Dsp, v$instance i
 WHERE 1 = 1
   AND (Privilege = 'CREATE USER' OR Privilege = 'BECOME USER' OR
       Privilege = 'ALTER USER' OR Privilege = 'DROP USER' OR
       Privilege = 'CREATE ROLE' OR Privilege = 'ALTER ANY ROLE' OR
       Privilege = 'DROP ANY ROLE' OR Privilege = 'GRANT ANY ROLE' OR
       Privilege = 'CREATE PROFILE' OR Privilege = 'ALTER PROFILE' OR
       Privilege = 'DROP PROFILE' OR Privilege = 'CREATE ANY TABLE' OR
       Privilege = 'ALTER ANY TABLE' OR Privilege = 'DROP ANY TABLE' OR
       Privilege = 'INSERT ANY TABLE' OR Privilege = 'UPDATE ANY TABLE' OR
       Privilege = 'DELETE ANY TABLE' OR
       Privilege = 'CREATE ANY PROCEDURE' OR
       Privilege = 'ALTER ANY PROCEDURE' OR
       Privilege = 'DROP ANY PROCEDURE' OR
       Privilege = 'CREATE ANY TRIGGER' OR Privilege = 'ALTER ANY TRIGGER' OR
       Privilege = 'DROP ANY TRIGGER' OR Privilege = 'CREATE TABLESPACE' OR
       Privilege = 'ALTER TABLESPACE' OR Privilege = 'DROP TABLESPACES' OR
       Privilege = 'ALTER DATABASE' OR Privilege = 'ALTER SYSTEM' OR
       Privilege LIKE '%ANY%')
       AND (Dsp.Grantee IN (SELECT c.Name
                    FROM Sys.User$ c
                   WHERE CASE
                            WHEN c.Ctime > '01-JAN-2012' THEN
                             'New'
                            ELSE
                             'Default'
                         END = 'New')
	   or Dsp.Grantee NOT IN
	   (SELECT u.Username FROM Sys.Dba_Users u WHERE u.User_Id <= 300))
)
group by Instance_Name,Grantee ORDER BY Grantee
;


prompt ***** Bad Object PRIVILEGES grant*****
COLUMN Instance_Name FORMAT A10
COLUMN Grantee FORMAT A30
COLUMN Owner FORMAT A30
COLUMN Admin_Option FORMAT A12
COLUMN Default_Tablespace FORMAT A12
COLUMN Role_Type FORMAT A12

SELECT Instance_Name, Grantee, Owner,Privilege, COUNT(*)
  FROM (SELECT i.Instance_Name,
               Tp.Grantee,
               Tp.Owner,
               Tp.Table_Name,
               Tp.Privilege,
               Tp.Grantor,
               'revoke ' || Tp.Privilege || ' on ' || Tp.Owner || '.' ||
               Tp.Table_Name || ' from ' || Tp.Grantee || ';' Revoke_Clause
          FROM Sys.Dba_Tab_Privs Tp, V$instance i
         WHERE 1 = 1
           AND Tp.Grantee NOT IN
               (SELECT u.Username FROM Sys.Dba_Users u WHERE u.User_Id <= 300)
           AND Tp.Grantee NOT IN
               ('SPATIAL_CSW_ADMIN_USR','SPATIAL_WFS_ADMIN_USR', 'SYSMAN')
			   AND Tp.Grantee IN (SELECT c.Name
                                FROM Sys.User$ c
                               WHERE CASE
                                        WHEN c.Ctime > '01-JAN-2012' THEN
                                         'New'
                                        ELSE
                                         'Default'
                                     END = 'New')
           AND Tp.Privilege NOT IN ('SELECT',
                                    'EXECUTE', 'DEBUG')
         ORDER BY 2, 3)
 GROUP BY Instance_Name, Grantee, Owner, Privilege
 ORDER BY Instance_Name, Grantee ;
