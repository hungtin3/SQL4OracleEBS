prompt *****DB Login Activities*****
col USER_ID  form a20 
col HOST form a40
col IP_ADDRESS form a20
col LOGIN_DATE form a25
col enable_trace  form a15 
col start_date  form a15
col end_date   form a15

SELECT *
  FROM SYSTEM.USER_LOG
 WHERE login_date >= trunc(SYSDATE - 10)
 and USER_ID ='APPS'
 ORDER BY login_date DESC;