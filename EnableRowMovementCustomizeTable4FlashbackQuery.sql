SELECT t.Owner,
       t.Tablespace_Name,
       t.Table_Name,
       t.Row_Movement,
       o.CREATED,
       t.Temporary,
       'alter table '||t.owner||'.'||t.table_name||' ENABLE ROW MOVEMENT;'
  FROM All_Objects o, All_Tables t
 WHERE 1 = 1
   AND o.Object_Type = 'TABLE'
   AND o.Object_Name = t.Table_Name
   AND o.Owner = t.Owner
   AND o.Object_Name LIKE 'EVN%'
   and o.OWNER not in ('BACKUP')
   and t.TEMPORARY='N'
 ORDER BY o.Created DESC
