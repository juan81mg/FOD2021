{Realizar un programa que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. 
De cada empleado se registra: número de empleado, apellido, nombre, edad y DNI.
Algunos empleados se ingresan con DNI 00. 
La carga finaliza cuando se ingresa el String ‘fin’ como apellido.

b. Abrir el archivo anteriormente generado y
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado.
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.

NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario una
única vez.}

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
	nom_fis : string[12];
	op : integer;


procedure submenu(var op : integer);
	begin
		writeln(' --- Opciones de apertura --- ');
		writeln('');
		writeln('(3) Listar empleados determinados');
		writeln('(4) Listar empleados');
		writeln('(5) Listar empleados mayores de 70 años');
		writeln('');
		writeln('(0) Salir');
		writeln('');
		writeln('Opcion --->> ');
		read(op);
	end;

procedure menu(var op : integer);
	begin
		writeln(' --- Opciones de archivo --- ');
		writeln('');
		writeln('(1) Crear un archivo de empleados');
		writeln('(2) Abrir un archivo de empleados');
		writeln('');
		writeln('(0) Salir');
		writeln('');
		writeln('Opcion --->> ');
		read(op);
		if (op=2) then
			submenu(op);
	end;
	
begin
	

	menu(op);
	
	
	
	writeln('opcion ',op,'Salio del programa');


end.