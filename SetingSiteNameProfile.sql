DECLARE
   v_Check   BOOLEAN;
   v_Profile VARCHAR2(240);
   v_Value varchar2(100);
   v_Profile_Name varchar2(240);
   CURSOR c_Site_Name IS
      SELECT Decode(i.Instance_Name,
                    'ERPEVN',
                    'ERPEVN 8030',
                    'ERPCPC',
                    'ERPCPC 8035',
                    'ERPSPC',
                    'ERPSPC 8040',
                    'ERPGC3',
                    'ERPGE3 8045' ,
                    'ERPNPC',
                    'ERPNPC 8050',
                    'ERPGC2',
                    'ERPGE2 8055',
                    'ERPNPT',
                    'ERPNPT 8060',
                    'ERPGC1',
                    'ERPGE1 8065',
                    'ERPHAN',
                    'ERPHAN 8070',
                    'ERPHCMC',
                    'ERPHCMC 8080',
                    'QA' || i.Instance_Name) Site_Name
        FROM V$instance i;
BEGIN
   --Setting Site Name
   SELECT p.Profile_Option_Name , p.User_Profile_Option_Name
     INTO v_Profile,v_Profile_Name
     FROM Fnd_Profile_Options_Tl p
    WHERE 1 = 1
      AND LANGUAGE = 'US'
      AND User_Profile_Option_Name LIKE 'Site%Name%';
   --exception
   --end;
   for rc in c_Site_Name loop
     v_Value:=rc.Site_Name;
   v_Check := Fnd_Profile.Save(x_Name               => v_Profile,
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
   end loop;
   --Setting Site Color Schema: BLUE, SWAN, TITANIUM ,OLIVE
   SELECT p.Profile_Option_Name , p.User_Profile_Option_Name
     INTO v_Profile,v_Profile_Name
     FROM Fnd_Profile_Options_Tl p
    WHERE 1 = 1
      AND LANGUAGE = 'US'
      AND User_Profile_Option_Name LIKE 'Java Color Scheme%';
	  v_Value:='SWAN';
	  v_Check := Fnd_Profile.Save(x_Name               => v_Profile,
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
EXCEPTION
   WHEN OTHERS THEN
      Dbms_Output.Put_Line('Error: ' || SQLERRM);
END;
/
