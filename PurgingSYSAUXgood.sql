
begin
for i in reverse 20..200
loop
Dbms_Output.Put_Line('***** Purging '||i||' days old *****');
dbms_stats.purge_stats(sysdate-i);
end loop;
end;
/ 


alter table SYS.WRI$_OPTSTAT_TAB_HISTORY move tablespace sysaux;
alter table SYS.WRI$_OPTSTAT_IND_HISTORY move tablespace sysaux;
alter table SYS.WRI$_OPTSTAT_HISTHEAD_HISTORY move tablespace sysaux;
alter table SYS.WRI$_OPTSTAT_HISTGRM_HISTORY move tablespace sysaux;
alter table SYS.WRI$_OPTSTAT_AUX_HISTORY move tablespace sysaux;
alter table SYS.WRI$_OPTSTAT_OPR move tablespace sysaux;
alter table SYS.WRH$_OPTIMIZER_ENV move tablespace sysaux;
Alter index SYS.I_WRI$_OPTSTAT_IND_ST rebuild TABLESPACE SYSAUX;
Alter index SYS.I_WRI$_OPTSTAT_IND_OBJ#_ST rebuild TABLESPACE SYSAUX;
Alter index SYS.I_WRI$_OPTSTAT_HH_ST rebuild TABLESPACE SYSAUX;
Alter index SYS.I_WRI$_OPTSTAT_HH_OBJ_ICOL_ST rebuild TABLESPACE SYSAUX;
Alter index SYS.I_WRI$_OPTSTAT_TAB_ST rebuild TABLESPACE SYSAUX;
Alter index SYS.I_WRI$_OPTSTAT_TAB_OBJ#_ST rebuild TABLESPACE SYSAUX;
Alter index SYS.I_WRI$_OPTSTAT_OPR_STIME rebuild TABLESPACE SYSAUX;