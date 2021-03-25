{Agregar al menú del programa del ejercicio 3, opciones para:
a. Añadir una o más empleados al final del archivo con sus datos 
ingresados por teclado.
b. Modificar edad a una o más empleados.
c. Exportar el contenido del archivo a un archivo de texto llamado
“todos_empleados.txt”.
d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”,
los empleados que no tengan cargado el DNI (DNI en 00).}

program p01e04;

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

procedure leer(var emp:empleado);
	begin
		writeln('Ingrese el APELLIDO del empleado (fin sale)');
		readln(emp.apellido);
		if (emp.apellido <> 'fin')then begin
			writeln('Ingrese el NOMBRE del empleado ');
			readln(emp.nombre);
			writeln('Ingrese la EDAD del empleado ');
			readln(emp.edad);
			writeln('Ingrese el DNI del empleado ');
			readln(emp.dni);
			writeln('Ingrese el NUMERO del empleado ');
			readln(emp.num);
			end;
	end;

procedure exportarDNI00(var empleados: arc_emp);
	var
		tex: Text;
		e: empleado;
	begin
		assign(tex, 'faltaDNIEmpleado.txt');
		rewrite(tex);

		while not eof(empleados)do begin
			read(empleados, e);
		  	with e do
			  	if(dni = 00)then
					writeln(tex, ' ',num, ' ', apellido, ' ', nombre, ' ', edad, ' ', dni);
		end;

		close(tex);
		close(empleados);
	end;

procedure exportarLista(var empleados: arc_emp);
	var
		tex: Text;
		e: empleado;
	begin
		assign(tex, 'todos_empleados.txt');
		rewrite(tex);

		while not eof(empleados)do begin
			read(empleados, e);
		  	with e do
				writeln(tex, ' ',num, ' ', apellido, ' ', nombre, ' ', edad, ' ', dni);
			end;

		close(tex);
		close(empleados);
	end;

procedure modificarEdad(var empleados:arc_emp);
	var
		aux: integer;
		emp: empleado;
		ok: boolean;
	begin
		writeln('Ingrese un numero de empleado --->> ');
		read(aux);
		ok:= false;
		while not eof (empleados) and not (ok) do begin
			read(empleados, emp);
			if (emp.num = aux) and not(ok) then begin

				writeln('Ingrese la edad para modificar');
				read(emp.edad);
				
				seek(empleados, filepos(empleados)-1);
				write(empleados, emp);
				
				ok:=true;
				end;
			end;
		close(empleados);
	end;
	
procedure agregarEmpleado(var empleados:arc_emp);
	var
		emp:empleado;
	begin
		seek(empleados, filesize(empleados));
		leer(emp);
		while(emp.apellido <> 'fin') do begin
			write(empleados, emp);
			leer(emp);
			end;
		close(empleados);
	end;

procedure mostrar(emp: empleado);
	begin
		writeln('');
		write('Numero: ', emp.num);
		write(', DNI: ', emp.dni);
		write(', Nombre: ', emp.nombre);
		write(', Apellido: ', emp.apellido);
		write(', DNI: ', emp.dni);
		write(', Edad: ', emp.edad);
	end;

procedure listar3(var empleados: arc_emp);
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

procedure listar4(var empleados: arc_emp);
	var
		emp: empleado;
	begin
		while not eof (empleados) do begin
			read(empleados, emp);
			mostrar(emp);
			end;
	end;
		
procedure listar5(var empleados: arc_emp);
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
		writeln('(6) Añadir un empleado al final');
		writeln('(7) Modificar una edad');
		writeln('(8) Exportar lista');
		writeln('(9) Exportar lista DNI 00');
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
		leer(emp);
		while(emp.apellido <> 'fin') do begin
			leer(emp);
			write(empleados, emp);
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
						3: listar3(empleados);
						4: listar4(empleados);
						5: listar5(empleados);
						6: agregarEmpleado(empleados);
						7: modificarEdad(empleados);
						8: exportarLista(empleados);
						9: exportarDNI00(empleados);
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
end.
