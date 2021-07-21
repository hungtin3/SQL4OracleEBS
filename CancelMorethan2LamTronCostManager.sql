--@E:\GoogleDrive\runall\CancelMorethan2LamTronCostManager.sql
UPDATE Applsys.Fnd_Concurrent_Requests
   SET Status_Code = 'X', Phase_Code = 'C'
 WHERE Request_Id IN
       (SELECT t.Request_Id
          FROM Fnd_Concurrent_Requests t,
               Applsys.Fnd_User        Fnu,
               Fnd_Conc_Req_Summary_v  T1
         WHERE 1 = 1
           AND T1.Request_Id = t.Request_Id
           AND (t.Phase_Code = 'R' OR t.Phase_Code = 'P' OR
               t.Phase_Code = 'I')
           AND (T1.Program_Short_Name LIKE '%SUPPLIER_STATEMENT_RE%'))
   AND Request_Id <
       (SELECT MAX(t.Request_Id)
          FROM Fnd_Concurrent_Requests t,
               Applsys.Fnd_User        Fnu,
               Fnd_Conc_Req_Summary_v  T1
         WHERE 1 = 1
           AND T1.Request_Id = t.Request_Id
           AND (t.Phase_Code = 'R' OR t.Phase_Code = 'P' OR
               t.Phase_Code = 'I')
           AND (T1.Program_Short_Name LIKE '%SUPPLIER_STATEMENT_RE%'));
commit;		   

UPDATE Applsys.Fnd_Concurrent_Requests
   SET Status_Code = 'X', Phase_Code = 'C'
 WHERE Request_Id IN
       (SELECT t.Request_Id
          FROM Fnd_Concurrent_Requests t,
               Applsys.Fnd_User        Fnu,
               Fnd_Conc_Req_Summary_v  T1
         WHERE 1 = 1
           AND T1.Request_Id = t.Request_Id
           AND (t.Phase_Code = 'R' OR t.Phase_Code = 'P' OR
               t.Phase_Code = 'I')
           AND (T1.Program_Short_Name LIKE '%CMCTCM%'))
   AND Request_Id <
       (SELECT MAX(t.Request_Id)
          FROM Fnd_Concurrent_Requests t,
               Applsys.Fnd_User        Fnu,
               Fnd_Conc_Req_Summary_v  T1
         WHERE 1 = 1
           AND T1.Request_Id = t.Request_Id
           AND (t.Phase_Code = 'R' OR t.Phase_Code = 'P' OR
               t.Phase_Code = 'I')
           AND (T1.Program_Short_Name LIKE '%CMCTCM%'));
commit;

UPDATE Applsys.Fnd_Concurrent_Requests
   SET Status_Code = 'X', Phase_Code = 'C'
 WHERE Request_Id IN
       (SELECT t.Request_Id
          FROM Fnd_Concurrent_Requests t,
               Applsys.Fnd_User        Fnu,
               Fnd_Conc_Req_Summary_v  T1
         WHERE 1 = 1
           AND T1.Request_Id = t.Request_Id
           AND (t.Phase_Code = 'R' OR t.Phase_Code = 'P' OR
               t.Phase_Code = 'I')
           AND (T1.Program_Short_Name LIKE '%EVN_INV_INT_QLKT%'))
   AND Request_Id =
       (SELECT MAX(t.Request_Id)
          FROM Fnd_Concurrent_Requests t,
               Applsys.Fnd_User        Fnu,
               Fnd_Conc_Req_Summary_v  T1
         WHERE 1 = 1
           AND T1.Request_Id = t.Request_Id
           AND (t.Phase_Code = 'R' OR t.Phase_Code = 'P' OR
               t.Phase_Code = 'I')
           AND (T1.Program_Short_Name LIKE '%EVN_INV_INT_QLKT%'));
commit;
