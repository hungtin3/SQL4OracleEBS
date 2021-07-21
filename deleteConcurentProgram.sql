DECLARE
  l_Prog_Short_Name VARCHAR2(240);
  l_Exec_Short_Name VARCHAR2(240);
  l_Appl_Full_Name  VARCHAR2(240);
  l_Appl_Exec_Name VARCHAR2(240);
  l_Del_Prog_Flag   VARCHAR2(1) := 'Y'; --Set flag whether to delete Concurrent program or not
  l_Del_Exec_Flag   VARCHAR2(1) := 'Y'; --Set flag whether to delete executable or not
  
  CURSOR Cs_Program IS
    SELECT Fcpt.User_Concurrent_Program_Name,
           Fcp.Concurrent_Program_Name       Short_Name,
           Fat.Application_Name              Program_Application_Name,
           a.Application_Short_Name,
           Fet.Executable_Name,
           Fat1.Application_Name             Executable_Application_Name,
           Flv.Meaning                       Execution_Method,
           Fet.Execution_File_Name,
           Fcp.Enable_Trace
      FROM Fnd_Concurrent_Programs_Tl Fcpt,
           Fnd_Concurrent_Programs    Fcp,
           Fnd_Application_Tl         Fat,
           Fnd_Executables            Fet,
           Fnd_Application_Tl         Fat1,
           Fnd_Application            a,
           Fnd_Lookup_Values          Flv
     WHERE 1 = 1
       --AND Fcpt.User_Concurrent_Program_Name = 'Deleted'
		AND Fcp.Concurrent_Program_Name  ='MOKY'
       --AND Fat.Application_Name = 'Payables'
       AND Fat.Application_Id = a.Application_Id
       AND Fcpt.Concurrent_Program_Id = Fcp.Concurrent_Program_Id
       AND Fcpt.Application_Id = Fcp.Application_Id
       AND Fcp.Application_Id = Fat.Application_Id
       AND Fcpt.Application_Id = Fat.Application_Id
       AND Fcp.Executable_Id = Fet.Executable_Id
       AND Fcp.Executable_Application_Id = Fet.Application_Id
       AND Fet.Application_Id = Fat1.Application_Id
       AND Flv.Lookup_Code = Fet.Execution_Method_Code
       AND Flv.Lookup_Type = 'CP_EXECUTION_METHOD_CODE';
BEGIN
  --
  -- set concurrent program and executable short name
  --
  FOR Rc IN Cs_Program
  LOOP
    l_Prog_Short_Name := Rc.Short_Name; -- Concurrent program short name
    l_Exec_Short_Name := Rc.Executable_Name; -- Executable short name
    
    l_Appl_Full_Name  := Rc.Program_Application_Name; -- Application full name
    l_Appl_Exec_Name := Rc.Executable_Application_Name; -- Application Short name 
    
    -- Check if the program exists. if found, delete the program
    IF Fnd_Program.Program_Exists(l_Prog_Short_Name, l_Appl_Full_Name) AND
       Fnd_Program.Executable_Exists(l_Exec_Short_Name, l_Appl_Exec_Name)
    THEN
      IF l_Del_Prog_Flag = 'Y'
      THEN
        --API call to delete Concurrent Program
        Fnd_Program.Delete_Program(l_Prog_Short_Name, l_Appl_Full_Name);
      END IF;
      IF l_Del_Exec_Flag = 'Y'
      THEN
        --API call to delete Executable
        Fnd_Program.Delete_Executable(l_Exec_Short_Name, l_Appl_Exec_Name);
      END IF;
      COMMIT;
      Dbms_Output.Put_Line('Concurrent Program ' || l_Prog_Short_Name ||
                           ' deleted successfully');
      Dbms_Output.Put_Line('Executable ' || l_Exec_Short_Name ||
                           ' deleted successfully');
    ELSE
      -- if the program does not exist in the system
      Dbms_Output.Put_Line(l_Prog_Short_Name || ' or ' ||
                           l_Exec_Short_Name || ' not found');
    END IF;
  END LOOP;
  commit;
EXCEPTION
  WHEN OTHERS THEN
    Dbms_Output.Put_Line('Error while deleting: ' || SQLERRM);
END;
/