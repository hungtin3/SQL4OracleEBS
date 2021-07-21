set pages 1000
set linesize 135
col PROPERTY_NAME for a25
col PROPERTY_VALUE for a15
col DESCRIPTION for a35
col DIRECTORY_PATH for a70
col directory_name for a25
col OWNER for a10
col DB_LINK for a40
col HOST for a20
col "User_Concurrent_Queue_Name" format a50 heading 'Manager'
col "Running_Processes" for 9999 heading 'Running'
set head off
set feedback off
set echo off

break on utl_file_dir

select '--------------------------------------------------------------------------------' from dual;
select '-----------------------     Database Checks    ---------------------------------' from dual;
select '--------------------------------------------------------------------------------' from dual;
Prompt
select '************************ Getting Database Information  *************' from dual ;

select 'Database Name..................... : '||name from v$database;
select 'Database Status................... : '||open_mode from v$database;
select 'Archiving Status.................. : '||log_mode  from v$database;
select 'Global Name....................... : '||global_name from global_name;
select 'Creation Date..................... : '||to_char(created,'DD-MON-YYYY HH24:MI:SS') from v$database;
select 'Checking For Missing File......... : '||count(*) from v$recover_file;
select 'Checking Missing File Name ....... : '||count(*) from v$datafile where name like '%MISS%';
select 'Total SGA ........................ : '||round(sum(value)/(1024*1024))||' MB' from v$sga ;
select 'Database Version.................. : '||version from v$instance;
select 'Temporary Tablespace.............. : '||property_value from database_properties
                                                where property_name like 'default_temp_tablespace';
select 'Apps Temp Tablespace.............. : '||temporary_tablespace from dba_users where username like '%APPS%';
select 'Temp Tablespace size.............. : '||sum(maxbytes/1024/1024/1024)||' GB' from dba_temp_files group by tablespace_name;
select 'No of Invalid Object ............. : '||count(*) from dba_objects where status = 'INVALID' ;
select 'service Name...................... : '||value from v$parameter2 where name='service_names';
select 'plsql code type................... : '||value from v$parameter2 where name='plsql_code_type';
select 'plsql subdir count................ : '||value from v$parameter2 where name='plsql_native_library_subdir_count';
select 'plsql native library dir.......... : '||value from v$parameter2 where name='plsql_native_library_dir';
select 'Shared Pool Size.........,........ : '||(value/1024/1024) ||' MB' from v$parameter where name='shared_pool_size';
select 'Log Buffer........................ : '||(value/1024/1024) ||' MB' from v$parameter where name='log_buffer';
select 'Buffer Cache...................... : '||(value/1024/1024) ||' MB' from v$parameter where name='db_cache_size';
select 'Large Pool Size................... : '||(value/1024/1024) ||' MB' from v$parameter where name='large_pool_size';
select 'Java Pool Size.................... : '||(value/1024/1024) ||' MB' from v$parameter where name='java_pool_size';
select 'utl_file_dir...................... : '||value from v$parameter2 where name='utl_file_dir';
select directory_name||'.................... : '||directory_path from all_directories where rownum  < 15 ;

select '************************ Getting Apps Information *****************' from dual ;

select 'Home URL.......................... : '||home_url from apps.icx_parameters ;
select 'Session Cookie.................... : '||session_cookie from apps.icx_parameters ;
select 'Applicaiton Database ID........... : '||fnd_profile.value('apps_database_id') from dual;
select 'GSM Enabled....................... : '||fnd_profile.value('conc_gsm_enabled') from dual;
select 'Maintainance Mode................. : '||fnd_profile.value('apps_maintenance_mode') from dual;
select 'Site Name......................... : '||fnd_profile.value('Sitename')from dual;
select 'Bug Number........................ : '||bug_number from ad_bugs where bug_number='2728236';

select '************************ Doing Workflow Checks ********************' from dual ;

select 'No Open Notifications............. : '||count(*) from wf_notifications where mail_status in('MAIL','INVALID','OPEN');
select 'Name(wf_systems).................. : '||name from wf_systems;
select 'Display Name(wf_systems).......... : '||display_name from wf_systems;
select 'Address........................... : '||address from wf_agents;
select 'Workflow Mailer Status............ : '||component_status from applsys.fnd_svc_components
                                                where component_name like 'Workflow Notification Mailer';
select 'Test Address...................... : '||b.parameter_value
                                                from fnd_svc_comp_param_vals_v a, fnd_svc_comp_param_vals b
                                                where a.parameter_id=b.parameter_id
                                                and a.parameter_name in ('TEST_ADDRESS');
select 'From Address...................... : '||b.parameter_value
                                                from fnd_svc_comp_param_vals_v a, fnd_svc_comp_param_vals b
                                                where a.parameter_id=b.parameter_id
                                                and a.parameter_name in ('FROM');
select 'WF Admin Role..................... : '||text from wf_resources where name = 'WF_ADMIN_ROLE' and  rownum =1;


Prompt
Prompt Getting Apps Node Info
Prompt ************************
select Node_Name,'........................ : '||server_id from fnd_nodes;
select server_type||'......................: '||name from fnd_app_servers, fnd_nodes
                                                where fnd_app_servers.node_id =fnd_nodes.node_id;

select '************************ Doing Conc Mgr Checks  ********************' from dual ;

Prompt Getting Con Mgr Status
Prompt ************************
Prompt
Prompt Manager Name                                                 Hostname          No of Proc Running
Prompt ~~~~~~~~~~~~                                                 ~~~~~~~~          ~~~~~~~~~~~~~~~~~~
set lines 145
Column Target_Node   Format A12
select User_Concurrent_Queue_Name,'....... : '||Target_Node||' ...... : '||Running_Processes
                                                from fnd_concurrent_queues_vl
                                                where Running_Processes = Max_Processes
                                                and Running_Processes > 0;

Prompt
Prompt Getting Pending Request
Prompt ***********************
--select user_concurrent_program_name||'........ : '||request_id
--                                                  from fnd_concurrent_requests r, fnd_concurrent_programs_vl p, fnd_lookups s, fnd_lookups ph
--                                                  where r.concurrent_program_id = p.concurrent_program_id
--                                                 and r.phase_code = ph.lookup_code
--                                                and ph.lookup_type = 'CP_PHASE_CODE'
--                                               and r.status_code = s.lookup_code
--                                                  and s.lookup_type = 'CP_STATUS_CODE'
--                                                  and ph.meaning ='Pending'
--                                                  and rownum < 10
--                                                  order by to_date(actual_start_date, 'dd-MON-yy hh24:mi');
--

Prompt
Prompt Getting Workflow Components Status
Prompt **********************************

set pagesize 1000
set linesize 125
col COMPONENT_STATUS for a20
col COMPONENT_NAME for a45
col STARTUP_MODE for a12

select fsc.COMPONENT_NAME,
fsc.STARTUP_MODE,
fsc.COMPONENT_STATUS,
fcq.MAX_PROCESSES TARGET,
fcq.RUNNING_PROCESSES ACTUAL
from APPS.FND_CONCURRENT_QUEUES_VL fcq, APPS.FND_CP_SERVICES fcs,
APPS.FND_CONCURRENT_PROCESSES fcp, fnd_svc_components fsc
where fcq.MANAGER_TYPE = fcs.SERVICE_ID
and fcs.SERVICE_HANDLE = 'FNDCPGSC'
and fsc.concurrent_queue_id = fcq.concurrent_queue_id(+)
and fcq.concurrent_queue_id = fcp.concurrent_queue_id(+)
and fcq.application_id = fcp.queue_application_id(+)
and fcp.process_status_code(+) = 'A'
order by fcp.OS_PROCESS_ID, fsc.STARTUP_MODE;

select '--------------------------------------------------------------------------------' from dual;
select '-----------------------     End Of Database Checks  ----------------------------' from dual;
select '--------------------------------------------------------------------------------' from dual;
