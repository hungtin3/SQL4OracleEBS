prompt ***** Lower performance profile 1*****
col profile_option_name form a25 
col user_profile_option_name form a30
col Level form a10
col Level_Value form a30
col Profile_Value  form a15 
col start_date  form a15
col end_date   form a15

SELECT Tl.Profile_Option_Name,
       Tl.User_Profile_Option_Name,
       Substr(Decode(a.Level_Id,
                     10001,
                     'SITE',
                     10002,
                     'APPLN',
                     10003,
                     'RESP',
                     10004,
                     'USER'),
              1,
              5) "Level",
       Substr(Decode(a.Level_Id,
                     10001,
                     'Site',
                     10002,
                     c.Application_Short_Name,
                     10003,
                     b. Responsibility_Name,
                     10004,
                     d.User_Name),
              1,
              30) "Level_Value",
       Nvl(a.Profile_Option_Value,
           'Is Null') "Profile_Value"
  FROM Fnd_Profile_Option_Values a,
       Fnd_Responsibility_Tl     b,
       Fnd_Application           c,
       Fnd_User                  d,
       Fnd_Profile_Options       e,
       Fnd_Profile_Options_Tl    Tl
 WHERE ((Tl.User_Profile_Option_Name) IN
       ('SLA: Enable Diagnostics',
         'FND: Diagnostics',
         'Utilities:Diagnostics',
         'FND: Debug Log Enabled',
         'FND: Debug Log Level') OR
       Tl.Profile_Option_Name IN
       ('AFLOG_ENABLED',
         'AFLOG_LEVEL'))
   AND e.Profile_Option_Id = a.Profile_Option_Id
   AND Tl.Profile_Option_Name = e.Profile_Option_Name
   AND a.Level_Value = b.Responsibility_Id(+)
   AND a.Level_Value = c.Application_Id(+)
   AND a.Level_Value = d.User_Id(+)
   AND Tl.Language = 'US'
 ORDER BY 1, 2, 3, 4 DESC;