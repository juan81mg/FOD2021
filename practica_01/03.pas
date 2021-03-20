{Realizar un programa que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de empleados y completarlo 
con datos ingresados desde teclado. 
De cada empleado se registra: número de empleado, apellido, nombre, edad
y DNI. Algunos empleados se ingresan con DNI 00. 
La carga finaliza cuando se ingresa el String ‘fin’ como apellido.

b. Abrir el archivo anteriormente generado y
i. Listar en pantalla los datos de empleados que tengan un nombre o 
apellido determinado.
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla empleados mayores de 70 años, próximos a 
jubilarse.

NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado
por el usuario una única vez.}

program p01e03;

type
	empleado = record
		num : integer;
		apellido : string[12];
		nombre : string [12];
		edad : integer;
		dni : integer;
		end;

	arc_emp = file of empleado;
	
var
	empleados : arc_emp;
	op : integer;


procedure mostrar(emp: empleado);
	begin
		writeln('');
		write('Numero: ', emp.num);
		write(', DNI: ', emp.dni);
		write(', Nombre: ', emp.nombre);
		write(', Apellido: ', emp.apellido);
		write(', DNI: ', emp.dni);
		write(', Edad: ', emp.edad);
		writeln('');	
	end;

procedure listar3(var empleados: arc_emp; op:integer);
	var
		emp: empleado;
		na: string[12];
	begin
		writeln('Ingrese el nombre o apellido a listar');
		readln(na);
		while not eof (empleados) do begin
			read(empleados, emp);
			if (emp.nombre=na) or (emp.apellido=na) then
				mostrar(emp);
			end;
	end;

procedure listar4(var empleados: arc_emp; op:integer);
	var
		emp: empleado;
	begin
		while not eof (empleados) do begin
			read(empleados, emp);
			mostrar(emp);
			end;
	end;
		
procedure listar5(var empleados: arc_emp; op:integer);
	var
		emp: empleado;
	begin
		while not eof (empleados) do begin
			read(empleados, emp);
			if (emp.edad > 70) then
				mostrar(emp);
			end;
	end;		
		
procedure nombreArchivo(var empleados: arc_emp);
	var 
		nom_fis: string[12];
	begin
		writeln('Ingrese el nombre del archivo ');
		readln(nom_fis);
		assign(empleados, nom_fis);
	end;

procedure submenu(var op : integer; var empleados:arc_emp);
	begin
		reset(empleados);
		writeln('');
		writeln(' --- Opciones de apertura --- ');
		writeln('');
		writeln('(3) Listar empleados determinados');
		writeln('(4) Listar empleados');
		writeln('(5) Listar empleados mayores de 70 años');
		writeln('');
		writeln('(0) Salir');
		writeln('');
		write('Opcion --->> ');
		readln(op);
	end;

procedure menu(var op: integer; var empleados: arc_emp);
	begin
		writeln('');
		writeln(' --- Opciones de archivo --- ');
		writeln('');
		writeln('(1) Crear un archivo de empleados');
		writeln('(2) Abrir un archivo de empleados');
		writeln('');
		writeln('(0) Salir');
		writeln('');
		write('Opcion --->> ');
		readln(op);
		if (op = 1) or (op = 2)then
			nombreArchivo(empleados);
	end;



procedure crearArchivo(var empleados: arc_emp);
	var
		emp: empleado;
	begin
		rewrite(empleados);
		
		writeln('Ingrese el APELLIDO del empleado (fin sale)');
		readln(emp.apellido);
		
		while(emp.apellido <> 'fin') do begin

			writeln('Ingrese el NOMBRE del empleado ');
			readln(emp.nombre);
			writeln('Ingrese la EDAD del empleado ');
			readln(emp.edad);
			writeln('Ingrese el DNI del empleado ');
			readln(emp.dni);
			writeln('Ingrese el NUMERO del empleado ');
			readln(emp.num);
			
			write(empleados, emp);
			writeln('');
			writeln(':o:o:o:');
			writeln('');
			writeln('Ingrese el APELLIDO del empleado (fin sale)');
			readln(emp.apellido);
			end;
	end;

begin
	op:= -1;
	while (op <> 0) do begin
		menu(op, empleados);
		case op of
			0: begin
				writeln();
				writeln('Salio del programa');
				writeln();
				end;
			1: begin
				crearArchivo(empleados);
				end;
			2: begin
				while op <> 0 do begin
					submenu(op, empleados);
					case op of
						0: begin
							writeln();
							writeln('Salio del programa');
							writeln();
							end;			
						3: begin
							listar3(empleados, op)
							end;
						4: begin
							listar4(empleados, op)
							end;
						5: begin
							listar5(empleados, op)
							end
						else begin
							writeln();
							writeln('Ingrese una opcion correcta !!!');
							writeln();
							end;
						end;
					end;
				end
			else begin
				writeln();
				writeln('Ingrese una opcion correcta !!!');
				writeln();
				end;
			end;
		end;
	
	close(empleados);
end.
