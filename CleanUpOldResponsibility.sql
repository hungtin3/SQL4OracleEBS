Prompt ***** Permission change *****
col USER_NAME form a25 
col User_Creation_Date form a12
col User_End_Date form a12
col Responsibility_Name form a35
col Respon_Creation_Date  form a12
col Respon_End_Date  form a12
col Assign_Creation_Date   form a12
col Assign_Start_Date   form a12
col Assign_End_Date   form a12
col Application_Short_Name   form a15

SELECT Fu.User_Name              User_Name,
       trunc(Fu.Creation_Date)          User_Creation_Date,
       trunc(Fu.End_Date)               User_End_Date,
       Frt.Responsibility_Name   Responsibility_Name,
       trunc(Fr.Creation_Date)          Respon_Creation_Date,
       trunc(Fr.End_Date)               Respon_End_Date,
       trunc(Furg.Creation_Date)        Assign_Creation_Date,
       trunc(Furg.Start_Date)           Assign_Start_Date,
       trunc(Furg.End_Date)             Assign_End_Date,
       Fa.Application_Short_Name Application_Short_Name
  FROM Fnd_User_Resp_Groups_Direct   Furg,
       Applsys.Fnd_User              Fu,
       Applsys.Fnd_Responsibility_Tl Frt,
       Applsys.Fnd_Responsibility    Fr,
       Applsys.Fnd_Application_Tl    Fat,
       Applsys.Fnd_Application       Fa
 WHERE Furg.User_Id = Fu.User_Id
   AND Furg.Responsibility_Id = Frt.Responsibility_Id
   AND Fr.Responsibility_Id = Frt.Responsibility_Id
   AND Fa.Application_Id = Fat.Application_Id
   AND Fr.Application_Id = Fat.Application_Id
   AND Frt.Language = Userenv('LANG')
      --AND Upper(Fu.User_Name) LIKE '%HUONGNT.GE1.DHD%' -- <change it>
      --AND frt.responsibility_name LIKE '%%Super%'
   AND (Fu.End_Date IS NULL OR Fu.End_Date > SYSDATE)
   AND (Furg.End_Date IS NULL OR Furg.End_Date > SYSDATE)
   AND (Fr.End_Date IS NULL OR Fr.End_Date > SYSDATE)
   AND Frt.Creation_Date <= '01-JAN-2012'
 ORDER BY  User_Name;
