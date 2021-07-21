REM @E:\GoogleDrive\runall\PurgingSYSAUX.sql
set pagesize 600
set linesize 150
set head on
set echo on
SET feedback on
SET VERIFY on
SET timing on
select dbms_stats.get_stats_history_retention from dual;

select dbms_stats.get_stats_history_availability from dual;

exec dbms_stats.alter_stats_history_retention(9);

prompt ***** Purging 20 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-20);
commit;
prompt ***** Purging 19 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-19);
commit;
prompt ***** Purging 18 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-18);
commit;
prompt ***** Purging 17 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-17);
commit;
prompt ***** Purging 16 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-16);
commit;
prompt ***** Purging 15 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-15);
commit;
prompt ***** Purging 14 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-14);
commit;
prompt ***** Purging 13 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-13);
commit;
prompt ***** Purging 12 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-12);
commit;
prompt ***** Purging 11 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-11);
commit;
prompt ***** Purging 10 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-10);
commit;

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