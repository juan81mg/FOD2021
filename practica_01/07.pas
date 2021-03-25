{7. Realizar un programa que permita:

a. Crear un archivo binario a partir de la información almacenada en un archivo de texto.
El nombre del archivo de texto es: “novelas.txt”

b. Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar
una novela y modificar una existente. Las búsquedas se realizan por código de novela.

NOTA: La información en el archivo de texto consiste en: código de novela,
nombre,género y precio de diferentes novelas argentinas.
De cada novela se almacena la información en dos líneas en el archivo de texto.
La primera línea contendrá la siguiente información: código novela, precio, y género, 
y la segunda línea almacenará el nombre de la novela}

program p01e07;

type
    novela = record
        cod: integer;
        nombre: string[24];
        genero: string[12];
        precio: real;
        end;

    archivo = file of novela;

var
    novelas: archivo;
    op, o: Integer;

procedure guardar(var novelas: archivo);
	var
		nov: novela;
        carga: Text;
	begin
		Reset(novelas);
        assign(carga, 'novelas.txt');
        Rewrite(carga);
		while not eof(novelas)do begin
			read(novelas, nov);
		  	with nov do begin
                writeln(carga, cod, ' ', precio, ' ', genero);
                writeln(carga, nombre);
                end;
			end;
        writeln('guardado');
        close(carga);
        close(novelas);
	end;

procedure modificarNovela(var novelas: archivo);
    var
        codigo :integer;
        nov: novela;
        ok: boolean;
    begin
        reset(novelas);
        
        writeln('Ingrese el codigo de novela a modificar (0 para salir): ');
        readln(codigo);
        ok:= False;
        while not eof (novelas) and not (ok) do begin
            read(novelas, nov);
            if (codigo = nov.cod) then begin
                writeln('Codigo actual --->> ', nov.cod);
                writeln('Ingrese el nuevo codigo de la novela: ');
                readln(nov.cod);
                writeln('Precio actual --->> ', nov.precio:0:2);
                writeln('Ingrese el nuevo precio de la novela: ');
                readln(nov.precio);
                writeln('Genero actual --->> ', nov.genero);
                writeln('Ingrese el nuevo genero de la novela: ');
                readln(nov.genero);
                writeln('Nombre actual --->> ', nov.nombre);
                writeln('Ingrese el nuevo nombre de la novela: ');
                readln(nov.nombre);
                seek(novelas, FilePos(novelas)-1);
                write(novelas, nov);
                ok:= True;
                end;
            end;
        if not (ok) then
            writeln('No se encontro la novela !!!');
        close(novelas);
    end;

procedure leer(var nov:novela);
    begin
        writeln('Ingrese el codigo de la novela (0 para salir): ');
        readln(nov.cod);
        if (nov.cod <> 0)then begin
            writeln('Ingrese el precio: ');
            readln(nov.precio);
            writeln('Ingrese el genero: ');
            readln(nov.genero);
            writeln('Ingrese el nombre: ');
            readln(nov.nombre);
            end;
    end;

procedure agregarNovelaFin(var novelas:archivo);
	var
		nov:novela;
	begin
        reset(novelas);
		seek(novelas, filesize(novelas));
		leer(nov);
		while(nov.cod <> 0) do begin
			write(novelas, nov);
			leer(nov);
			end;
		close(novelas);
	end;

procedure submenu(var o: integer);
	begin
		writeln('');
		writeln(' --- Opciones de archivo --- ');
		writeln('');
		writeln('(1) Agregar una novela');
        writeln('(2) Modificar una novela');
		writeln('');
		writeln('(0) Salir');
		writeln('');
		write('Opcion --->> ');
		readln(o);
	end;

procedure crearArchivo(var novelas: archivo);
	var
		nov: novela;
        carga: Text;
	begin
		rewrite(novelas);
        assign(carga, 'novelas.txt');
        reset(carga);
        while not eof (carga)do begin
            readln(carga, nov.cod, nov.precio, nov.genero);
            readln(carga, nov.nombre);
            writeln('cod: ', nov.cod, ' precio: ', nov.precio:0:2, ' genero: ', nov.genero);
            writeln('nombre: ', nov.nombre);
            write(novelas, nov);
        end;
        close(carga);
        close(novelas);
	end;

procedure nombreArchivo(var novelas: archivo);
	var 
		nom_fis: string[12];
	begin
		writeln('Ingrese el nombre del archivo binario ');
		readln(nom_fis);
		assign(novelas, nom_fis);
	end;

procedure menu(var op: integer);
	begin
		writeln('');
		writeln(' --- Opciones de archivo --- ');
		writeln('');
		writeln('(1) Crear y modificar un archivo binario a partir de novelas.txt');
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
                nombreArchivo(novelas);
                crearArchivo(novelas);
                o:= -1;
                while (o <> 0) do begin
                    submenu(o);
                    case o of
                        0: begin
                            guardar(novelas);
                            writeln();
                            writeln('Salio del programa');
                            writeln();
                            op := 0;
                            end;
                        1: agregarNovelaFin(novelas);
                        2: modificarNovela(novelas);
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