--2019-Jul-08
--Gather Index, Table
--GatherALLTableIndex.sql
DECLARE
   p_As_Of_Dt DATE := Trunc(SYSDATE);
   v_Output   VARCHAR2(250) := '';
   --Subpartition Index
   CURSOR Rc1 IS
      SELECT Ip.Index_Owner,
             Ip.Index_Name,
             Ip.Partition_Name,
             Ip.Subpartition_Name,
             Ip.Last_Analyzed
        FROM Dba_Ind_Subpartitions Ip, Dba_Indexes i
       WHERE 1 = 1
         AND Nvl(Ip.Last_Analyzed,
                 SYSDATE - 1) < p_As_Of_Dt
         AND Ip.Index_Owner = i.Owner
         AND Ip.Index_Name = i.Index_Name
            --AND Ip.Index_Owner IN ('XLA')
         AND i.Index_Type IN ('NORMAL',
                              'FUNCTION-BASED NORMAL')
         AND Ip.Index_Owner IN ('AP',
                                'FND',
                                'CST',
                                'CE',
                                'OFA',
                                'APPLSYS',
                                'APPS',
                                'AR',
                                'BACKUP ',
                                'BOM',
                                'CN',
                                'CTXSYS',
                                'EGO',
                                'ENI',
                                'EVN',
                                'FA',
                                'GL',
                                'IBY',
                                'ICX',
                                'INV',
                                'JTF',
                                'PA',
                                'PO',
                                'TICHHOP',
                                'XDO',
                                'XLA',
                                'ZX')
         AND i.Table_Name NOT IN ('FND_CONCURRENT_REQUESTS')
         AND i.Table_Name NOT LIKE 'AQ%'
         AND i.Table_Name NOT LIKE 'DR%'
         AND i.Table_Name NOT LIKE 'MLOG%'
         AND i.Table_Name NOT LIKE 'BK%'
         AND i.Table_Name NOT LIKE '%XLA%GLT%'
         AND i.Table_Name NOT LIKE 'GL_CONS_INTERFACE%'
         AND (i.Owner, i.Index_Name) NOT IN
             (SELECT Dis.Owner, Dis.Index_Name
                FROM Dba_Ind_Statistics Dis
               WHERE Dis.Stattype_Locked IS NOT NULL)
       ORDER BY Ip.Index_Owner,
                i.Table_Name,
                Ip.Index_Name,
                Ip.Partition_Name,
                Ip.Subpartition_Position;
   --Partition Index
   CURSOR Rc2 IS
      SELECT Ip.Index_Owner,
             Ip.Index_Name,
             Ip.Partition_Name,
             Ip.Last_Analyzed
        FROM All_Indexes i, Dba_Ind_Partitions Ip
       WHERE 1 = 1
         AND Nvl(Ip.Last_Analyzed,
                 SYSDATE - 1) <= p_As_Of_Dt
         AND i.Owner = Ip.Index_Owner
            --AND Ip.Index_Owner IN ('XLA')
         AND i.Index_Name = Ip.Index_Name
         AND i.Index_Type IN ('NORMAL',
                              'FUNCTION-BASED NORMAL')
         AND i.Owner IN ('AP',
                         'FND',
                         'CST',
                         'CE',
                         'OFA',
                         'APPLSYS',
                         'APPS',
                         'AR',
                         'BACKUP ',
                         'BOM',
                         'CN',
                         'CTXSYS',
                         'EGO',
                         'ENI',
                         'EVN',
                         'FA',
                         'GL',
                         'IBY',
                         'ICX',
                         'INV',
                         'JTF',
                         'PA',
                         'PO',
                         'TICHHOP',
                         'XDO',
                         'XLA',
                         'ZX')
            --and  i.TABLE_NAME in ('MTL_MATERIAL_TRANSACTIONS')
         AND i.Table_Name NOT IN ('FND_CONCURRENT_REQUESTS')
         AND i.Table_Name NOT LIKE 'AQ%'
         AND i.Table_Name NOT LIKE 'DR%'
         AND i.Table_Name NOT LIKE 'MLOG%'
         AND i.Table_Name NOT LIKE 'BK%'
         AND i.Table_Name NOT LIKE '%XLA%GLT%'
         AND i.Table_Name NOT LIKE 'GL_CONS_INTERFACE%'
         AND (i.Owner, i.Index_Name) NOT IN
             (SELECT Dis.Owner, Dis.Index_Name
                FROM Dba_Ind_Statistics Dis
               WHERE Dis.Stattype_Locked IS NOT NULL)
         AND Ip.Subpartition_Count = 0
         AND i.Temporary <> 'Y'
       ORDER BY i.Table_Owner, Ip.Index_Name, Ip.Partition_Position;
   --Normal index
   CURSOR Rc3 IS
      SELECT i.Owner Index_Owner, i.Index_Name
        FROM All_Indexes i
       WHERE 1 = 1
         AND Nvl(i.Last_Analyzed,
                 SYSDATE - 1) <= p_As_Of_Dt
         AND i.Table_Owner IN ('AP',
                               'FND',
                               'CST',
                               'CE',
                               'OFA',
                               'APPLSYS',
                               'APPS',
                               'AR',
                               'BACKUP ',
                               'BOM',
                               'CN',
                               'CTXSYS',
                               'EGO',
                               'ENI',
                               'EVN',
                               'FA',
                               'GL',
                               'IBY',
                               'ICX',
                               'INV',
                               'JTF',
                               'PA',
                               'PO',
                               'TICHHOP',
                               'XDO',
                               'XLA',
                               'ZX')
         AND i.Temporary <> 'Y'
            --AND i.Owner IN ('PO')
            --AND i.Partitioned = 'NO'
         AND i.Index_Type IN ('NORMAL',
                              'FUNCTION-BASED NORMAL')
         AND i.Table_Name NOT IN ('FND_CONCURRENT_REQUESTS')
         AND i.Table_Name NOT LIKE '%OLD'
         AND i.Table_Name NOT LIKE 'AQ%'
         AND i.Table_Name NOT LIKE 'DR%'
         AND i.Table_Name NOT LIKE 'MLOG%'
         AND i.Table_Name NOT LIKE 'BK%'
         AND i.Table_Name NOT LIKE '%XLA%GLT%'
         AND i.Table_Name NOT LIKE 'GL_CONS_INTERFACE%'
         AND (i.Owner, i.Index_Name) NOT IN
             (SELECT Dis.Owner, Dis.Index_Name
                FROM Dba_Ind_Statistics Dis
               WHERE Dis.Stattype_Locked IS NOT NULL)
       ORDER BY Table_Owner, i.Table_Name;
   --Subpartition Table
   CURSOR Rc4 IS
      SELECT t.Table_Owner,
             t.Table_Name,
             t.Partition_Name,
             t.Subpartition_Name,
             t.Last_Analyzed
        FROM Dba_Tab_Subpartitions t
       WHERE 1 = 1
         AND Nvl(t.Last_Analyzed,
                 SYSDATE - 1) <= p_As_Of_Dt
            --AND t.Table_Owner IN ('XLA ')
         AND t.Table_Owner IN ('AP',
                               'FND',
                               'CST',
                               'CE',
                               'OFA',
                               'APPLSYS',
                               'APPS',
                               'AR',
                               'BACKUP ',
                               'BOM',
                               'CN',
                               'CTXSYS',
                               'EGO',
                               'ENI',
                               'EVN',
                               'FA',
                               'GL',
                               'IBY',
                               'ICX',
                               'INV',
                               'JTF',
                               'PA',
                               'PO',
                               'TICHHOP',
                               'XDO',
                               'XLA',
                               'ZX')
         AND t.Table_Name NOT IN ('FND_CONCURRENT_REQUESTS')
         AND t.Table_Name NOT LIKE 'GL_CONS_INTERFACE%'
         AND (t.Table_Owner, t.Table_Name) NOT IN
             (SELECT Dts.Owner, Dts.Table_Name
                FROM Dba_Tab_Statistics Dts
               WHERE Dts.Stattype_Locked IS NOT NULL)
       ORDER BY t.Table_Owner,
                t.Table_Name,
                t.Partition_Name,
                t.Subpartition_Name,
                t.Subpartition_Position;
   CURSOR Rc5 IS
      SELECT t.Table_Owner, t.Table_Name, t.Partition_Name, t.Last_Analyzed
        FROM Dba_Tab_Partitions t, Dba_Tables T1
       WHERE 1 = 1
         AND T1.Iot_Type IS NULL
         AND Nvl(t.Last_Analyzed,
                 SYSDATE - 1) <= p_As_Of_Dt
         AND T1.Owner = t.Table_Owner
         AND T1.Table_Name = t.Table_Name
         AND T1.Temporary <> 'NO'
            --AND t.Table_Owner IN ('XLA ')
         AND t.Table_Owner IN ('AP',
                               'FND',
                               'CST',
                               'CE',
                               'OFA',
                               'APPLSYS',
                               'APPS',
                               'AR',
                               'BACKUP ',
                               'BOM',
                               'CN',
                               'CTXSYS',
                               'EGO',
                               'ENI',
                               'EVN',
                               'FA',
                               'GL',
                               'IBY',
                               'ICX',
                               'INV',
                               'JTF',
                               'PA',
                               'PO',
                               'TICHHOP',
                               'XDO',
                               'XLA',
                               'ZX')
         AND t.Subpartition_Count = 0
         AND t.Table_Name NOT IN ('FND_CONCURRENT_REQUESTS')
         AND t.Table_Name NOT LIKE 'AQ%'
         AND t.Table_Name NOT LIKE 'DR%'
         AND t.Table_Name NOT LIKE 'MLOG%'
         AND t.Table_Name NOT LIKE 'BK%'
         AND t.Table_Name NOT LIKE '%XLA%GLT%'
         AND t.Table_Name NOT LIKE 'GL_CONS_INTERFACE%'
         AND (t.Table_Owner, t.Table_Name) NOT IN
             (SELECT Dts.Owner, Dts.Table_Name
                FROM Dba_Tab_Statistics Dts
               WHERE Dts.Stattype_Locked IS NOT NULL)
       ORDER BY t.Table_Owner, t.Table_Name, t.Partition_Position;
   CURSOR Rc6 IS
      SELECT t.Owner Table_Owner, t.Table_Name, t.Last_Analyzed
        FROM All_Tables t
       WHERE 1 = 1
            --AND t.Owner IN ('XLA ')
         AND Nvl(t.Last_Analyzed,
                 SYSDATE - 1) <= p_As_Of_Dt
         AND Owner IN ('AP',
                       'FND',
                       'CST',
                       'CE',
                       'OFA',
                       'APPLSYS',
                       'APPS',
                       'AR',
                       'BACKUP ',
                       'BOM',
                       'CN',
                       'CTXSYS',
                       'EGO',
                       'ENI',
                       'EVN',
                       'FA',
                       'GL',
                       'IBY',
                       'ICX',
                       'INV',
                       'JTF',
                       'PA',
                       'PO',
                       'TICHHOP',
                       'XDO',
                       'XLA',
                       'ZX')
         AND Temporary <> 'Y'
            --AND t.Partitioned = 'NO'
         AND t.Table_Name NOT LIKE '%OLD'
         AND t.Table_Name NOT LIKE '%XLT%'
         AND t.Table_Name NOT LIKE '%XLA%GLT%'
         AND t.Iot_Type IS NULL
         AND t.Table_Name NOT IN ('FND_CONCURRENT_REQUESTS ')
         AND t.Table_Name NOT LIKE 'AQ%'
         AND t.Table_Name NOT LIKE 'DR%'
         AND t.Table_Name NOT LIKE 'MLOG%'
         AND t.Table_Name NOT LIKE 'BK%'
         AND t.Table_Name NOT LIKE 'GL_CONS_INTERFACE%'
         AND (t.Owner, t.Table_Name) NOT IN
             (SELECT Dts.Owner, Dts.Table_Name
                FROM Dba_Tab_Statistics Dts
               WHERE Dts.Stattype_Locked IS NOT NULL)
       ORDER BY t.Owner, t.Table_Name;
BEGIN
   Dbms_Output.Enable(NULL);
   --Subpartition Index
   FOR c IN Rc1 LOOP
      v_Output := 'Subpartition Index:' || c.Index_Owner || ':' ||
                  c.Index_Name || ':' || c.Partition_Name || ':' ||
                  c.Subpartition_Name;
      INSERT INTO apps.Gather_Log VALUES (SYSDATE, v_Output);
      COMMIT;
      Dbms_Output.Put_Line(v_Output);
      Dbms_Stats.Gather_Index_Stats(Ownname          => c.Index_Owner,
                                    Indname          => c.Index_Name,
                                    Partname         => c.Subpartition_Name,
                                    Granularity      => 'SUBPARTITION',
                                    Estimate_Percent => Dbms_Stats.Auto_Sample_Size,
                                    Degree           => 16);
   END LOOP;
   --Partition Index
   FOR c IN Rc2 LOOP
      v_Output := 'Partition Index:' || c.Index_Owner || ':' ||
                  c.Index_Name || ':' || c.Partition_Name;
      INSERT INTO apps.Gather_Log VALUES (SYSDATE, v_Output);
      COMMIT;
      Dbms_Output.Put_Line(v_Output);
      Dbms_Stats.Gather_Index_Stats(Ownname          => c.Index_Owner,
                                    Indname          => c.Index_Name,
                                    Partname         => c.Partition_Name,
                                    Granularity      => 'PARTITION',
                                    Estimate_Percent => Dbms_Stats.Auto_Sample_Size,
                                    Degree           => 16);
   END LOOP;
   --Index
   FOR c IN Rc3 LOOP
      v_Output := 'Index:' || c.Index_Owner || ':' || c.Index_Name;
      INSERT INTO apps.Gather_Log VALUES (SYSDATE, v_Output);
      COMMIT;
      Dbms_Output.Put_Line(v_Output);
      Dbms_Stats.Gather_Index_Stats(Ownname          => c.Index_Owner,
                                    Indname          => c.Index_Name,
                                    Estimate_Percent => Dbms_Stats.Auto_Sample_Size,
                                    Degree           => 16);
   END LOOP;
   --Subpartition Table
   FOR c IN Rc4 LOOP
      v_Output := 'Subpartition Table:' || c.Table_Owner || ':' ||
                  c.Table_Name || ':' || c.Partition_Name || ':' ||
                  c.Subpartition_Name;
      INSERT INTO apps.Gather_Log VALUES (SYSDATE, v_Output);
      COMMIT;
      Dbms_Output.Put_Line(v_Output);
      Dbms_Stats.Gather_Table_Stats(Ownname          => c.Table_Owner,
                                    Tabname          => c.Table_Name,
                                    Partname         => c.Subpartition_Name,
                                    Granularity      => 'SUBPARTITION',
                                    Estimate_Percent => Dbms_Stats.Auto_Sample_Size,
                                    Degree           => 16);
   END LOOP;
   --Subpartition Table
   FOR c IN Rc5 LOOP
      v_Output := 'Partition Table:' || c.Table_Owner || ':' ||
                  c.Table_Name || ':' || c.Partition_Name;
      INSERT INTO apps.Gather_Log VALUES (SYSDATE, v_Output);
      COMMIT;
      Dbms_Output.Put_Line(v_Output);
      Dbms_Stats.Gather_Table_Stats(Ownname          => c.Table_Owner,
                                    Tabname          => c.Table_Name,
                                    Partname         => c.Partition_Name,
                                    Granularity      => 'PARTITION',
                                    Estimate_Percent => Dbms_Stats.Auto_Sample_Size,
                                    Degree           => 16);
   END LOOP;
   --Table
   FOR c IN Rc6 LOOP
      v_Output := ' Table:' || c.Table_Owner || ':' || c.Table_Name;
      INSERT INTO apps.Gather_Log VALUES (SYSDATE, v_Output);
      COMMIT;
      Dbms_Output.Put_Line(v_Output);
      Dbms_Stats.Gather_Table_Stats(Ownname          => c.Table_Owner,
                                    Tabname          => c.Table_Name,
                                    Partname         => NULL,
                                    Estimate_Percent => Dbms_Stats.Auto_Sample_Size,
                                    Degree           => 16);
   END LOOP;
END;
/