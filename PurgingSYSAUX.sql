REM @E:\GoogleDrive\runall\PurgingSYSAUX.sql
set pagesize 600
set linesize 150
set head on
set echo on
SET feedback on
SET VERIFY on
SET timing on
select dbms_stats.get_stats_history_retention from dual;

select dbms_stats.get_stats_history_availability from dual;

exec dbms_stats.alter_stats_history_retention(14);

prompt ***** Purging 200 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-200);
commit;
prompt ***** Purging 199 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-199);
commit;
prompt ***** Purging 198 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-198);
commit;
prompt ***** Purging 197 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-197);
commit;
prompt ***** Purging 196 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-196);
commit;
prompt ***** Purging 195 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-195);
commit;
prompt ***** Purging 194 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-194);
commit;
prompt ***** Purging 193 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-193);
commit;
prompt ***** Purging 192 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-192);
commit;
prompt ***** Purging 191 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-191);
commit;
prompt ***** Purging 190 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-190);
commit;
prompt ***** Purging 189 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-189);
commit;
prompt ***** Purging 188 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-188);
commit;
prompt ***** Purging 187 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-187);
commit;
prompt ***** Purging 186 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-186);
commit;
prompt ***** Purging 185 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-185);
commit;
prompt ***** Purging 184 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-184);
commit;
prompt ***** Purging 183 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-183);
commit;
prompt ***** Purging 182 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-182);
commit;
prompt ***** Purging 181 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-181);
commit;
prompt ***** Purging 180 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-180);
commit;
prompt ***** Purging 179 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-179);
commit;
prompt ***** Purging 178 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-178);
commit;
prompt ***** Purging 177 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-177);
commit;
prompt ***** Purging 176 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-176);
commit;
prompt ***** Purging 175 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-175);
commit;
prompt ***** Purging 174 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-174);
commit;
prompt ***** Purging 173 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-173);
commit;
prompt ***** Purging 172 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-172);
commit;
prompt ***** Purging 171 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-171);
commit;
prompt ***** Purging 170 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-170);
commit;
prompt ***** Purging 169 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-169);
commit;
prompt ***** Purging 168 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-168);
commit;
prompt ***** Purging 167 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-167);
commit;
prompt ***** Purging 166 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-166);
commit;
prompt ***** Purging 165 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-165);
commit;
prompt ***** Purging 164 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-164);
commit;
prompt ***** Purging 163 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-163);
commit;
prompt ***** Purging 162 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-162);
commit;
prompt ***** Purging 161 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-161);
commit;
prompt ***** Purging 160 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-160);
commit;
prompt ***** Purging 159 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-159);
commit;
prompt ***** Purging 158 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-158);
commit;
prompt ***** Purging 157 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-157);
commit;
prompt ***** Purging 156 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-156);
commit;
prompt ***** Purging 155 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-155);
commit;
prompt ***** Purging 154 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-154);
commit;
prompt ***** Purging 153 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-153);
commit;
prompt ***** Purging 152 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-152);
commit;
prompt ***** Purging 151 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-151);
commit;
prompt ***** Purging 150 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-150);
commit;
prompt ***** Purging 149 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-149);
commit;
prompt ***** Purging 148 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-148);
commit;
prompt ***** Purging 147 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-147);
commit;
prompt ***** Purging 146 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-146);
commit;
prompt ***** Purging 145 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-145);
commit;
prompt ***** Purging 144 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-144);
commit;
prompt ***** Purging 143 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-143);
commit;
prompt ***** Purging 142 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-142);
commit;
prompt ***** Purging 141 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-141);
commit;
prompt ***** Purging 140 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-140);
commit;
prompt ***** Purging 139 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-139);
commit;
prompt ***** Purging 138 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-138);
commit;
prompt ***** Purging 137 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-137);
commit;
prompt ***** Purging 136 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-136);
commit;
prompt ***** Purging 135 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-135);
commit;
prompt ***** Purging 134 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-134);
commit;
prompt ***** Purging 133 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-133);
commit;
prompt ***** Purging 132 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-132);
commit;
prompt ***** Purging 131 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-131);
commit;
prompt ***** Purging 130 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-130);
commit;
prompt ***** Purging 129 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-129);
commit;
prompt ***** Purging 128 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-128);
commit;
prompt ***** Purging 127 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-127);
commit;
prompt ***** Purging 126 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-126);
commit;
prompt ***** Purging 125 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-125);
commit;
prompt ***** Purging 124 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-124);
commit;
prompt ***** Purging 123 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-123);
commit;
prompt ***** Purging 122 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-122);
commit;
prompt ***** Purging 121 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-121);
commit;
prompt ***** Purging 120 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-120);
commit;
prompt ***** Purging 119 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-119);
commit;
prompt ***** Purging 118 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-118);
commit;
prompt ***** Purging 117 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-117);
commit;
prompt ***** Purging 116 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-116);
commit;
prompt ***** Purging 115 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-115);
commit;
prompt ***** Purging 114 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-114);
commit;
prompt ***** Purging 113 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-113);
commit;
prompt ***** Purging 112 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-112);
commit;
prompt ***** Purging 111 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-111);
commit;
prompt ***** Purging 110 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-110);
commit;
prompt ***** Purging 109 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-109);
commit;
prompt ***** Purging 108 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-108);
commit;
prompt ***** Purging 107 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-107);
commit;
prompt ***** Purging 106 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-106);
commit;
prompt ***** Purging 105 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-105);
commit;
prompt ***** Purging 104 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-104);
commit;
prompt ***** Purging 103 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-103);
commit;
prompt ***** Purging 102 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-102);
commit;
prompt ***** Purging 101 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-101);
commit;
prompt ***** Purging 100 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-100);
commit;
prompt ***** Purging 99 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-99);
commit;
prompt ***** Purging 98 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-98);
commit;
prompt ***** Purging 97 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-97);
commit;
prompt ***** Purging 96 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-96);
commit;
prompt ***** Purging 95 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-95);
commit;
prompt ***** Purging 94 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-94);
commit;
prompt ***** Purging 93 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-93);
commit;
prompt ***** Purging 92 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-92);
commit;
prompt ***** Purging 91 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-91);
commit;
prompt ***** Purging 90 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-90);
commit;
prompt ***** Purging 89 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-89);
commit;
prompt ***** Purging 88 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-88);
commit;
prompt ***** Purging 87 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-87);
commit;
prompt ***** Purging 86 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-86);
commit;
prompt ***** Purging 85 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-85);
commit;
prompt ***** Purging 84 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-84);
commit;
prompt ***** Purging 83 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-83);
commit;
prompt ***** Purging 82 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-82);
commit;
prompt ***** Purging 81 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-81);
commit;
prompt ***** Purging 80 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-80);
commit;
prompt ***** Purging 79 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-79);
commit;
prompt ***** Purging 78 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-78);
commit;
prompt ***** Purging 77 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-77);
commit;
prompt ***** Purging 76 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-76);
commit;
prompt ***** Purging 75 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-75);
commit;
prompt ***** Purging 74 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-74);
commit;
prompt ***** Purging 73 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-73);
commit;
prompt ***** Purging 72 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-72);
commit;
prompt ***** Purging 71 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-71);
commit;
prompt ***** Purging 70 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-70);
commit;
prompt ***** Purging 69 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-69);
commit;
prompt ***** Purging 68 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-68);
commit;
prompt ***** Purging 67 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-67);
commit;
prompt ***** Purging 66 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-66);
commit;
prompt ***** Purging 65 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-65);
commit;
prompt ***** Purging 64 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-64);
commit;
prompt ***** Purging 63 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-63);
commit;
prompt ***** Purging 62 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-62);
commit;
prompt ***** Purging 61 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-61);
commit;
prompt ***** Purging 60 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-60);
commit;
prompt ***** Purging 59 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-59);
commit;
prompt ***** Purging 58 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-58);
commit;
prompt ***** Purging 57 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-57);
commit;
prompt ***** Purging 56 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-56);
commit;
prompt ***** Purging 55 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-55);
commit;
prompt ***** Purging 54 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-54);
commit;
prompt ***** Purging 53 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-53);
commit;
prompt ***** Purging 52 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-52);
commit;
prompt ***** Purging 51 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-51);
commit;
prompt ***** Purging 50 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-50);
commit;
prompt ***** Purging 49 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-49);
commit;
prompt ***** Purging 48 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-48);
commit;
prompt ***** Purging 47 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-47);
commit;
prompt ***** Purging 46 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-46);
commit;
prompt ***** Purging 45 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-45);
commit;
prompt ***** Purging 44 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-44);
commit;
prompt ***** Purging 43 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-43);
commit;
prompt ***** Purging 42 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-42);
commit;
prompt ***** Purging 41 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-41);
commit;
prompt ***** Purging 40 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-40);
commit;
prompt ***** Purging 39 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-39);
commit;
prompt ***** Purging 38 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-38);
commit;
prompt ***** Purging 37 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-37);
commit;
prompt ***** Purging 36 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-36);
commit;
prompt ***** Purging 35 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-35);
commit;
prompt ***** Purging 34 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-34);
commit;
prompt ***** Purging 33 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-33);
commit;
prompt ***** Purging 32 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-32);
commit;
prompt ***** Purging 31 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-31);
commit;
prompt ***** Purging 30 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-30);
commit;
prompt ***** Purging 29 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-29);
commit;
prompt ***** Purging 28 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-28);
commit;
prompt ***** Purging 27 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-27);
commit;
prompt ***** Purging 26 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-26);
commit;
prompt ***** Purging 25 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-25);
commit;
prompt ***** Purging 24 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-24);
commit;
prompt ***** Purging 23 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-23);
commit;
prompt ***** Purging 22 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-22);
commit;
prompt ***** Purging 21 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-21);
commit;
prompt ***** Purging 20 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-20);
commit;
prompt ***** Purging 19 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-19);
commit;
prompt ***** Purging 18 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-18);
commit;
prompt ***** Purging 17 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-17);
commit;
prompt ***** Purging 16 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-16);
commit;
prompt ***** Purging 15 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-15);
commit;
prompt ***** Purging 14 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-14);
commit;
prompt ***** Purging 13 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-13);
commit;
prompt ***** Purging 12 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-12);
commit;
prompt ***** Purging 11 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-11);
commit;
prompt ***** Purging 10 days old *****
exec DBMS_STATS.PURGE_STATS(SYSDATE-10);
commit;

alter table SYS.WRI$_OPTSTAT_TAB_HISTORY move tablespace sysaux;

alter table SYS.WRI$_OPTSTAT_IND_HISTORY move tablespace sysaux;

alter table SYS.WRI$_OPTSTAT_HISTHEAD_HISTORY move tablespace sysaux;

alter table SYS.WRI$_OPTSTAT_HISTGRM_HISTORY move tablespace sysaux;

alter table SYS.WRI$_OPTSTAT_AUX_HISTORY move tablespace sysaux;

alter table SYS.WRI$_OPTSTAT_OPR move tablespace sysaux;

alter table SYS.WRH$_OPTIMIZER_ENV move tablespace sysaux;

Alter index SYS.I_WRI$_OPTSTAT_IND_ST rebuild TABLESPACE SYSAUX;

Alter index SYS.I_WRI$_OPTSTAT_IND_OBJ#_ST rebuild TABLESPACE SYSAUX;

Alter index SYS.I_WRI$_OPTSTAT_HH_ST rebuild TABLESPACE SYSAUX;

Alter index SYS.I_WRI$_OPTSTAT_HH_OBJ_ICOL_ST rebuild TABLESPACE SYSAUX;

Alter index SYS.I_WRI$_OPTSTAT_TAB_ST rebuild TABLESPACE SYSAUX;

Alter index SYS.I_WRI$_OPTSTAT_TAB_OBJ#_ST rebuild TABLESPACE SYSAUX;

Alter index SYS.I_WRI$_OPTSTAT_OPR_STIME rebuild TABLESPACE SYSAUX;