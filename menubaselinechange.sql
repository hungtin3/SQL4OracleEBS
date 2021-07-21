select b.base_line_date, count(*) from apps.menu_baseline b group by b.base_line_date order by 1 desc;

prompt ***** Menu Added *****
col User_Menu_Name form a20 
col Function_Name form a30 
col DATA_SOURCE_CODE form a30 
col CREATED_BY form 99999

SELECT b.User_Menu_Name,
       b.Function_Name,
       b.Mnu_Level,
       b.Mnu_Level,
       b.Menu_Id,
       b.Entry_Sequence,
       b.Function_Id
  FROM Apps.Menu_Baseline b
 WHERE b.Base_Line_Date = '21-DEC-2017'
   AND (b.Mnu_Level, b.Mnu_Level, b.Menu_Id, b.Entry_Sequence, b.Function_Id) NOT IN
       (SELECT b.Mnu_Level,
               b.Mnu_Level,
               b.Menu_Id,
               b.Entry_Sequence,
               b.Function_Id
          FROM Apps.Menu_Baseline b
         WHERE b.Base_Line_Date = '04-NOV-2017');

prompt ***** Menu Deleted *****		 
SELECT b.User_Menu_Name,
       b.Function_Name,
       b.Mnu_Level,
       b.Mnu_Level,
       b.Menu_Id,
       b.Entry_Sequence,
       b.Function_Id
  FROM Apps.Menu_Baseline b
 WHERE b.Base_Line_Date = '04-NOV-2017'
   AND (b.Mnu_Level, b.Mnu_Level, b.Menu_Id, b.Entry_Sequence, b.Function_Id) NOT IN
       (SELECT b.Mnu_Level,
               b.Mnu_Level,
               b.Menu_Id,
               b.Entry_Sequence,
               b.Function_Id
          FROM Apps.Menu_Baseline b
         WHERE b.Base_Line_Date = '21-DEC-2017');		 