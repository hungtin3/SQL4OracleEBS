SELECT u.User_Id,
       u.User_Name,
       u.Creation_Date,
       u.Start_Date,
       u.End_Date,
       u.Last_Logon_Date
  FROM Fnd_User u
 WHERE 1 = 1
   AND u.Creation_Date >= '01-JAN-2010'
   AND (u.End_Date IS NULL OR u.End_Date >= SYSDATE  )
   AND NOT EXISTS
 (SELECT 1
          FROM Fnd_User_Resp_Groups_Direct Furg
         WHERE u.User_Id = Furg.User_Id
           AND (Furg.End_Date IS NULL OR Furg.End_Date >= Trunc(SYSDATE)))
 ORDER BY u.Creation_Date DESC;
