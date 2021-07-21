rem -----------------------------------------------------------------------
rem Filename:   rmanlist24.sql
rem Purpose:    List completed RMAN backups for the last 24-hours
rem             (use info from Dictionary - Control File Views)
rem Date:	12-Feb-2000
rem Author:     
rem -----------------------------------------------------------------------

set serveroutput on
set linesize 150
set pagesize 300

COL SESSION_KEY FORMAT 99999
col time_taken_display for a9
col output_bytes_display for a12
col status for a10

select session_key,
       input_type,
       status,
        to_char(start_time,'yyyy-mm-dd hh24:mi')   start_time,
       --to_char(end_time,'yyyy-mm-dd hh24:mi')   end_time,
       output_bytes_display,
       time_taken_display
from v$rman_backup_job_details
where start_time>=sysdate-5
order by session_key asc;

set line 150
col set_stamp for a10
col set_count for a10
col Mb for a7
col backup_type for a10
col pieces for a6
col Start_At for a12
col Completed_At for a10
col CF_Included for a3
col piece# for a7
col handle for a100

SELECT s.Set_Stamp,
       s.Set_Count,
       round(p.BYTES/1024/1024,0) Mb,
       Decode(s.Backup_Type,
              'L',
              'ArchiveLog',
              'D',
              'Datafile',
              'I',
              'Incremental') Backup_Type,
       s.Pieces,
--       To_Char(p.Start_Time,
--               'HH24:MI') Start_At,
--       To_Char(p.Completion_Time,
--               'HH24:MI') Completed_At,
       controlfile_included CF_Included,
       p.Piece#,
       p.Handle
  FROM V$backup_Set s, V$backup_Piece p
 WHERE s.Set_Stamp = p.Set_Stamp
   AND s.Set_Count = p.Set_Count
   AND s.Completion_Time > SYSDATE - 1
 ORDER BY s.Completion_Time, Piece#;

		 