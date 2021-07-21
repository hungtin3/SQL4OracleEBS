UPDATE Applsys.Fnd_Concurrent_Requests r
   SET Status_Code = 'X', Phase_Code = 'C'
 WHERE 
 1=1
 AND (r.Phase_Code = 'P' or r.phase_code='R' )
   AND (SYSDATE-r.Request_Date)*24*60 > 90
   AND r.Request_Id NOT IN
       (SELECT t.Request_Id
          FROM Fnd_Concurrent_Requests t,
               Applsys.Fnd_User        Fnu,
               Fnd_Conc_Req_Summary_v  T1
         WHERE 1 = 1
           AND t.Requested_By = Fnu.User_Id
           AND T1.Request_Id = t.Request_Id
           AND (t.Phase_Code = 'P' or r.phase_code='R')
           AND (T1.Program_Short_Name LIKE '%SUPPLIER_STATEMENT_RE%' OR
               T1.Program_Short_Name LIKE '%CMCTCM%' OR
			   T1.Program_Short_Name LIKE '%EVN_CPC_PORTAL_INT%' OR
			   T1.Program_Short_Name LIKE '%EVN_CPC_PORTAL_MONTHLY%' OR
			   T1.Program_Short_Name LIKE '%EVN_CF_BALANCE%' OR
			   T1.Program_Short_Name LIKE '%EVN_CF_COLLECT_CASH_BALANCE%' OR
			   T1.Program_Short_Name LIKE 'EVN_INV_INT_QLKT'
			   ));