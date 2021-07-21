--Huy bao cao do trung tham so
--HungNT: 2021-JAN-15
DECLARE
   CURSOR Cs_Duplicate_Request IS
      SELECT Ten_Bc,
             Requested_By,
             Nguoi_Chay,
             Argument_Text,
             COUNT(*),
             MIN(Request_Id) Min_Request,
             MIN(Concurrent_Program_Id) Concurrent_Program_Id
        FROM (SELECT t.Request_Id,
                     --T1.User_Concurrent_Program_Name,
                     T1.Program_Short_Name Ten_Bc,
                     t.Requested_By,
                     Fnu.User_Name Nguoi_Chay,
                     To_Char(t.Request_Date,
                             'DD/MM/RR-HH24:MI:SS') "Submit",
                     To_Char(t.Actual_Start_Date,
                             'HH24:MI:SS') "Start",
                     Round((t.Actual_Completion_Date - t.Actual_Start_Date) * 1440,
                           2) Tg_Th,
                     Round((Nvl(t.Actual_Start_Date,
                                SYSDATE) - t.Request_Date) * 1440,
                           2) Tg_Wait,
                     Round((Nvl(t.Actual_Completion_Date,
                                SYSDATE) - t.Request_Date) * 1440,
                           2) Tong_Tg,
                     CASE
                        WHEN t.Phase_Code = 'C' AND
                             t.Status_Code IN ('C',
                                               'G') THEN
                         'Hoan thanh'
                        WHEN t.Phase_Code = 'C' AND t.Status_Code = 'D' THEN
                         'Tam dung request boi ' || Fnu.User_Name
                        WHEN t.Phase_Code = 'C' AND t.Status_Code = 'X' THEN
                         'Tam dung request boi nguoi khac'
                        WHEN t.Phase_Code = 'C' AND t.Status_Code = 'E' THEN
                         'Bao cao loi '
                        WHEN t.Phase_Code = 'P' THEN
                         'Ðang cho doi de chay'
                        WHEN t.Phase_Code = 'R' THEN
                         'Ðang chay...'
                        ELSE
                         'Chua xác d?nh'
                     END Trang_Thai,
                     Decode(t.Phase_Code,
                            'C',
                            'Completed',
                            'I',
                            'Inactive',
                            'P',
                            'Pending',
                            'R',
                            'Running',
                            t.Phase_Code) Phase,
                     Decode(t.Status_Code,
                            'A',
                            'Waiting',
                            'B',
                            'Resuming',
                            'C',
                            'Normal',
                            'D',
                            'Cancelled',
                            'E',
                            'Errored',
                            'P',
                            'Scheduled',
                            'G',
                            'Warning',
                            'H',
                            'On Hold',
                            'I',
                            'Normal',
                            'M',
                            'No Manager',
                            'Q',
                            'Standby',
                            'R',
                            'Normal',
                            'S',
                            'Suspended',
                            'T',
                            'Terminating',
                            'U',
                            'Disabled',
                            'W',
                            'Paused',
                            'X',
                            'Terminated',
                            'Z',
                            'Waiting',
                            t.Status_Code) Status,
                     t.Completion_Text,
                     t.Logfile_Name,
                     t.Logfile_Node_Name,
                     t.Outfile_Name,
                     t.Argument_Text,
                     t.Priority,
                     T1.User_Concurrent_Program_Name,
                     T1.Concurrent_Program_Id
                FROM Fnd_Concurrent_Requests t,
                     Applsys.Fnd_User        Fnu,
                     Fnd_Conc_Req_Summary_v  T1
               WHERE t.Requested_By = Fnu.User_Id
                 AND T1.Request_Id = t.Request_Id
                 AND Fnu.User_Name NOT IN ('SYSADMIN')
                 AND (t.Phase_Code = 'R' OR t.Phase_Code = 'P')
               ORDER BY t.Phase_Code, t.Request_Date DESC)
       GROUP BY Requested_By, Ten_Bc, Nguoi_Chay, Argument_Text
      HAVING COUNT(*) > 1;
BEGIN
   FOR Rc IN Cs_Duplicate_Request LOOP
      BEGIN
         UPDATE Applsys.Fnd_Concurrent_Requests r
            SET Status_Code = 'X', Phase_Code = 'C', r.description='Huy do trung tham so voi RequestID:'||Rc.Min_Request
          WHERE r.Request_Id > Rc.Min_Request
            AND r.Concurrent_Program_Id = Rc.Concurrent_Program_Id
            AND r.Requested_By = Rc.Requested_By;
         COMMIT;
         Dbms_Output.Put_Line('Cancel request:'||rc.Ten_Bc||'-'||rc.Nguoi_Chay||':'||rc.Argument_Text);
      END;
   END LOOP;
END;
/
