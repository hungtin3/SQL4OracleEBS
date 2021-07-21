set pagesize 600
set linesize 150
set head on
set echo off
SET feedback off
SET VERIFY off
COLUMN dr FORMAT A6
COLUMN segment_nm FORMAT A45
COLUMN used_size FORMAT A16
--Full child object verions
SELECT Dr,
       Segment_Nm,
       Segment_Type,
       Lpad(CASE
               WHEN Bytes < 1024 THEN
                Round(Bytes,
                      2) || ' B'
               WHEN Bytes < Power(1024,
                                  2) THEN
                Round((Bytes / 1024),
                      2) || ' KB'
               WHEN Bytes < Power(1024,
                                  3) THEN
                Round((Bytes / 1024 / 1024),
                      2) || ' MB'
               WHEN Bytes < Power(1024,
                                  4) THEN
                Round((Bytes / 1024 / 1024 / 1024),
                      2) || ' GB'
               ELSE
                Round((Bytes / 1024 / 1024 / 1024 / 1024),
                      2) || ' TB'
            END,
            15) AS Used_Size,
       Tablespace_Name
  FROM (SELECT Owner || '.' || Upper(Segment_Name) ||
               Nvl2(s.Partition_Name,
                    '-' || s.Partition_Name,
                    NULL) AS Segment_Nm, --DECODE(s.Partition_Name, NULL, '', '-'||s.partition_name) AS Segment_Nm,
               Segment_Type,
               Bytes,
               Tablespace_Name,
               Dense_Rank() Over(ORDER BY Bytes DESC) AS Dr
          FROM Dba_Segments s
         WHERE Owner NOT IN ('SYS',
                             'BACKUP',
                             'APPLSYS',
                             'SYSTEM',
                             'JTF',
                             'ICX',
                             'EGO',
                             'ENI',
                             'IBY',
                             'XDO')) a
 WHERE Dr <= 100 /* top-10 may have more then 10 */
 ORDER BY /* lots of ordering in cases of ties */ Bytes      DESC,
          Dr         ASC,
          Segment_Nm ASC;


