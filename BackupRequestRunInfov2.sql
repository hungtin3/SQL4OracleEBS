--CREATE TABLE FND_CONC_REQ_SUMMARY_HIS AS SELECT * FROM FND_CONC_REQ_SUMMARY_V WHERE ROWNUM=0;
--@@create_audit_his_table.sql

PROMPT ***RECORD COUNT SYSDATE -1 FND_CONC_REQ_SUMMARY_HIS ***
SELECT COUNT(*) FROM FND_CONC_REQ_SUMMARY_V
WHERE  TRUNC(REQUEST_DATE) < TRUNC(SYSDATE) 
AND REQUEST_DATE >  (SELECT nvl(max(REQUEST_DATE), sysdate-365) FROM FND_CONC_REQ_SUMMARY_HIS);

INSERT INTO FND_CONC_REQ_SUMMARY_HIS 
SELECT *
  FROM FND_CONC_REQ_SUMMARY_V
  WHERE  TRUNC(REQUEST_DATE) < TRUNC(SYSDATE) 
  AND REQUEST_DATE >  (SELECT nvl(max(REQUEST_DATE), sysdate-365) FROM FND_CONC_REQ_SUMMARY_HIS)
   --AND PHASE_CODE = 'C' AND STATUS_CODE = 'C'
   ;
COMMIT;
   
PROMPT ***RECORD COUNT SYSDATE -1 FND_LOGINS_HIS ***
SELECT COUNT(*) FROM FND_LOGINS 
WHERE  TRUNC(start_time) < TRUNC(SYSDATE) 
AND start_time >  (SELECT nvl(max(start_time), sysdate-365) FROM FND_LOGINS_HIS);


INSERT INTO FND_LOGINS_HIS 
SELECT *
  FROM FND_LOGINS
  WHERE  TRUNC(start_time) < TRUNC(SYSDATE) 
  AND start_time >  (SELECT nvl(max(start_time), sysdate-365) FROM FND_LOGINS_HIS)
   --AND PHASE_CODE = 'C' AND STATUS_CODE = 'C'
   ;
COMMIT;


PROMPT ***RECORD COUNT SYSDATE -1 FND_LOGIN_RESPONSIBILITIES_HIS ***
SELECT COUNT(*) FROM FND_LOGIN_RESPONSIBILITIES 
WHERE  TRUNC(start_time) < TRUNC(SYSDATE) 
AND start_time >  (SELECT nvl(max(start_time), sysdate-365) FROM FND_LOGIN_RESPONSIBILITIES_HIS);



INSERT INTO FND_LOGIN_RESPONSIBILITIES_HIS 
SELECT *
  FROM FND_LOGIN_RESPONSIBILITIES
  WHERE  TRUNC(start_time) < TRUNC(SYSDATE) 
  AND start_time >  (SELECT nvl(max(start_time), sysdate-365) FROM FND_LOGIN_RESPONSIBILITIES_HIS)
   --AND PHASE_CODE = 'C' AND STATUS_CODE = 'C'
   ;

COMMIT;
   
PROMPT ***RECORD COUNT SYSDATE -1 FND_LOGIN_RESP_FORMS***
SELECT COUNT(*) FROM FND_LOGIN_RESP_FORMS 
WHERE  TRUNC(start_time) < TRUNC(SYSDATE) 
AND start_time >  (SELECT nvl(max(start_time), sysdate-365) FROM FND_LOGIN_RESP_FORMS_HIS);



INSERT INTO FND_LOGIN_RESP_FORMS_HIS 
SELECT *
  FROM FND_LOGIN_RESP_FORMS
  WHERE  TRUNC(start_time) < TRUNC(SYSDATE) 
  AND start_time >  (SELECT nvl(max(start_time), sysdate-365) FROM FND_LOGIN_RESP_FORMS_HIS)
   --AND PHASE_CODE = 'C' AND STATUS_CODE = 'C'
   ;   
COMMIT;