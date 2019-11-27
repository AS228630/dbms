SET SERVEROUTPUT ON SIZE UNLIMITED;

CREATE OR REPLACE PROCEDURE print_keys
AS
CURSOR mCur IS
	SELECT   
		a.constraint_name AS t0, 
		a.constraint_type AS t1,
		b.column_name AS t2,
		a.table_name AS t3, 
		(SELECT table_name 
		 FROM all_constraints 
		 WHERE constraint_name = a.r_constraint_name) AS t4,
		(SELECT column_name 
		 FROM all_tab_columns 
		 WHERE table_name = 
			(SELECT table_name
			 FROM all_constraints 
			 WHERE constraint_name = a.r_constraint_name 
			 AND ROWNUM = 1) 
			 AND ROWNUM = 1) AS t5 
	FROM all_constraints a, all_tab_columns b
	WHERE 
	a.owner = 'ISU_UCHEB' 
	AND (a.constraint_type = 'P' OR a.constraint_type = 'R')
	AND a.table_name = b.table_name;
BEGIN
dbms_output.enable();

dbms_output.put_line (CHR(13) || CHR(10));
dbms_output.put_line('--------------------------------------------------------------------------------');
dbms_output.put_line(RPAD('Имя ограничения', 16) || RPAD('Тип', 4) || RPAD('Имя столбца', 16) || RPAD('Имя таблицы', 16) || RPAD('Имя таблицы', 16) || RPAD('Имя столбца', 16));  
dbms_output.put_line('--------------------------------------------------------------------------------');

FOR ROW IN mCur LOOP
	dbms_output.put_line(RPAD(ROW.t0, 16) || RPAD(ROW.t1, 4) || RPAD(ROW.t2, 16) || RPAD(ROW.t3, 16) || RPAD(ROW.t4, 16) || RPAD(ROW.t5, 16));
END LOOP;

END print_keys;
/
EXEC print_keys;
