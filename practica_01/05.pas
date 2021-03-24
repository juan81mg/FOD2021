{5. Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:
a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares, deben contener: código de celular, el nombre,
descripción, marca, precio, stock mínimo y el stock disponible.
b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock mínimo.
c. Listar en pantalla los celulares del archivo cuya descripción contenga una
cadena de caracteres proporcionada por el usuario.
d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celular.txt” con todos los celulares del mismo.

NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario
una única vez.

NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
dos líneas consecutivas: en la primera se especifica: código de celular, el precio, marca
y nombre, y en la segunda el stock disponible, stock mínimo y la descripción, en ese
orden. Cada celular se carga leyendo dos líneas del archivo “carga.txt”.}

program p01e05;

type
    celular = record
        cod: integer;
        descripcion: string[24];
        marca_nombre: string[24];
        precio: integer;
        stk_min: integer;
        stk_dis: integer;
    end;

    archivo = file of celular;

var
    celulares: archivo;
    op, o: integer;


procedure exportarTXT(var celulares: archivo);
    var
        cel: celular;
        tex: Text;
    begin
        reset(celulares);
        Assign(tex, 'celulares.txt');
        Rewrite(tex);
		while not eof(celulares)do begin
			read(celulares, cel);
		  	with cel do begin
                writeln(tex, ' ', cod, ' ', precio, ' ', marca_nombre);
                writeln(tex, ' ', stk_dis, ' ', stk_min, ' ', descripcion);
                end;
			end;
        close(tex);
        close(celulares);
    end;

procedure buscarDescripcion(var celulares: archivo);
    var
        cel: celular;
        buscar: string[24];
    begin
        reset(celulares);
        writeln('Ingrese la cadena a buscar en la descripcion');
        readln(buscar);
        buscar := ' ' + buscar;
        while not eof (celulares) do begin
            read (celulares, cel);
            if (cel.descripcion = buscar) then begin
                writeln('cod: ', cel.cod, ' precio: ', cel.precio, ' marca y nombre: ', cel.marca_nombre);
                writeln('stok disponible: ', cel.stk_dis, ' stock minimo: ', cel.stk_min, ' descripcion: ', cel.descripcion);
                end;
            end;
        close(celulares);
    end;

procedure listarMinimos(var celulares: archivo);
    var
        cel: celular;
    begin
        reset(celulares);
        while not eof (celulares) do begin
            read (celulares, cel);
            if (cel.stk_dis < cel.stk_min) then begin
                writeln('cod: ', cel.cod, ' precio: ', cel.precio, ' marca y nombre: ', cel.marca_nombre);
                writeln('stok disponible: ', cel.stk_dis, ' stock minimo: ', cel.stk_min, ' descripcion: ', cel.descripcion);
                end;
            end;
        close(celulares);
    end;

procedure crearArchivo(var celulares: archivo);
	var
		cel: celular;
        carga: Text;
	begin
		rewrite(celulares);
        assign(carga, 'carga.txt');
        reset(carga);
        while not eof (carga)do begin
            readln(carga, cel.cod, cel.precio, cel.marca_nombre);
            readln(carga, cel.stk_dis, cel.stk_min, cel.descripcion);
            writeln('cod: ', cel.cod, ' precio: ', cel.precio, ' marca y nombre: ', cel.marca_nombre);
            writeln('stok disponible: ', cel.stk_dis, ' stock minimo: ', cel.stk_min, ' descripcion: ', cel.descripcion);
            write(celulares, cel);
        end;
        close(carga);
        close(celulares);
	end;

procedure nombreArchivo(var celulares: archivo);
	var 
		nom_fis: string[12];
	begin
		writeln('Ingrese el nombre del archivo binario ');
		readln(nom_fis);
		assign(celulares, nom_fis);
	end;


procedure submenu(var o: integer);
	begin
		writeln('');
		writeln(' --- Opciones de archivo --- ');
		writeln('');
		writeln('(1) Listar celulares con menor stock al minimo');
        writeln('(2) Buscar una descripcion');
        writeln('(3) Exportar a TXT');
		writeln('');
		writeln('(0) Salir');
		writeln('');
		write('Opcion --->> ');
		readln(o);
	end;

procedure menu(var op: integer);
	begin
		writeln('');
		writeln(' --- Opciones de archivo --- ');
		writeln('');
		writeln('(1) Crear un archivo binario de celulares');
		writeln('');
		writeln('(0) Salir');
		writeln('');
		write('Opcion --->> ');
		readln(op);
	end;

begin
	op:= -1;
	while (op <> 0) do begin
		menu(op);
		case op of
			0: begin
				writeln();
				writeln('Salio del programa');
				writeln();
			    end;
            1: begin
                nombreArchivo(celulares);
                crearArchivo(celulares);
                o:= -1;
                while (o <> 0) do begin
                    submenu(o);
                    case o of
                        0: begin
                            writeln();
                            writeln('Salio del programa');
                            writeln();
                            op := 0;
                            end;
                        1: listarMinimos(celulares);
                        2: buscarDescripcion(celulares);
                        3: exportarTXT(celulares);
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