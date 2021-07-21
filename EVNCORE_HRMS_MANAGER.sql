drop table apps.FND_MENU_ENTRIES_L4;
-- Create table
create table apps.FND_MENU_ENTRIES_L4
(
  user_menu_name       VARCHAR2(80) not null,
  entry_sequence       NUMBER not null,
  prompt               VARCHAR2(60),
  menu_id              NUMBER,
  sub_menu_name        VARCHAR2(80),
  menu_creation_date   DATE,
  sub_menu_description VARCHAR2(240),
  function_id          NUMBER,
  user_function_name   VARCHAR2(80),
  function_name        VARCHAR2(480),
  func_creation_date   DATE,
  user_function_desc   VARCHAR2(240),
  grant_flag           VARCHAR2(1) not null
)
tablespace APPS_TS_TX_DATA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 128K
    next 128K
    minextents 1
    maxextents unlimited
    pctincrease 0
  );


insert into Apps.FND_MENU_ENTRIES_L4 (USER_MENU_NAME, ENTRY_SEQUENCE, PROMPT, MENU_ID, SUB_MENU_NAME, MENU_CREATION_DATE, SUB_MENU_DESCRIPTION, FUNCTION_ID, USER_FUNCTION_NAME, FUNCTION_NAME, FUNC_CREATION_DATE, USER_FUNCTION_DESC, GRANT_FLAG)
values ('EVNCORE_HRMS_MANAGER', 10, 'People', -1, null, null, null, 3796, 'Combined Person & Assignment Form WF="US HRMS TSKFLW"', 'PERWSHRG-403-EI', to_date('01-01-1980', 'dd-mm-yyyy'), 'WORKFLOW_NAME="US HRMS PERSON TASKFLOW"', 'Y');
commit;
prompt Done.
