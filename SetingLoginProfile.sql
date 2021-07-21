DECLARE
   --Setup Password profile 
   v_Check        BOOLEAN;
   v_Profile_Name VARCHAR2(240);
   v_Profile      VARCHAR2(240);
   v_Value        VARCHAR2(100);
   CURSOR c_Profile IS
      SELECT p.Profile_Option_Name,
             p.User_Profile_Option_Name,
             (CASE
                WHEN p.User_Profile_Option_Name = 'Signon Password Case' THEN
                 '2' --Sensitive
                WHEN p.User_Profile_Option_Name =
                     'Signon Password Failure Limit' THEN
                 '15'
                WHEN p.User_Profile_Option_Name =
                     'Signon Password Hard To Guess' THEN
                 'Y'
                WHEN p.User_Profile_Option_Name = 'Signon Password Length' THEN
                 '8'
                WHEN p.User_Profile_Option_Name = 'Signon Password No Reuse' THEN
                 '356'
                WHEN p.User_Profile_Option_Name = 'Sign-On:Audit Level' THEN
                 'D'
                WHEN p.User_Profile_Option_Name = 'Sign-On:Notification' THEN
                 'N'
								 WHEN p.User_Profile_Option_Name = 'GL: Number of Records to Process at Once ' THEN
                 '25000'
								 WHEN p.User_Profile_Option_Name = 'GL: Number of Accounts In Memory ' THEN
                 '2500'
								 WHEN p.User_Profile_Option_Name = 'GL: Archive Journal Import Data ' THEN
                 'No'
             END) p_Value
        FROM Fnd_Profile_Options_Tl p
       WHERE 1 = 1
         AND LANGUAGE = 'US'
         AND User_Profile_Option_Name IN
             ('Signon Password Case',
              'Signon Password Failure Limit',
              'Signon Password Hard To Guess',
              'Signon Password Length',
              'Signon Password No Reuse',
              'Sign-On:Audit Level',
              'Sign-On:Notification',
              'GL: Number of Records to Process at Once',
              'GL: Number of Accounts In Memory',
              'GL: Archive Journal Import Data')
          --OR User_Profile_Option_Name LIKE 'GL%'
       ORDER BY 2;
   --AND User_Profile_Option_Name LIKE 'Sign%';
BEGIN
   FOR Rc IN c_Profile LOOP
      v_Profile := Rc.Profile_Option_Name;
      v_Value   := Rc.p_Value;
      v_Check   := Fnd_Profile.Save(x_Name               => v_Profile,
                                    x_Value              => v_Value,
                                    x_Level_Name         => 'SITE',
                                    x_Level_Value        => NULL,
                                    x_Level_Value_App_Id => NULL);
      IF v_Check THEN
         Dbms_Output.Put_Line('Profile ' || v_Profile_Name ||
                              ' updated with ' || v_Value);
         COMMIT;
      ELSE
         Dbms_Output.Put_Line('Error while updating Profile ' ||
                              v_Profile_Name || ' with value ' || v_Value);
      END IF;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      Dbms_Output.Put_Line('Error: ' || SQLERRM);
END;
/
