--System Administrator Reports
/*********************************************************
*PURPOSE: To Add JTP Purge to a Request Group System Administrator Reports from backend*
--AddPageAccessTrackingPurgeDataRequest.sql
*AUTHOR: HungNT
Function Used:
Apps.Fnd_Program.Add_To_Group  
Apps.Fnd_Program.remove_from_group
**********************************************************/
--
DECLARE
   l_Program_Short_Name  VARCHAR2(200);
   l_Program_Application VARCHAR2(200);
   l_Request_Group       VARCHAR2(200);
   l_Group_Application   VARCHAR2(200);
   l_Check               VARCHAR2(2);
   --
   CURSOR c_Program IS
      SELECT c.Concurrent_Program_Name,
             c.User_Concurrent_Program_Name,
             a.Application_Name,
             c.Application_Id,
             a.Application_Short_Name,
             c.Creation_Date,
             c.Enabled_Flag
        FROM Fnd_Concurrent_Programs_Vl c, Fnd_Application_Vl a
       WHERE 1 = 1
         AND c.Application_Id = a.Application_Id
            --AND c.User_Concurrent_Program_Name LIKE '%GL%016%'
         AND (c.User_Concurrent_Program_Name LIKE
             '%Page Access Tracking Data Migration' OR
             c.User_Concurrent_Program_Name LIKE
             'Page Access Tracking Purge Data')
         AND c.Enabled_Flag = 'Y'
       ORDER BY Creation_Date;
   CURSOR c_Request_Group IS
      SELECT Frg.Application_Id,
             a.Application_Name,
             a.Application_Short_Name,
             Frg.Request_Group_Name,
             Frg.Description
        FROM Fnd_Request_Groups Frg, Fnd_Application_Vl a
       WHERE 1 = 1
         AND Frg.Application_Id = a.Application_Id
         AND Request_Group_Name LIKE '%%System Administrator Reports%'
       ORDER BY 1;
BEGIN
   FOR r_Program IN c_Program LOOP
      l_Program_Short_Name  := r_Program.Concurrent_Program_Name;
      l_Program_Application := r_Program.Application_Name;
      FOR r_Request_Group IN c_Request_Group LOOP
         l_Request_Group     := r_Request_Group.Request_Group_Name;
         l_Group_Application := r_Request_Group.Application_Name;
         BEGIN
            Apps.Fnd_Program.Remove_From_Group(l_Program_Short_Name,
                                               l_Program_Application,
                                               l_Request_Group,
                                               l_Group_Application);
            Apps.Fnd_Program.Add_To_Group(Program_Short_Name  => l_Program_Short_Name,
                                          Program_Application => l_Program_Application,
                                          Request_Group       => l_Request_Group,
                                          Group_Application   => l_Group_Application);
            --
            Dbms_Output.Put_Line('Adding Concurrent Program:' ||
                                 l_Program_Short_Name ||
                                 ' to Request Group ' || l_Request_Group ||
                                 ' Succeeded');
            --
         EXCEPTION
            WHEN No_Data_Found THEN
               Dbms_Output.Put_Line('Adding Concurrent Program:' ||
                                    l_Program_Short_Name ||
                                    ' to Request Group ' ||
                                    l_Request_Group || ' Failed');
         END;
      END LOOP;
   END LOOP;
   COMMIT;
END;
/