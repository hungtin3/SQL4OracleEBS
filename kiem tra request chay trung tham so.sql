select fcrsv.REQUEST_ID,
--       fcpt.concurrent_program_id,
       fcpt.user_concurrent_program_name,
       fcrsv.REQUESTOR,
       fcrsv.argument_text,
       fcrsv.REQUEST_DATE,
       decode(fcrsv.phase_code, 'P', decode(fcrsv.hold_flag, 'Y', 'Inactive', fl_p.meaning), fl_p.meaning) phase,
       decode(fcrsv.phase_code, 'P', decode(fcrsv.hold_flag, 'Y', 'On Hold', decode(sign(fcrsv.requested_start_date - sysdate), 1, 'Scheduled', fl_s.meaning)), fl_s.meaning) status,
       CASE
         WHEN decode(fcrsv.phase_code, 'P', decode(fcrsv.hold_flag, 'Y', 'On Hold', decode(sign(fcrsv.requested_start_date - sysdate), 1, 'Scheduled', fl_s.meaning)), fl_s.meaning) = 'Scheduled'
           THEN (SELECT decode(c.class_type, 'P', 'Periodic', 'S', 'On Specific Days', 'X', 'Advanced', c.class_type) schedule_type
                 from applsys.fnd_concurrent_requests r,
                      applsys.fnd_conc_release_classes c
                 where r.phase_code = 'P'
                 and c.application_id = r.release_class_app_id
                 and c.release_class_id = r.release_class_id
                 and nvl(c.date2, sysdate + 1) > sysdate
                 and c.class_type is not null
                 AND r.request_id =	fcrsv.REQUEST_ID)
         ELSE NULL
       END schedule_type,
       CASE
         WHEN decode(fcrsv.phase_code, 'P', decode(fcrsv.hold_flag, 'Y', 'On Hold', decode(sign(fcrsv.requested_start_date - sysdate), 1, 'Scheduled', fl_s.meaning)), fl_s.meaning) = 'Scheduled'
           THEN (SELECT case
                       when c.class_type = 'P' then
                        'Repeat every ' ||
                        substr(c.class_info, 1, instr(c.class_info, ':') - 1) ||
                        decode(substr(c.class_info, instr(c.class_info, ':', 1, 1) + 1, 1), 'N', ' minutes', 'M', ' months', 'H', ' hours', 'D', ' days') ||
                        decode(substr(c.class_info, instr(c.class_info, ':', 1, 2) + 1, 1), 'S', ' from the start of the prior run', 'C', ' from the completion of the prior run')
                       when c.class_type = 'S' then
                        nvl2(dates.dates, 'Dates: ' || dates.dates || '. ', null) ||
                        decode(substr(c.class_info, 32, 1), '1', 'Last day of month ') ||
                        decode(sign(to_number(substr(c.class_info, 33))), '1', 'Days of week: ' || DECODE(substr(c.class_info, 33, 1), '1', 'Su ') || DECODE(substr(c.class_info, 34, 1), '1', 'Mo ') || DECODE(substr(c.class_info, 35, 1), '1', 'Tu ') || DECODE(substr(c.class_info, 36, 1), '1', 'We ') || DECODE(substr(c.class_info, 37, 1), '1', 'Th ') || DECODE(substr(c.class_info, 38, 1), '1', 'Fr ') || DECODE(substr(c.class_info, 39, 1), '1', 'Sa '))
                     end schedule
                from applsys.fnd_concurrent_requests r,
                     applsys.fnd_conc_release_classes c,
                     (SELECT release_class_id,
                             substr(max(SYS_CONNECT_BY_PATH(s, ' ')), 2) dates
                        FROM (select release_class_id,
                                     rank() over(partition by release_class_id order by s) a,
                                     s
                                from (select c.class_info,
                                             l,
                                             c.release_class_id,
                                             decode(substr(c.class_info, l, 1), '1', to_char(l)) s
                                        from (select level l from dual connect by level <= 31),
                                             applsys.fnd_conc_release_classes c
                                       where c.class_type = 'S')
                               where s is not null)
                      CONNECT BY PRIOR
                                  (a || release_class_id) = (a - 1) || release_class_id
                       START WITH a = 1
                       group by release_class_id) dates
               where r.phase_code = 'P'
                 and c.application_id = r.release_class_app_id
                 and c.release_class_id = r.release_class_id
                 and nvl(c.date2, sysdate + 1) > sysdate
                 and c.class_type is not null
                 and dates.release_class_id(+) = r.release_class_id
                 AND r.request_id =	fcrsv.REQUEST_ID)
         ELSE NULL
       END schedule
from apps.fnd_conc_req_summary_v fcrsv, 
     applsys.fnd_concurrent_programs_tl fcpt, 
     applsys.fnd_concurrent_programs fcp,
     apps.fnd_lookups fl_p,      
     apps.fnd_lookups fl_s,
     (SELECT fcrsv.argument_text,
             fcrsv.REQUESTOR,
             fcrsv.USER_CONCURRENT_PROGRAM_NAME
      from apps.fnd_conc_req_summary_v fcrsv, applsys.fnd_concurrent_programs_tl fcpt
      where 1 = 1
      and fcrsv.CONCURRENT_PROGRAM_ID = fcpt.concurrent_program_id
      and fcrsv.PROGRAM_APPLICATION_ID = fcpt.application_id
      --and fcpt.language = 'VN'
      AND fcrsv.phase_code NOT LIKE 'C'
      and fcrsv.status_code NOT LIKE 'C'
      GROUP BY fcrsv.argument_text, fcrsv.REQUESTOR, fcrsv.USER_CONCURRENT_PROGRAM_NAME
      HAVING COUNT(fcrsv.REQUEST_ID) > 1) a
where 1 = 1
and fcrsv.CONCURRENT_PROGRAM_ID = fcpt.concurrent_program_id
and fcrsv.PROGRAM_APPLICATION_ID = fcpt.application_id
AND fcpt.concurrent_program_id = fcp.CONCURRENT_PROGRAM_ID
and fcrsv.phase_code = fl_p.lookup_code
and fl_p.lookup_type = 'CP_PHASE_CODE'
and fcrsv.status_code = fl_s.lookup_code
and fl_s.lookup_type = 'CP_STATUS_CODE'
--and fcpt.language = 'VN'
AND fcrsv.phase_code NOT LIKE 'C'
and fcrsv.status_code NOT LIKE 'C'
AND fcrsv.requestor NOT LIKE 'SYSADMIN'
AND fcp.execution_method_code = 'P'
AND fcrsv.CONCURRENT_PROGRAM_ID NOT IN (
--37899, --Chuyển d.liệu sang Ph.hệ Sổ Cái 
38039, --Tiến trình Kế toán p.hệ TKPTrả 
32002, --Đảo Bút toán 
--32373, --Phân tích Tài khoản - (180 Ký tự)
32530 --Giao dịch kiểm soát ngân sách
)
AND fcrsv.ARGUMENT_TEXT  = a.ARGUMENT_TEXT
AND fcrsv.REQUESTOR = a.REQUESTOR
AND fcrsv.USER_CONCURRENT_PROGRAM_NAME = a.USER_CONCURRENT_PROGRAM_NAME
ORDER BY fcrsv.argument_text
