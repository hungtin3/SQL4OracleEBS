col Short_Name form a30 
col NAME form a30
col Level_Set form a10
col CONTEXT form a20
col Profile_Value  form a15 
col start_date  form a15
col end_date   form a15

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
              '',
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
              'UnDef') "CONTEXT",
       v.Profile_Option_Value Profile_Value
  FROM Fnd_Profile_Options       p,
       Fnd_Profile_Option_Values v,
       Fnd_Profile_Options_Tl    n,
       Fnd_User                  Usr,
       Fnd_Application           App,
       Fnd_Responsibility        Rsp,
       Fnd_Nodes                 Svr,
       Hr_Operating_Units        Org
 WHERE p.Profile_Option_Id = v.Profile_Option_Id(+)
   AND p.Profile_Option_Name = n.Profile_Option_Name
   AND Usr.User_Id(+) = v.Level_Value
   AND Rsp.Application_Id(+) = v.Level_Value_Application_Id
   AND Rsp.Responsibility_Id(+) = v.Level_Value
   AND App.Application_Id(+) = v.Level_Value
   AND Svr.Node_Id(+) = v.Level_Value
   AND Org.Organization_Id(+) = v.Level_Value
   AND upper(n.User_Profile_Option_Name) LIKE 'SIGN%ON%%'
 ORDER BY 2, 1;
