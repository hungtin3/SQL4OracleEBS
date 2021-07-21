set pagesize 600
set linesize 150
set head on
set echo on
set feedback on
SET VERIFY OFF
--@E:\GoogleDrive\runall\Purge_recyclebin.sql
--select count(*) from dba_recyclebin;
select owner,TS_NAME, sum(space)* 8 / 1024/1024 "Size in GB" from dba_recyclebin group by owner,TS_NAME order by sum(space);
--PURGE RECYCLEBIN;
PURGE TABLESPACE APPS_TS_TX_DATA USER GL;
PURGE TABLESPACE APPS_TS_TX_IDX USER GL;
PURGE TABLESPACE APPS_TS_TX_DATA USER PA;
PURGE TABLESPACE APPS_TS_TX_IDX USER PA;

PURGE TABLESPACE APPS_TS_TX_DATA USER backup;
PURGE TABLESPACE APPS_TS_TX_DATA USER apps;
PURGE TABLESPACE APPS_TS_TX_DATA USER applsys;
PURGE TABLESPACE APPS_TS_TX_IDX USER apps;

PURGE TABLESPACE APPS_TS_TX_DATA USER inv;
PURGE TABLESPACE APPS_TS_TX_DATA USER xla;
PURGE TABLESPACE tichhop USER tichhop;
PURGE TABLESPACE EVN_CUSTOM USER evn;
PURGE TABLESPACE EVN_CUSTOM USER apps;


PURGE TABLESPACE APPS_TS_TX_DATA USER evn;
PURGE TABLESPACE APPS_TS_TX_DATA USER pa;
PURGE TABLESPACE APPS_TS_TX_DATA USER inv;
PURGE TABLESPACE APPS_TS_TX_IDX USER inv;
PURGE TABLESPACE APPS_TS_TX_DATA USER bom;
PURGE TABLESPACE APPS_TS_TX_IDX USER bom;
PURGE TABLESPACE APPS_TS_SUMMARY USER bom;
PURGE TABLESPACE APPS_TS_TX_DATA USER fa;
PURGE TABLESPACE APPS_TS_TX_IDX USER fa;


PURGE TABLESPACE APPS_TS_TX_DATA USER ar;
PURGE TABLESPACE APPS_TS_TX_IDX USER ar;
PURGE TABLESPACE APPS_TS_TX_DATA USER ap;
PURGE TABLESPACE APPS_TS_TX_IDX USER ap;
PURGE TABLESPACE APPS_TS_TX_DATA USER zx;
PURGE TABLESPACE APPS_TS_TX_IDX USER zx;
purge tablespace APPS_TS_TX_IDX user GL;

purge tablespace APPS_TS_TX_DATA user GL;
purge tablespace APPS_TS_INTERFACE user GL;
purge tablespace APPS_TS_GL_DATA user XLA;
purge tablespace APPS_TS_XLA_IDX user XLA;
purge tablespace APPS_TS_XLA_DATA user XLA;
purge tablespace APPS_TS_BOM_IDX user BOM;
purge tablespace APPS_TS_BOM_DATA user BOM;

purge tablespace APPS_TS_INV_IDX user INV;
purge tablespace APPS_TS_INV_DATA user INV;
purge tablespace APPS_TS_GL_IDX user GL;
purge tablespace APPS_TS_GL_DATA user GL;
PURGE TABLESPACE APPS_TS_AR_DATA USER ar;
PURGE TABLESPACE APPS_TS_AR_IDX USER ar;
PURGE TABLESPACE APPS_TS_AP_DATA USER ap;
PURGE TABLESPACE APPS_TS_AP_IDX USER ap;
PURGE TABLESPACE TICHHOP_PORTAL USER TICHHOP_PORTAL;

commit;