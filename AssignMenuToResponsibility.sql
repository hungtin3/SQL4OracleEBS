--Update menuid to responsibility
DECLARE
   c_Response  VARCHAR2(100) := '';
   c_Menu_Name VARCHAR2(1000) := '';
   CURSOR c_Menu_List IS
      SELECT Menu_Id, m.Menu_Name mnu, m.User_Menu_Name
        FROM Fnd_Menus_Vl m
       WHERE User_Menu_Name = 'GL_THHN_CONSO_MANAGER';
   --v_Menu_Id :=86758;-- c.Menu_Id;;
   CURSOR c_Respons IS
	SELECT Fr.Responsibility_Id,
             Fr.Application_Id,
             Fr.Data_Group_Application_Id,
             Fr.Data_Group_Id,
             Fr.Menu_Id,
             Fr.Web_Host_Name,
             Fr.Web_Agent_Name,
             Fr.Group_Application_Id,
             Fr.Request_Group_Id,
             Frt.Responsibility_Name,
             Frt.Description,
             Fr.Start_Date,
             Fr.Version,
             Fr.Responsibility_Key
        FROM Fnd_Responsibility_Tl Frt, Fnd_Responsibility Fr, V$instance i
       WHERE Fr.Responsibility_Id = Frt.Responsibility_Id
         AND Frt.Language = 'US'
         AND Frt.Application_Id = Fr.Application_Id
				 AND Responsibility_Name  NOT LIKE '%Report%'
         AND (Responsibility_Name LIKE
             '%' || REPLACE(REPLACE(REPLACE(Substr(i.Instance_Name,
                                                    1,
                                                    6),
                                             'ERP',
                                             ''),
                                     'GC',
                                     'GE'),
                             'HCMC',
                             'HCM') || '%THHN%Conso%Man%');
   l_Parent_Menu_Id NUMBER;
   l_Reg_Group_Id   NUMBER;
BEGIN
   /*SELECT request_group_id
    INTO l_reg_group_id
    FROM fnd_request_groups frg
   WHERE 1 = 1
     AND request_group_name = (Request Group Name);*/
   FOR Rc IN c_Menu_List LOOP
      c_Menu_Name := Rc.Mnu;
      BEGIN
         SELECT Menu_Id
           INTO l_Parent_Menu_Id
           FROM Apps.Fnd_Menus_Vl
          WHERE Menu_Name =c_Menu_Name;
      EXCEPTION
         WHEN No_Data_Found THEN
            Dbms_Output.Put_Line(c_Menu_Name || ' Parent Menu not FOUND');
            RETURN;
      END;
      FOR i IN c_Respons LOOP
         BEGIN
            Fnd_Responsibility_Pkg.Update_Row(x_Responsibility_Id         => i.Responsibility_Id,
                                              x_Application_Id            => i.Application_Id,
                                              x_Web_Host_Name             => i.Web_Host_Name,
                                              x_Web_Agent_Name            => i.Web_Agent_Name,
                                              x_Data_Group_Application_Id => i.Data_Group_Application_Id,
                                              x_Data_Group_Id             => i.Data_Group_Id,
                                              x_Menu_Id                   => l_Parent_Menu_Id,
                                              x_Start_Date                => i.Start_Date,
                                              x_End_Date                  => NULL,
                                              x_Group_Application_Id      => i.Group_Application_Id,
                                              x_Request_Group_Id          => i.Request_Group_Id,
                                              x_Version                   => i.Version,
                                              x_Responsibility_Key        => i.Responsibility_Key,
                                              x_Responsibility_Name       => i.Responsibility_Name,
                                              x_Description               => i.Description,
                                              x_Last_Update_Date          => SYSDATE,
                                              x_Last_Updated_By           => -1,
                                              x_Last_Update_Login         => 0);
            COMMIT;
            Dbms_Output.Put_Line(i.Responsibility_Name ||
            ' has been updated !!!');
         EXCEPTION
            WHEN OTHERS THEN
               Dbms_Output.Put_Line('Inner Exception: ' || SQLERRM);
         END;
      END LOOP;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      Dbms_Output.Put_Line('Main Exception: ' || SQLERRM);
END;
/