------failed login-------------
select fu.user_name || ' ' ||
       to_char(ful.attempt_time, 'DD-MON-YYYY:HH24:MI') || ' ' ||
       ful.login_name || ' ' || ful.terminal_id
  from fnd_user fu, FND_UNSUCCESSFUL_LOGINS ful
 where ful.user_id = fu.user_id(+)
   and ful.attempt_time > sysdate - 1
   order by ful.attempt_time desc;
   
   
----Active user---------------------------
select user_name, start_date, end_date
  from fnd_user
 where end_date is null
   and employee_id is null
   order by start_date desc;
-----User Login Activities--------------------------
select fu.user_name,
       to_char(fl.start_time, 'DD-MON-YYYY:HH24:MI') start_time,
       to_char(fl.end_time, 'DD-MON-YYYY:HH24:MI') end_time, 
       fl.terminal_id,
       fl.login_type
  from FND_LOGINS fl, fnd_user fu
 where fl.user_id = fu.user_id(+)
   and fl.start_time >= sysdate - 2
   and nvl(fl.Terminal_id,' ') <> 'Concurrent'
 order by fl.start_time desc;
-------------Response Login information------------------------
select frv.responsibility_name, flr.start_time, flr.end_time, fu.user_name
  from APPLSYS.FND_LOGIN_RESPONSIBILITIES flr,
       FND_RESPONSIBILITY_VL              frv,
       FND_LOGINS                         fl,
       fnd_user                           fu
 where flr.RESPONSIBILITY_ID = frv.RESPONSIBILITY_ID
   --and frv.responsibility_name = 'Application Developer'
   and fl.login_id = flr.login_id
   and fl.user_id = fu.user_id
   and flr.start_time >=sysdate-1
 order by flr.start_time desc, fu.user_name;
 ------User Activities by Form-------------------------------------------
 select frv.responsibility_name,
       flr.start_time,
       flr.end_time,
       fu.user_name,
       ff.user_form_name
  from FND_LOGIN_RESPONSIBILITIES flr,
       FND_RESPONSIBILITY_VL      frv,
       FND_LOGINS                 fl,
       fnd_user                   fu,
       FND_LOGIN_RESP_FORMS       flrf,
       FND_FORM_VL                ff
 where flr.RESPONSIBILITY_ID = frv.RESPONSIBILITY_ID
   and flrf.login_id = flr.login_id
   and flrf.LOGIN_RESP_ID = flr.LOGIN_RESP_ID
      --and frv.responsibility_name = :P_RESPONSIBILITY_NAME --'Application Developer'
   and flr.start_time > sysdate - 1
   and fl.login_id = flr.login_id
   and fl.user_id = fu.user_id
   and ff.form_id = flrf.form_id
 order by flr.start_time desc, fu.user_name;
