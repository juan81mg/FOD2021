uses
	crt;

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

procedure menu(var op: integer);
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

	end;
	
var
    op: Byte;
begin
    op:= -1;
    while (op <> 0) do begin
        menu();
        read(op);
        case op of
            0: begin
                writeln();
                writeln('Salio del programa');
                readkey();
                end;
            1: //crearMaestro();
            else begin
                writeln();
                writeln('Ingrese una opcion correcta !!!');
                writeln();
                readkey();
                end;
            end;
        end;

end.
