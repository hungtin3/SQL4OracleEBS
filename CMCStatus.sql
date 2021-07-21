SELECT i.Instance_Name,
       /*t.Request_Id,
       Decode(T1.Program_Short_Name,
              'SUPPLIER_STATEMENT_RE',
              'Lượng Hết-Tiền Còn',
              'CMCTCM',
              'Tính giá') Program_Name_v,*/
       T1.Program_Short_Name,
       To_Char(t.Request_Date,
               'HH24:MI:SS') Submit,
       To_Char(t.Actual_Start_Date,
               'HH24:MI:SS') Start_t,
       To_Char(t.Last_Update_Date,
               'HH24:MI:SS') Lastrun_t,
       To_Char(SYSDATE,
               'HH24:MI:SS') Curr_t,
       (SYSDATE - t.Request_Date) * 24 * 60 * 60 	 Living_Time_Sec,
	   (SYSDATE - t.Last_Update_Date) * 24 * 60 * 60 Idle_Time_Sec
  FROM Fnd_Concurrent_Requests t, Fnd_Conc_Req_Summary_v T1, V$instance i
 WHERE 1 = 1
   AND T1.Request_Id = t.Request_Id
   AND (t.Phase_Code = 'R' OR t.Phase_Code = 'P')
   AND (T1.Program_Short_Name LIKE '%SUPPLIER_STATEMENT_RE%' OR
       T1.Program_Short_Name LIKE '%CMCTCM%' or
	   T1.Program_Short_Name LIKE '%EVN_INV_INT_QLKT%' 
	   )
 ORDER BY T1.Program_Short_Name;
