DECLARE
  duplicate_responsibility EXCEPTION;
  PRAGMA EXCEPTION_INIT(duplicate_responsibility, -20001);
  i INTEGER := 0;
  no_action_required EXCEPTION;
  p_user_id NUMBER(10);
  c_user    varchar2(50) := '';
  CURSOR Cur1 IS
    SELECT fu.user_id,
           fu.user_name,
           fu.last_logon_date,
           frt.responsibility_name,
           fr.creation_date          respon_creation,
           furg.start_date           assign_start_date,
           furg.end_date             assign_end_date,
           fr.responsibility_key,
           fa.application_short_name,
           fr.application_id,
           fr.responsibility_id
      FROM fnd_user_resp_groups_direct   furg,
           applsys.fnd_user              fu,
           applsys.fnd_responsibility_tl frt,
           applsys.fnd_responsibility    fr,
           applsys.fnd_application_tl    fat,
           applsys.fnd_application       fa
     WHERE furg.user_id = fu.user_id
       AND furg.responsibility_id = frt.responsibility_id
       AND fr.responsibility_id = frt.responsibility_id
       AND fa.application_id = fat.application_id
       AND fr.application_id = fat.application_id
       AND frt.language = USERENV('LANG')
/*       and fu.creation_date <= '15-OCT-2016'
       and fu.creation_date >= '01-JAN-2012'*/
       and (fu.user_name like 'THANGLS.EVNIT%'
       or fu.user_name like 'TLTT.EVNIT%' )
      --and fr.creation_date <= '15-OCT-2018'
       --and fr.creation_date  >= '01-JAN-2012'
       AND (furg.end_date IS NULL OR furg.end_date >= TRUNC(SYSDATE))
     ORDER BY 5 desc, frt.responsibility_name;
BEGIN
  FOR All_User IN Cur1 LOOP
    p_user_id := all_user.user_id;
    c_user    := all_user.user_name;
    BEGIN
      fnd_user_resp_groups_api.update_assignment(user_id                       => p_user_id,
                                                 responsibility_id             => All_User.responsibility_id,
                                                 responsibility_application_id => All_User.application_id,
                                                 security_group_id             => 0,
                                                 start_date                    => All_User.assign_start_date,
                                                 end_date                      => sysdate - 1,
                                                 description                   => 'CLEAN_UP_LOCKED'||to_char(sysdate,'YYYYMMDD_HHmm'));
    
    exception
      when others then
        dbms_output.put_line(c_user || ':' || All_User.responsibility_name || ':' ||
                             sqlcode);
        null;
    END;
    commit;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    COMMIT;
END;
/