alter system set sort_area_retained_size=536870912 scope=spfile;
alter system set sort_area_size=1073741824 scope=spfile;
alter system set shared_pool_size=128G scope=both;
alter system set shared_pool_reserved_size=9728M scope=spfile;
alter system set log_buffer=27262976 scope =spfile;
alter system set optimizer_index_cost_adj=25 scope=both;
alter system set optimizer_index_caching=80 scope=both;
alter system set plsql_code_type=NATIVE scope=both;
alter system set job_queue_processes=256 scope=both;
alter system set aq_tm_processes=16 scope=both;
alter system set db_writer_processes=32 scope=spfile;
alter system set log_archive_max_processes=8 scope=spfile;
alter system set parallel_max_servers=128 scope=both;
alter system set parallel_servers_target=128 scope=both;

alter system set parallel_threads_per_cpu=2 scope=both;
alter system set result_cache_max_size=2G scope=both;
alter system set session_cached_cursors=4096 scope=spfile;
alter system set DDL_LOCK_TIMEOUT=150 scope=both;
ALTER SYSTEM SET open_cursors=65535 SCOPE=BOTH;
alter system set archive_lag_target=0 scope=both;
alter system set CURSOR_SHARING=EXACT scope=both;
alter system set db_recovery_file_dest_size=2048 G scope=both;

_optimizer_index_compute_stats
--OLTP -- force
--Mixed workload similar (where you need a different plan for some of the queries)
--DSS/DW -- exact 

SELECT NAME,
       VALUE,
       (CASE
          WHEN p.Name = '_b_tree_bitmap_plans' AND p.Value = 'FALSE' THEN
           'GOOD'
          WHEN p.Name = '_fast_full_scan_enabled' AND p.Value = 'FALSE' THEN
           'GOOD'
          WHEN p.Name = '_like_with_bind_as_equality' AND p.Value = 'TRUE' THEN
           'GOOD'
          WHEN p.Name = '_optimizer_autostats_job' AND p.Value = 'FALSE' THEN
           'GOOD'
          WHEN p.Name = '_sort_elimination_cost_ratio' AND p.Value = '5' THEN
           'GOOD'
          WHEN p.Name = '_trace_files_public' AND p.Value = 'TRUE' THEN
           'GOOD'
          WHEN p.Name = 'cursor_sharing' AND p.Value = 'EXACT' THEN
           'GOOD'
          WHEN p.Name = 'optimizer_secure_view_merging' AND
               p.Value = 'FALSE' THEN
           'GOOD'
          WHEN p.Name = 'plsql_code_type' AND p.Value = 'NATIVE' THEN
           'GOOD'
          WHEN p.Name = 'sec_case_sensitive_logon' AND p.Value = 'FALSE' THEN
           'GOOD'
          WHEN p.Name = 'dml_locks' AND p.Value = '10000' THEN
           'GOOD'
          WHEN p.Name = 'cursor_space_for_time' AND p.Value = 'FALSE' THEN
           'GOOD'
          WHEN p.Name = 'optimizer_mode' AND
               p.Value IN ('ALL_ROWS',
                           'FIRST_ROWS',
                           'CHOOSE') THEN
           'COST-BASE'
          ELSE
           'BAD'
       END) Good_Or_Bad
  FROM V$parameter p
 WHERE NAME IN ('optimizer_index_cost_adj',
                'optimizer_index_caching',
                '_optimizer_autostats_job',
                '_trace_files_public',
                '_sort_elimination_cost_ratio',
                '_like_with_bind_as_equality',
                '_fast_full_scan_enabled',
                '_b_tree_bitmap_plans',
                'optimizer_secure_view_merging',
                'plsql_code_type',
                'sec_case_sensitive_logon',
                'cursor_sharing',
                'processes',
                'sessions',
                'open_cursors',
                'sga_target',
                'shared_pool_size',
                'shared_pool_reserved_size',
                'sort_area_size',
                'sort_area_retained_size',
                'log_buffer',
                'dml_locks',
                'cursor_space_for_time',
                'optimizer_mode',
                'pga_aggregate_target',
                'sga_max_size',
                'memory_max_target', 'aq_tm_processes', 'job_queue_processes','_optimizer_index_compute_stats')
    OR NAME LIKE '% %'
 ORDER BY NAME
;
