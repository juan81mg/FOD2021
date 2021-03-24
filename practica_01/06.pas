{6. Agregar al menú del programa del ejercicio 5, opciones para:
a. Añadir uno o más celulares al final del archivo con sus datos ingresados por
teclado.
b. Modificar el stock de un celular dado.
c. Exportar el contenido del archivo binario a un archivo de texto denominado:
”SinStock.txt”, con aquellos celulares que tengan stock 0.
NOTA: Las búsquedas deben realizarse por nombre de celular}

program p01e06;

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

procedure leer(var cel:celular);
    begin
        writeln('Ingrese la marca y nombre del celular (fin para salir): ');
        readln(cel.marca_nombre);
        if (cel.marca_nombre <> 'fin')then begin
            writeln('Ingrese el codigo: ');
            readln(cel.cod);
            writeln('Ingrese el precio: ');
            readln(cel.precio);
            writeln('Ingrese el stock minimo: ');
            readln(cel.stk_min);
            writeln('Ingrese el stock disponible: ');
            readln(cel.stk_dis);
            writeln('Ingrese una descripcion: ');
            readln(cel.descripcion);
            end;
    end;

procedure agregarCelular(var celulares: archivo);
    var
        cel: celular;
	begin
		seek(celulares, filesize(celulares));
		leer(cel);
		while(cel.marca_nombre <> 'fin') do begin
			write(celulares, cel);
			leer(cel);
			end;
	close(celulares);
	end;

procedure exportarTXT(var celulares: archivo);
    var
        cel: celular;
        tex: Text;
    begin
        reset(celulares);
        Assign(tex, 'celular.txt');
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
        writeln('(4) Agragar celular al final');       
        writeln('(5) ');
        writeln('(6) ');
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
                        4: agregarCelular(celulares);
                        5:begin
                          
                        end;
                        6:begin
                          
                        end;
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