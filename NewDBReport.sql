set pagesize 600
set linesize 150
set head on
set echo off
SET feedback off
SET VERIFY off

prompt ***** Redologs configuration *****
COLUMN Instance_Name FORMAT A8
COLUMN GROUP_ID FORMAT A12
COLUMN MEMBER FORMAT A45
COLUMN Mb FORMAT A10
COLUMN STATUS FORMAT A8
COLUMN User_Type FORMAT A12


SELECT i.instance_name, f.Group# GROUP_ID, f.MEMBER, round( g.Bytes / 1024/1024) Mb, g.STATUS
  FROM V$logfile f, V$log g, v$instance i
 WHERE f.Group# = g.Group#
 order by f.Group#, f.MEMBER ;

 
prompt ***** Parameter configuration *****
COLUMN Instance_Name FORMAT A8
COLUMN Name FORMAT A40
COLUMN Value FORMAT A25
COLUMN Mb FORMAT A25
COLUMN STATUS FORMAT A25
COLUMN User_Type FORMAT A12
 
SELECT i.instance_name, p.Name, p.Value
  FROM V$parameter p, v$instance i
 WHERE NAME IN ('log_buffer',
                'log_archive_max_processes',
                'log_checkpoint_interval',
                'log_checkpoint_timeout');

				
prompt ***** Check for any stale statistics. *****
col Owner for a15
col Index_Owner for a20
col Index_Name for a30
col Subpartition_Count for a20
col TABLE_NAME for a30
col Partition_Name for a30
col Subpartition_Name for a30
col Num_Rows for a20
col Last_Analyzed for a20
col Status for a20

SELECT Owner,
       Table_Name,
       Partition_Name,
       Subpartition_Name,
       Num_Rows,
       trunc(Last_Analyzed) Last_Analyzed
  FROM Dba_Tab_Statistics
 WHERE Stale_Stats = 'YES';

prompt ***** Check any invalid index/Partition*****
col Owner for a15
col Index_Name for a30
col Subpartition_Count for a20
col TABLE_NAME for a30
col Num_Rows for a20
col Last_Analyzed for a20
col Status for a20

 SELECT Owner, Index_Name, Table_Name, Num_Rows, trunc(Last_Analyzed) Last_Analyzed,  Status
   FROM Dba_Indexes
  WHERE Status NOT IN ('VALID',
                       'N/A');

SELECT Index_Owner,
       Index_Name,
       Partition_Name,
       Subpartition_Count,
       trunc(Last_Analyzed) Last_Analyzed,
       Status
  FROM Dba_Ind_Partitions
 WHERE Status <> 'USABLE';
					   

 