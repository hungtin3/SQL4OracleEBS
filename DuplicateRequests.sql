SELECT Fcrsv.Request_Id,
       --       fcpt.concurrent_program_id,
       Fcpt.User_Concurrent_Program_Name,
       Fcrsv.Requestor,
       Fcrsv.Argument_Text,
       Fcrsv.Request_Date,
       Decode(Fcrsv.Phase_Code,
              'P',
              Decode(Fcrsv.Hold_Flag,
                     'Y',
                     'Inactive',
                     Fl_p.Meaning),
              Fl_p.Meaning) Phase,
       Decode(Fcrsv.Phase_Code,
              'P',
              Decode(Fcrsv.Hold_Flag,
                     'Y',
                     'On Hold',
                     Decode(Sign(Fcrsv.Requested_Start_Date - SYSDATE),
                            1,
                            'Scheduled',
                            Fl_s.Meaning)),
              Fl_s.Meaning) Status,
       CASE
          WHEN Decode(Fcrsv.Phase_Code,
                      'P',
                      Decode(Fcrsv.Hold_Flag,
                             'Y',
                             'On Hold',
                             Decode(Sign(Fcrsv.Requested_Start_Date - SYSDATE),
                                    1,
                                    'Scheduled',
                                    Fl_s.Meaning)),
                      Fl_s.Meaning) = 'Scheduled' THEN
           (SELECT Decode(c.Class_Type,
                          'P',
                          'Periodic',
                          'S',
                          'On Specific Days',
                          'X',
                          'Advanced',
                          c.Class_Type) Schedule_Type
              FROM Applsys.Fnd_Concurrent_Requests  r,
                   Applsys.Fnd_Conc_Release_Classes c
             WHERE r.Phase_Code = 'P'
               AND c.Application_Id = r.Release_Class_App_Id
               AND c.Release_Class_Id = r.Release_Class_Id
               AND Nvl(c.Date2,
                       SYSDATE + 1) > SYSDATE
               AND c.Class_Type IS NOT NULL
               AND r.Request_Id = Fcrsv.Request_Id)
          ELSE
           NULL
       END Schedule_Type,
       CASE
          WHEN Decode(Fcrsv.Phase_Code,
                      'P',
                      Decode(Fcrsv.Hold_Flag,
                             'Y',
                             'On Hold',
                             Decode(Sign(Fcrsv.Requested_Start_Date - SYSDATE),
                                    1,
                                    'Scheduled',
                                    Fl_s.Meaning)),
                      Fl_s.Meaning) = 'Scheduled' THEN
           (SELECT CASE
                      WHEN c.Class_Type = 'P' THEN
                       'Repeat every ' ||
                       Substr(c.Class_Info,
                              1,
                              Instr(c.Class_Info,
                                    ':') - 1) ||
                       Decode(Substr(c.Class_Info,
                                     Instr(c.Class_Info,
                                           ':',
                                           1,
                                           1) + 1,
                                     1),
                              'N',
                              ' minutes',
                              'M',
                              ' months',
                              'H',
                              ' hours',
                              'D',
                              ' days') ||
                       Decode(Substr(c.Class_Info,
                                     Instr(c.Class_Info,
                                           ':',
                                           1,
                                           2) + 1,
                                     1),
                              'S',
                              ' from the start of the prior run',
                              'C',
                              ' from the completion of the prior run')
                      WHEN c.Class_Type = 'S' THEN
                       Nvl2(Dates.Dates,
                            'Dates: ' || Dates.Dates || '. ',
                            NULL) ||
                       Decode(Substr(c.Class_Info,
                                     32,
                                     1),
                              '1',
                              'Last day of month ') ||
                       Decode(Sign(To_Number(Substr(c.Class_Info,
                                                    33))),
                              '1',
                              'Days of week: ' ||
                              Decode(Substr(c.Class_Info,
                                            33,
                                            1),
                                     '1',
                                     'Su ') || Decode(Substr(c.Class_Info,
                                                             34,
                                                             1),
                                                      '1',
                                                      'Mo ') ||
                              Decode(Substr(c.Class_Info,
                                            35,
                                            1),
                                     '1',
                                     'Tu ') || Decode(Substr(c.Class_Info,
                                                             36,
                                                             1),
                                                      '1',
                                                      'We ') ||
                              Decode(Substr(c.Class_Info,
                                            37,
                                            1),
                                     '1',
                                     'Th ') || Decode(Substr(c.Class_Info,
                                                             38,
                                                             1),
                                                      '1',
                                                      'Fr ') ||
                              Decode(Substr(c.Class_Info,
                                            39,
                                            1),
                                     '1',
                                     'Sa '))
                   END Schedule
              FROM Applsys.Fnd_Concurrent_Requests r,
                   Applsys.Fnd_Conc_Release_Classes c,
                   (SELECT Release_Class_Id,
                           Substr(MAX(Sys_Connect_By_Path(s,
                                                          ' ')),
                                  2) Dates
                      FROM (SELECT Release_Class_Id,
                                   Rank() Over(PARTITION BY Release_Class_Id ORDER BY s) a,
                                   s
                              FROM (SELECT c.Class_Info,
                                           l,
                                           c.Release_Class_Id,
                                           Decode(Substr(c.Class_Info,
                                                         l,
                                                         1),
                                                  '1',
                                                  To_Char(l)) s
                                      FROM (SELECT LEVEL l
                                              FROM Dual
                                            CONNECT BY LEVEL <= 31),
                                           Applsys.Fnd_Conc_Release_Classes c
                                     WHERE c.Class_Type = 'S')
                             WHERE s IS NOT NULL)
                    CONNECT BY PRIOR (a || Release_Class_Id) =
                                (a - 1) || Release_Class_Id
                     START WITH a = 1
                     GROUP BY Release_Class_Id) Dates
             WHERE r.Phase_Code = 'P'
               AND c.Application_Id = r.Release_Class_App_Id
               AND c.Release_Class_Id = r.Release_Class_Id
               AND Nvl(c.Date2,
                       SYSDATE + 1) > SYSDATE
               AND c.Class_Type IS NOT NULL
               AND Dates.Release_Class_Id(+) = r.Release_Class_Id
               AND r.Request_Id = Fcrsv.Request_Id)
          ELSE
           NULL
       END Schedule
  FROM Apps.Fnd_Conc_Req_Summary_v Fcrsv,
       Applsys.Fnd_Concurrent_Programs_Tl Fcpt,
       Applsys.Fnd_Concurrent_Programs Fcp,
       Apps.Fnd_Lookups Fl_p,
       Apps.Fnd_Lookups Fl_s,
       (SELECT Fcrsv.Argument_Text,
               Fcrsv.Requestor,
               Fcrsv.User_Concurrent_Program_Name
          FROM Apps.Fnd_Conc_Req_Summary_v        Fcrsv,
               Applsys.Fnd_Concurrent_Programs_Tl Fcpt
         WHERE 1 = 1
           AND Fcrsv.Concurrent_Program_Id = Fcpt.Concurrent_Program_Id
           AND Fcrsv.Program_Application_Id = Fcpt.Application_Id
              --and fcpt.language = 'VN'
           AND Fcrsv.Phase_Code NOT LIKE 'C'
           AND Fcrsv.Status_Code NOT LIKE 'C'
         GROUP BY Fcrsv.Argument_Text,
                  Fcrsv.Requestor,
                  Fcrsv.User_Concurrent_Program_Name
        HAVING COUNT(Fcrsv.Request_Id) > 1) a
 WHERE 1 = 1
   AND Fcrsv.Concurrent_Program_Id = Fcpt.Concurrent_Program_Id
   AND Fcrsv.Program_Application_Id = Fcpt.Application_Id
   AND Fcpt.Concurrent_Program_Id = Fcp.Concurrent_Program_Id
   AND Fcrsv.Phase_Code = Fl_p.Lookup_Code
   AND Fl_p.Lookup_Type = 'CP_PHASE_CODE'
   AND Fcrsv.Status_Code = Fl_s.Lookup_Code
   AND Fl_s.Lookup_Type = 'CP_STATUS_CODE'
      --and fcpt.language = 'VN'
   AND Fcrsv.Phase_Code NOT LIKE 'C'
   AND Fcrsv.Status_Code NOT LIKE 'C'
   AND Fcrsv.Requestor NOT LIKE 'SYSADMIN'
   AND Fcp.Execution_Method_Code = 'P'
   AND Fcrsv.Concurrent_Program_Id NOT IN (
                                           --37899, --Chuyển d.liệu sang Ph.hệ Sổ Cái 
                                           38039, --Tiến trình Kế toán p.hệ TKPTrả 
                                           32002, --Đảo Bút toán 
                                           --32373, --Phân tích Tài khoản - (180 Ký tự)
                                           32530 --Giao dịch kiểm soát ngân sách
                                           )
   AND Fcrsv.Argument_Text = a.Argument_Text
   AND Fcrsv.Requestor = a.Requestor
   AND Fcrsv.User_Concurrent_Program_Name = a.User_Concurrent_Program_Name
 ORDER BY Fcrsv.Argument_Text
