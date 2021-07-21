--Setting GL: Profile value
--2021-Jan-12
DECLARE
   v_Check        BOOLEAN;
   v_Profile_Name VARCHAR2(240) := '';
   v_Profile      VARCHAR2(240);
   v_Value        VARCHAR2(10) := 'N';
   v_Resp_Name    VARCHAR2(240) := '';
   v_Resp_Id      NUMBER;
   v_Resp_App_Id  NUMBER;
   v_Appl_Name    VARCHAR2(4) := '';
   v_Appl_Id      NUMBER;
   v_User_Name    VARCHAR2(240) := '';
   v_User_Id      NUMBER;
   CURSOR c_Profile IS
      SELECT p.Profile_Option_Name Short_Name,
             n.User_Profile_Option_Name NAME,
             Decode(v.Level_Id,
                    10001,
                    'Site',
                    10002,
                    'Application',
                    10003,
                    'Responsibility',
                    10004,
                    'User',
                    10005,
                    'Server',
                    'UnDef') Level_Set,
             Decode(To_Char(v.Level_Id),
                    '10001',
                    NULL,
                    '10002',
                    App.Application_Short_Name,
                    '10003',
                    Rsp.Responsibility_Key,
                    '10005',
                    Svr.Node_Name,
                    '10006',
                    Org.Name,
                    '10004',
                    Usr.User_Name,
                    'UnDef') CONTEXT,
             v.Profile_Option_Value VALUE,
             (CASE
                WHEN p.Profile_Option_Name =
                     'GL_GLLEZL_ARCHIVE_ROWS' AND
                     v.Profile_Option_Value = 'No' THEN
                 'GOOD'
                WHEN p.Profile_Option_Name =
                     'GL_ACCOUNTS_TO_PROCESS' AND
                     v.Profile_Option_Value =
                     '5000' THEN
                 'GOOD'
                WHEN p.Profile_Option_Name =
                     'GL_RECORDS_TO_PROCESS' AND
                     v.Profile_Option_Value =
                     '50000' THEN
                 'GOOD'
             END) Good_Or_Bad
        FROM Fnd_Profile_Options       p,
             Fnd_Profile_Option_Values v,
             Fnd_Profile_Options_Tl    n,
             Fnd_User                  Usr,
             Fnd_Application           App,
             Fnd_Responsibility        Rsp,
             Fnd_Nodes                 Svr,
             Hr_Operating_Units        Org
       WHERE p.Profile_Option_Id =
             v.Profile_Option_Id(+) AND
             p.Profile_Option_Name =
             n.Profile_Option_Name AND
             Usr.User_Id(+) =
             v.Level_Value AND
             Rsp.Application_Id(+) =
             v.Level_Value_Application_Id AND
             Rsp.Responsibility_Id(+) =
             v.Level_Value AND
             App.Application_Id(+) =
             v.Level_Value AND
             Svr.Node_Id(+) =
             v.Level_Value AND
             Org.Organization_Id(+) =
             v.Level_Value
            --AND v.Level_Id = 10004   --'Site',10002,'Application',10003,'Responsibility',10004,'User',10005,'Server','UnDef'
             AND
             (Upper(n.Profile_Option_Name) IN
             ('GL_GLLEZL_ARCHIVE_ROWS',
               'GL_ACCOUNTS_TO_PROCESS',
               'GL_RECORDS_TO_PROCESS')) AND
             Nvl(Decode(To_Char(v.Level_Id),
                        '10001',
                        NULL,
                        '10002',
                        App.Application_Short_Name,
                        '10003',
                        Rsp.Responsibility_Key,
                        '10005',
                        Svr.Node_Name,
                        '10006',
                        Org.Name,
                        '10004',
                        Usr.User_Name,
                        'UnDef'),
                 'NULL') NOT IN
             ('SYSADMIN',
              'KT.EVNIT')
       ORDER BY 2,
                1;
BEGIN
   --begin
   FOR c IN c_Profile LOOP
      IF c.Short_Name =
         'GL_GLLEZL_ARCHIVE_ROWS' THEN
         v_Value := 'No';
      ELSIF c.Short_Name =
            'GL_ACCOUNTS_TO_PROCESS' THEN
         v_Value := '10000';
      ELSIF c.Short_Name =
            'GL_RECORDS_TO_PROCESS' THEN
         v_Value := '100000';
      ELSE
         v_Value := NULL;
      END IF;
      IF c.Level_Set =
         'Site' OR
         c.Level_Set =
         'UnDef' THEN
         BEGIN
            v_Profile_Name := c.Name;
            SELECT Profile_Option_Name
              INTO v_Profile
              FROM Fnd_Profile_Options_Tl
             WHERE LANGUAGE = 'US' AND
                   User_Profile_Option_Name =
                   v_Profile_Name;
            v_Check := Fnd_Profile.Save(x_Name => v_Profile,
                                        x_Value => v_Value,
                                        x_Level_Name => 'SITE',
                                        x_Level_Value => NULL,
                                        x_Level_Value_App_Id => NULL);
            IF v_Check THEN
               Dbms_Output.Put_Line('Profile site level ' ||
                                    v_Profile_Name ||
                                    ' updated with ' ||
                                    v_Value);
               COMMIT;
            ELSE
               Dbms_Output.Put_Line('Error while updating Profile site level' ||
                                    v_Profile_Name ||
                                    ' with value ' ||
                                    v_Value);
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               Dbms_Output.Put_Line('Error: ' ||
                                    SQLERRM);
         END;
      ELSIF c.Level_Set =
            'Application' THEN
         BEGIN
            v_Profile_Name := c.Name;
            v_Appl_Name    := c.Context;
            SELECT Profile_Option_Name
              INTO v_Profile
              FROM Fnd_Profile_Options_Tl
             WHERE LANGUAGE = 'US' AND
                   User_Profile_Option_Name =
                   v_Profile_Name;
            SELECT Application_Id
              INTO v_Appl_Id
              FROM Fnd_Application
             WHERE Application_Short_Name =
                   v_Appl_Name;
            v_Check := Fnd_Profile.Save(x_Name => v_Profile,
                                        x_Value => v_Value,
                                        x_Level_Name => 'APPL',
                                        x_Level_Value => v_Appl_Id,
                                        x_Level_Value_App_Id => NULL);
            IF v_Check THEN
               Dbms_Output.Put_Line('Profile @ Application Level' ||
                                    v_Profile_Name ||
                                    ' updated with ' ||
                                    v_Value);
               COMMIT;
            ELSE
               Dbms_Output.Put_Line('Error while updating Profile @ Application Level' ||
                                    v_Profile_Name ||
                                    ' with value ' ||
                                    v_Value);
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               Dbms_Output.Put_Line('Error: ' ||
                                    SQLERRM);
         END;
      ELSIF c.Level_Set =
            'Responsibility' THEN
         BEGIN
            v_Profile_Name := c.Name;
            v_Resp_Name    := c.Context;
            SELECT Profile_Option_Name
              INTO v_Profile
              FROM Fnd_Profile_Options_Tl
             WHERE LANGUAGE = 'US' AND
                   User_Profile_Option_Name =
                   v_Profile_Name;
            SELECT Responsibility_Id,
                   Application_Id
              INTO v_Resp_Id,
                   v_Resp_App_Id
              FROM Fnd_Responsibility_Tl
             WHERE Responsibility_Name =
                   v_Resp_Name;
            v_Check := Fnd_Profile.Save(x_Name => v_Profile,
                                        x_Value => v_Value,
                                        x_Level_Name => 'RESP',
                                        x_Level_Value => v_Resp_Id,
                                        x_Level_Value_App_Id => v_Resp_App_Id);
            IF v_Check THEN
               Dbms_Output.Put_Line('Profile @Responsibility ' ||
                                    v_Profile_Name || '-' ||
                                    v_Resp_Name ||
                                    ' updated with ' ||
                                    v_Value);
               COMMIT;
            ELSE
               Dbms_Output.Put_Line('Error while updating Profile @Responsibility ' || '-' ||
                                    v_Resp_Name ||
                                    v_Profile_Name ||
                                    ' with value ' ||
                                    v_Value);
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               Dbms_Output.Put_Line('Error: ' ||
                                    SQLERRM);
         END;
      ELSIF c.Level_Set =
            'User' THEN
         BEGIN
            v_Profile_Name := c.Name;
            v_User_Name    := c.Context;
            SELECT Profile_Option_Name
              INTO v_Profile
              FROM Fnd_Profile_Options_Tl
             WHERE LANGUAGE = 'US' AND
                   User_Profile_Option_Name =
                   v_Profile_Name;
            SELECT User_Id
              INTO v_User_Id
              FROM Fnd_User
             WHERE User_Name =
                   v_User_Name;
            --exception
            --end;
            v_Check := Fnd_Profile.Save(x_Name => v_Profile,
                                        x_Value => v_Value,
                                        x_Level_Name => 'USER',
                                        x_Level_Value => v_User_Id,
                                        x_Level_Value_App_Id => NULL);
            IF v_Check THEN
               Dbms_Output.Put_Line('Profile @User ' ||
                                    v_Profile_Name || '-' ||
                                    v_User_Name ||
                                    ' updated with ' ||
                                    v_Value);
               COMMIT;
            ELSE
               Dbms_Output.Put_Line('Error while updating Profile @User' || '-' ||
                                    v_Profile_Name ||
                                    v_User_Name ||
                                    ' with value ' ||
                                    v_Value);
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               Dbms_Output.Put_Line('Error: ' ||
                                    SQLERRM);
         END;
      ELSE
         NULL;
      END IF;
   END LOOP;
   COMMIT;
END;
/
