-- ------------------------------------------------ 
-- API to UPDATE Oracle FND User 
-- ------------------------------------------------ 
DECLARE
   Lc_User_Name     VARCHAR2(100) := '';
   Lc_Description   VARCHAR2(100) := '';
   Lc_User_Password VARCHAR2(100) := '';
   Ld_User_End_Date          VARCHAR2(100) := NULL;
   Ld_Password_Date          VARCHAR2(100) := SYSDATE + 180;
   Ld_Password_Lifespan_Days NUMBER := 180;
   CURSOR Cur1 IS
      SELECT Fu.User_Name, Fu.Creation_Date, Fu.Last_Update_Date, trunc(Fu.End_Date)
        FROM Apps.Fnd_User Fu
       WHERE 1 = 1
         AND (Fu.User_Name LIKE 'KT.EVNIT')
         AND (Fu.End_Date IS NULL OR Fu.End_Date >= Trunc(SYSDATE))
       ORDER BY 1;
BEGIN
   FOR All_User IN Cur1 LOOP
      Lc_User_Name     := All_User.User_Name;
      Lc_User_Password :=  lower(Dbms_Random.String('X', 6))||Dbms_Random.String('X', 6);
      Lc_Description   := 'Anh NP - EVNICT';
	  Apps.Fnd_User_Pkg.Enableuser(Lc_User_Name);
      Fnd_User_Pkg.Updateuser(x_User_Name              => Lc_User_Name,
                              x_Owner                  => NULL,
                              x_Unencrypted_Password   => Lc_User_Password);
      COMMIT;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
           Dbms_Output.Put_Line(SQLERRM);
		   commit;
END;
/

SELECT i.Instance_Name,
       Usr.User_Name,
       Usr.Last_Update_Date,trunc(usr.End_Date) End_Date,
       Get_Pwd.Decrypt((SELECT (SELECT Get_Pwd.Decrypt(Fnd_Web_Sec.Get_Guest_Username_Pwd,
                                                      Usertable.Encrypted_Foundation_Password)
                                 FROM Dual) AS Apps_Password
                         FROM Fnd_User Usertable
                        WHERE Usertable.User_Name =
                              (SELECT Substr(Fnd_Web_Sec.Get_Guest_Username_Pwd,
                                             1,
                                             Instr(Fnd_Web_Sec.Get_Guest_Username_Pwd,
                                                   '/') - 1)
                                 FROM Dual)),
                       Usr.Encrypted_User_Password) Password
  FROM Fnd_User Usr, V$instance i
 WHERE 1 = 1
   AND (usr.User_Name LIKE 'KT.EVNIT')
   AND (usr.End_Date IS NULL OR usr.End_Date >= Trunc(SYSDATE))
 ORDER BY 1,2;
 

