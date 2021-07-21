DECLARE
  CURSOR Cur1 IS
    SELECT u.User_Id,
       u.User_Name,
       u.Creation_Date,
       u.Start_Date,
       u.End_Date,
       u.Last_Logon_Date
  FROM Fnd_User u
 WHERE 1 = 1
   AND u.Creation_Date >= '01-JAN-2010'
and u.User_Name='VHTT.EVNIT'
 ORDER BY u.Creation_Date DESC
;
BEGIN
  FOR All_User IN Cur1
  LOOP
      apps.fnd_user_pkg.EnableUser(all_user.user_name);--Enable User khi da Disable User
      --Apps.Fnd_User_Pkg.Disableuser(All_User.User_Name); --Disable User
    COMMIT;
  END LOOP;
END;
/

SELECT
    FUSER.USER_NAME
    , PER.FULL_NAME
    , PER.EMPLOYEE_NUMBER
FROM
    APPLSYS.FND_USER FUSER
    , APPS.PER_PEOPLE_F PER
WHERE
    FUSER.EMPLOYEE_ID = PER.PERSON_ID(+)
    AND FUSER.ENCRYPTED_USER_PASSWORD = 'INVALID'
ORDER BY
    FUSER.USER_NAME;