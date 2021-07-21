/******************************************************************************
*PURPOSE: To Submit a Request  Purge Concurrent Request and/or Manager Data   *
*AUTHOR: HungNT                             *
******************************************************************************/
DECLARE
   l_Responsibility_Id NUMBER;
   l_Application_Id    NUMBER;
   l_User_Id           NUMBER;
   l_Request_Id        NUMBER;
   l_Boolean           BOOLEAN;
   e_Set_Repeat EXCEPTION;
   e_Set_Option EXCEPTION;
   CURSOR Cs_Program_All IS
      SELECT i.Instance_Name,
             a.Application_Name,
             a.Application_Short_Name,
             Fcp.Concurrent_Program_Name,
             Fcpt.User_Concurrent_Program_Name
        FROM Fnd_Concurrent_Programs    Fcp,
             Fnd_Concurrent_Programs_Tl Fcpt,
             Fnd_Lookup_Values          Flv,
             Fnd_Application_Vl         a,
             V$instance                 i
       WHERE 1 = 1
         AND Fcp.Application_Id = a.Application_Id
         AND Fcp.Concurrent_Program_Id = Fcpt.Concurrent_Program_Id
         AND Flv.Lookup_Type = 'CP_EXECUTION_METHOD_CODE'
         AND Fcp.Execution_Method_Code = Flv.Lookup_Code
         AND Fcpt.Language = 'US'
         AND Flv.Language = 'US'
         AND Fcp.Enabled_Flag = 'Y'
         AND Fcpt.User_Concurrent_Program_Name LIKE 'Purge%'
         AND a.Application_Name LIKE '%Application Object Library%'
       ORDER BY a.Application_Name, Fcp.Creation_Date DESC;
   --
   CURSOR Cs_Program1 IS
      SELECT a.Application_Name,
             a.Application_Short_Name,
             Fcp.Concurrent_Program_Name,
             Fcpt.User_Concurrent_Program_Name
        FROM Fnd_Concurrent_Programs    Fcp,
             Fnd_Concurrent_Programs_Tl Fcpt,
             Fnd_Lookup_Values          Flv,
             Fnd_Application_Vl         a
       WHERE 1 = 1
         AND Fcp.Application_Id = a.Application_Id
         AND Fcp.Concurrent_Program_Id = Fcpt.Concurrent_Program_Id
         AND Flv.Lookup_Type = 'CP_EXECUTION_METHOD_CODE'
         AND Fcp.Execution_Method_Code = Flv.Lookup_Code
         AND Fcpt.Language = 'US'
         AND Flv.Language = 'US'
         AND Fcp.Enabled_Flag = 'Y'
         AND Fcpt.User_Concurrent_Program_Name LIKE
             'Purge Concurrent Request and/or Manager Data%'
         AND a.Application_Name LIKE '%Application Object Library%'
       ORDER BY a.Application_Name, Fcp.Creation_Date DESC;
   --
   CURSOR Cs_Program2 IS
      SELECT a.Application_Name,
             a.Application_Short_Name,
             Fcp.Concurrent_Program_Name,
             Fcpt.User_Concurrent_Program_Name
        FROM Fnd_Concurrent_Programs    Fcp,
             Fnd_Concurrent_Programs_Tl Fcpt,
             Fnd_Lookup_Values          Flv,
             Fnd_Application_Vl         a
       WHERE 1 = 1
         AND Fcp.Application_Id = a.Application_Id
         AND Fcp.Concurrent_Program_Id = Fcpt.Concurrent_Program_Id
         AND Flv.Lookup_Type = 'CP_EXECUTION_METHOD_CODE'
         AND Fcp.Execution_Method_Code = Flv.Lookup_Code
         AND Fcpt.Language = 'US'
         AND Flv.Language = 'US'
         AND Fcp.Enabled_Flag = 'Y'
         AND Fcpt.User_Concurrent_Program_Name LIKE
             'Purge Signon Audit data%'
         AND a.Application_Name LIKE '%Application Object Library%'
       ORDER BY a.Application_Name, Fcp.Creation_Date DESC;
   --Purge Logs and Closed System Alerts
   CURSOR Cs_Program3 IS
      SELECT a.Application_Name,
             a.Application_Short_Name,
             Fcp.Concurrent_Program_Name,
             Fcpt.User_Concurrent_Program_Name
        FROM Fnd_Concurrent_Programs    Fcp,
             Fnd_Concurrent_Programs_Tl Fcpt,
             Fnd_Lookup_Values          Flv,
             Fnd_Application_Vl         a
       WHERE 1 = 1
         AND Fcp.Application_Id = a.Application_Id
         AND Fcp.Concurrent_Program_Id = Fcpt.Concurrent_Program_Id
         AND Flv.Lookup_Type = 'CP_EXECUTION_METHOD_CODE'
         AND Fcp.Execution_Method_Code = Flv.Lookup_Code
         AND Fcpt.Language = 'US'
         AND Flv.Language = 'US'
         AND Fcp.Enabled_Flag = 'Y'
         AND Fcpt.User_Concurrent_Program_Name LIKE
             'Purge Logs and Closed System Alerts%'
         AND a.Application_Name LIKE '%Application Object Library%'
       ORDER BY a.Application_Name, Fcp.Creation_Date DESC;
   --Purge Inactive Sessions
   CURSOR Cs_Program4 IS
      SELECT a.Application_Name,
             a.Application_Short_Name,
             Fcp.Concurrent_Program_Name,
             Fcpt.User_Concurrent_Program_Name
        FROM Fnd_Concurrent_Programs    Fcp,
             Fnd_Concurrent_Programs_Tl Fcpt,
             Fnd_Lookup_Values          Flv,
             Fnd_Application_Vl         a
       WHERE 1 = 1
         AND Fcp.Application_Id = a.Application_Id
         AND Fcp.Concurrent_Program_Id = Fcpt.Concurrent_Program_Id
         AND Flv.Lookup_Type = 'CP_EXECUTION_METHOD_CODE'
         AND Fcp.Execution_Method_Code = Flv.Lookup_Code
         AND Fcpt.Language = 'US'
         AND Flv.Language = 'US'
         AND Fcp.Enabled_Flag = 'Y'
         AND Fcpt.User_Concurrent_Program_Name LIKE
             'Purge Inactive Sessions%'
         AND a.Application_Name LIKE '%Application Object Library%'
       ORDER BY a.Application_Name, Fcp.Creation_Date DESC;
   --Purge Inactive Sessions
   CURSOR Cs_Program5 IS
      SELECT a.Application_Name,
             a.Application_Short_Name,
             Fcp.Concurrent_Program_Name,
             Fcpt.User_Concurrent_Program_Name
        FROM Fnd_Concurrent_Programs    Fcp,
             Fnd_Concurrent_Programs_Tl Fcpt,
             Fnd_Lookup_Values          Flv,
             Fnd_Application_Vl         a
       WHERE 1 = 1
         AND Fcp.Application_Id = a.Application_Id
         AND Fcp.Concurrent_Program_Id = Fcpt.Concurrent_Program_Id
         AND Flv.Lookup_Type = 'CP_EXECUTION_METHOD_CODE'
         AND Fcp.Execution_Method_Code = Flv.Lookup_Code
         AND Fcpt.Language = 'US'
         AND Flv.Language = 'US'
         AND Fcp.Enabled_Flag = 'Y'
         AND Fcp.Concurrent_Program_Name LIKE 'ABC.EVN_INV_INT_QLKT%'
         AND a.Application_Name LIKE '%Inventory%'
       ORDER BY a.Application_Name, Fcp.Creation_Date DESC;
   CURSOR Cs_Program6 IS
      SELECT a.Application_Name,
             a.Application_Short_Name,
             Fcp.Concurrent_Program_Name,
             Fcpt.User_Concurrent_Program_Name
        FROM Fnd_Concurrent_Programs    Fcp,
             Fnd_Concurrent_Programs_Tl Fcpt,
             Fnd_Lookup_Values          Flv,
             Fnd_Application_Vl         a
       WHERE 1 = 1
         AND Fcp.Application_Id = a.Application_Id
         AND Fcp.Concurrent_Program_Id = Fcpt.Concurrent_Program_Id
         AND Flv.Lookup_Type = 'CP_EXECUTION_METHOD_CODE'
         AND Fcp.Execution_Method_Code = Flv.Lookup_Code
         AND Fcpt.Language = 'US'
         AND Flv.Language = 'US'
         AND Fcp.Enabled_Flag = 'Y'
         AND Fcpt.User_Concurrent_Program_Name LIKE
             'OAM Applications Dashboard Collection%'
         AND a.Application_Name LIKE '%Application Object Library%'
       ORDER BY a.Application_Name, Fcp.Creation_Date DESC;
BEGIN
   --
   SELECT DISTINCT Fr.Responsibility_Id, Frx.Application_Id
     INTO l_Responsibility_Id, l_Application_Id
     FROM Apps.Fnd_Responsibility Frx, Apps.Fnd_Responsibility_Tl Fr
    WHERE Fr.Responsibility_Id = Frx.Responsibility_Id
      AND Lower(Fr.Responsibility_Name) LIKE Lower('System Administrator');
   --
   SELECT User_Id
     INTO l_User_Id
     FROM Fnd_User
    WHERE User_Name = 'SYSADMIN';
   --To set environment context.
   Apps.Fnd_Global.Apps_Initialize(l_User_Id,
                                   l_Responsibility_Id,
                                   l_Application_Id);
   --Purge Concurrent Request and/or Manager Data
   FOR Rc IN Cs_Program1 LOOP
      l_Request_Id := Fnd_Request.Submit_Request(Application => Rc.Application_Short_Name,
                                                 Program     => Rc.Concurrent_Program_Name,
                                                 Description => Rc.User_Concurrent_Program_Name,
                                                 Start_Time  => SYSDATE,
                                                 Sub_Request => FALSE,
                                                 Argument1   => 'ALL',
                                                 Argument2   => 'Age',
                                                 Argument3   => 5,
                                                 Argument4   => NULL,
                                                 Argument5   => NULL,
                                                 Argument6   => NULL,
                                                 Argument7   => NULL,
                                                 Argument8   => NULL,
                                                 Argument9   => NULL,
                                                 Argument10  => NULL,
                                                 Argument11  => NULL,
                                                 Argument12  => NULL,
                                                 Argument13  => NULL,
                                                 Argument14  => 'Y',
                                                 Argument15  => 'Y');
   END LOOP;
   COMMIT;
   --Purge Signon Audit data%
   FOR Rc IN Cs_Program2 LOOP
      l_Request_Id := Fnd_Request.Submit_Request(Application => Rc.Application_Short_Name,
                                                 Program     => Rc.Concurrent_Program_Name,
                                                 Description => Rc.User_Concurrent_Program_Name,
                                                 Start_Time  => SYSDATE,
                                                 Sub_Request => FALSE,
                                                 Argument1   => To_Char(SYSDATE - 14,
                                                                        'YYYY/MM/DD HH24:MI:SS'));
   END LOOP;
   COMMIT;
   --Purge Logs and Closed System Alerts
   FOR Rc IN Cs_Program3 LOOP
      l_Request_Id := Fnd_Request.Submit_Request(Application => Rc.Application_Short_Name,
                                                 Program     => Rc.Concurrent_Program_Name,
                                                 Description => Rc.User_Concurrent_Program_Name,
                                                 Start_Time  => SYSDATE,
                                                 Sub_Request => FALSE,
                                                 Argument1   => To_Char(SYSDATE - 14,
                                                                        'YYYY/MM/DD HH24:MI:SS'));
   END LOOP;
   COMMIT;
   --Purge Inactive Sessions
   FOR Rc IN Cs_Program4 LOOP
      l_Request_Id := Fnd_Request.Submit_Request(Application => Rc.Application_Short_Name,
                                                 Program     => Rc.Concurrent_Program_Name,
                                                 Description => Rc.User_Concurrent_Program_Name,
                                                 Start_Time  => SYSDATE,
                                                 Sub_Request => FALSE);
   END LOOP;
   COMMIT;
   --OAM Applications Dashboard Collection
   FOR Rc IN Cs_Program6 LOOP
      l_Request_Id := Fnd_Request.Submit_Request(Application => Rc.Application_Short_Name,
                                                 Program     => Rc.Concurrent_Program_Name,
                                                 Description => Rc.User_Concurrent_Program_Name,
                                                 Start_Time  => SYSDATE,
                                                 Sub_Request => FALSE);
   END LOOP;
   COMMIT;
   --Tich hop Quan ly ky thuat
   /*  l_Boolean := Fnd_Request.Set_Repeat_Options(Repeat_Time     => NULL --to_char(sysdate,'hh24:mi:ss'),
   ,Repeat_Interval => 1 --Applies only when releat_time is null
   ,Repeat_Unit     => 'DAYS' --Applies only when releat_time is null Unit for repeat interval. Default is DAYS. MONTHS/DAYS/HOURS/MINUTES
   ,Repeat_Type     => 'START' --Applies only when repeat_time is null
    --,repeat_end_time  => 
    ,increment_dates  => 'Y'-- Increment the date parameters for next run
    );*/
   l_Boolean := Fnd_Request.Set_Repeat_Options(Repeat_Time => To_Char(trunc(SYSDATE),
                                                                      'hh24:mi:ss'),
                                               --Repeat_Interval => 1,
                                               --Repeat_Unit     => 'DAYS',
                                               Repeat_Type     => 'START',
                                               Increment_Dates => 'Y');
   FOR Rc IN Cs_Program5 LOOP
      IF l_Boolean THEN
         l_Request_Id := Fnd_Request.Submit_Request(Application => Rc.Application_Short_Name,
                                                    Program     => Rc.Concurrent_Program_Name,
                                                    Description => Rc.User_Concurrent_Program_Name,
                                                    Start_Time  => SYSDATE,
                                                    Sub_Request => FALSE);
      ELSE
         RAISE e_Set_Repeat;
      END IF;
      IF l_Request_Id > 0 THEN
         Dbms_Output.Put_Line('Concurrent Program Id: ' || l_Request_Id);
      ELSE
         Dbms_Output.Put_Line('Error: submit_request');
      END IF;
   END LOOP;
   COMMIT;
EXCEPTION
   WHEN e_Set_Repeat THEN
      Dbms_Output.Put_Line('Error: set_repeat_options');
   WHEN OTHERS THEN
      Dbms_Output.Put_Line('Error While Submitting Concurrent Request ' ||
                           To_Char(SQLCODE) || '-' || SQLERRM);
END;
/
