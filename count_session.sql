--create table session_stat as
/*
insert into session_stat
SELECT sysdate as NgayGio, i.instance_name, decode(Icx.Function_Type, 'JSP', 'Web Sessions: ', 'FORM', 'Form Sessions:', 'Os Sessions:') Session_Type,
       COUNT(*) CountA
  FROM Icx_Sessions Icx, v$instance i
 WHERE 1 = 1
   AND Icx.Disabled_Flag != 'Y'
   AND Icx.Pseudo_Flag = 'N'
   AND Guest = 'N'
   AND (Icx.Last_Connect +
       Decode(Fnd_Profile.Value('ICX_SESSION_TIMEOUT'),
               NULL,
               Limit_Time,
               0,
               Limit_Time,
               Fnd_Profile.Value('ICX_SESSION_TIMEOUT') / 60) / 24) >
       SYSDATE
   AND Icx.Counter < Icx.Limit_Connects
 GROUP BY i.instance_name, decode(Icx.Function_Type, 'JSP', 'Web Sessions: ', 'FORM', 'Form Sessions:', 'Os Sessions:')
 order by 1;
commit;
*/

SELECT sysdate as NgayGio, i.instance_name, decode(Icx.Function_Type, 'JSP', 'Web Sessions: ', 'FORM', 'Form Sessions:', 'Os Sessions:') Session_Type,
       COUNT(*) CountA
  FROM Icx_Sessions Icx, v$instance i
 WHERE 1 = 1
   AND Icx.Disabled_Flag != 'Y'
   AND Icx.Pseudo_Flag = 'N'
   AND Guest = 'N'
   AND (Icx.Last_Connect +
       Decode(Fnd_Profile.Value('ICX_SESSION_TIMEOUT'),
               NULL,
               Limit_Time,
               0,
               Limit_Time,
               Fnd_Profile.Value('ICX_SESSION_TIMEOUT') / 60) / 24) >
       SYSDATE
   AND Icx.Counter < Icx.Limit_Connects
 GROUP BY i.instance_name, decode(Icx.Function_Type, 'JSP', 'Web Sessions: ', 'FORM', 'Form Sessions:', 'Os Sessions:')
 order by 1;