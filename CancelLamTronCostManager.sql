--@E:\GoogleDrive\runall\CancelLamTronCostManager.sql
UPDATE Applsys.fnd_concurrent_requests
   SET status_code = 'X', phase_code = 'C'
 WHERE request_id in (SELECT t.Request_Id
                        FROM Fnd_Concurrent_Requests t,
                             Applsys.Fnd_User        Fnu,
                             Fnd_Conc_Req_Summary_v  T1
                       WHERE 1 = 1
                         AND t.Requested_By = Fnu.User_Id
                         AND T1.Request_Id = t.Request_Id
                            And (t.Phase_Code = 'R' or t.Phase_Code = 'P')
                            And   ( T1.Program_Short_Name like '%SUPPLIER_STATEMENT_RE%' 
							or T1.Program_Short_Name like '%CMCTCM%') 
                      );
commit;			