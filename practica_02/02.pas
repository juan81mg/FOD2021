{Se dispone de un archivo con información de los alumnos de la Facultad de Informática.
Por cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado.

Además, se tiene un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).

Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. 
Se pide realizar un programa con opciones para:

a. Crear el archivo maestro a partir de un archivo de texto llamado “alumnos.txt”.
b. Crear el archivo detalle a partir de en un archivo de texto llamado “detalle.txt”.

c. Listar el contenido del archivo maestro en un archivo de texto llamado “reporteAlumnos.txt”.
d. Listar el contenido del archivo detalle en un archivo de texto llamado “reporteDetalle.txt”.

e. Actualizar el archivo maestro de la siguiente manera:
i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado.
ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
final.

f. Listar en un archivo de texto los alumnos que tengan más de cuatro materias
con cursada aprobada pero no aprobaron el final. Deben listarse todos los campos.
(aprobo cuatro cursadas y ningun final).

NOTA: Para la actualización del inciso e) los archivos deben ser recorridos sólo una vez.}

program p02e02;
uses 
    crt;
const
    valor_alto= 99999;
    filename_maestro_bin= '02_maestro.dat';
    filename_detalle_bin= '02_detalle.dat';
    filename_maestro_txt= 'alumnos.txt';
    filename_detalle_txt= 'detalle.txt';
    filename_reporte_maestro_txt= 'reporteAlumnos.txt';
    filename_reporte_detalle_txt= 'reporteDetalle.txt';
    filename_reporte_4_cursadas_txt= 'reporte4Cursadas.txt';

type
    str20 = String[20];

    alumno = record
        cod: integer;
        apellido: str20;
        nombre: str20;
        cant_cur: Integer;
        cant_fin: Integer;
        end;

    materia = record
        cod: integer;
        final: integer; 
        // no se puede leer o escribir variables boolean o char desde txt
        // o desaprobado, 1 aprobado
        end;

    maestro = file of alumno;
    detalle = file of materia;

// (6)
procedure leer_maestro_bin(var a_mae: maestro; var r_mae: alumno);
    begin
        if not eof(a_mae) then
            read(a_mae, r_mae)
        else
            r_mae.cod := valor_alto;
    end;

procedure listar4Cursadas(var a_mae: maestro);
    var
        a_text: Text;
        r_mae: alumno;
    begin
        Assign(a_text, filename_reporte_4_cursadas_txt);
        Rewrite(a_text);
        reset(a_mae);

        leer_maestro_bin(a_mae, r_mae);

        while (r_mae.cod < valor_alto) do begin
            if (r_mae.cant_cur > 4) and (r_mae.cant_fin = 0)then
                with r_mae do begin
                    Write(a_text, cod, cant_cur, cant_fin);
                    Write(a_text, apellido, nombre);
                    writeln(' <------> ');
                    WriteLn(cod, cant_cur, cant_fin);
                    WriteLn(apellido, nombre);
                    writeln();
                    end;

            leer_maestro_bin(a_mae, r_mae);
            end;
        close(a_text);
        close(a_mae);
    end;

// (5)
procedure leer_detalle_bin (var a_det: detalle; var r_det: materia);
    begin
        if not eof (a_det) then
            with r_det do
                read(a_det, r_det)
        else
            // sino igualo a valor alto
            r_det.cod := valor_alto;
    end;

procedure actualizarMaestro(var a_mae: maestro; var a_det: detalle);
    var
        r_mae: alumno;
        r_det: materia;
        cod_actual: Integer;
        cant_cursadas: integer;
        cant_finales: Integer;
    begin
        reset(a_mae);
        reset(a_det);

        leer_detalle_bin(a_det, r_det);
        
        read(a_mae, r_mae);

        while (r_det.cod < valor_alto) do begin
            cod_actual:= r_det.cod;

            cant_cursadas:= 0;
            cant_finales:= 0;

            while (cod_actual = r_det.cod) do begin
                //busca todos los consecutivos iguales en el detalle para sumar
                if(r_det.final = 0)then
                    cant_cursadas:= cant_cursadas + 1
                else cant_finales:= cant_finales + 1;
                leer_detalle_bin(a_det, r_det);
                end;

            // busca en el maestro    
            while (cod_actual <> r_det.cod) do
                // se supone que el registro del archivo de detalle existe
                read(a_mae, r_mae);

            // aactualiza el registro
            r_mae.cant_cur:= r_mae.cant_cur + cant_cursadas;
            r_mae.cant_fin:= r_mae.cant_fin + cant_finales;
            //actualiza el archivo maestro
            seek(a_mae, FilePos(a_mae)-1);
            write(a_mae, r_mae);

            if not eof (a_mae)then
                read(a_mae, r_mae);
            // no se controla el eof maestro en el while porque sale si termina el detalle    
            end;

        close(a_mae);
        close(a_det);
    end;


// (4)
procedure listarDetalle(var a_det: detalle);
    var
        n: materia;
        a_text: Text;
    begin
        reset(a_det);

        assign(a_text, filename_reporte_detalle_txt);
        rewrite(a_text);

        while not eof (a_det) do begin
            read(a_det, n);
            with n do begin
                Write(a_text, cod, final);
                writeln(' <------> ');
                WriteLn(cod, final);
                writeln();
                end;
            end;
        Close(a_det);
        close(a_text);
    end;

// (3)
procedure listarMaestro(var a_mae: maestro);
    var
        a: alumno;
        a_text: Text;
    begin
        reset(a_mae);

        assign(a_text, filename_reporte_maestro_txt);
        rewrite(a_text);

        while not eof (a_mae) do begin
            read(a_mae, a);
            with a do begin
                Write(a_text, cod, cant_cur, cant_fin);
                Write(a_text, apellido, nombre);
                writeln(' <------> ');
                WriteLn(cod, cant_cur, cant_fin);
                WriteLn(apellido, nombre);
                writeln();
                end;
            end;
        Close(a_mae);
        close(a_text);
    end;

// (2)
procedure leer_detalle_txt (var a_txt: Text; var nota: materia);
    begin
        if not eof (a_txt) then
            with nota do
                // este es el formato que debe respetar el archivo de texto detalle.txt
                readln(a_txt, cod, final)
        else
            // sino igualo a valor alto
            nota.cod := valor_alto;
    end;

procedure crearDetalle(var a_det: detalle);
    var
        a_txt: Text;
        nota: materia;

    begin
        // abro el detalle.txt
        assign(a_txt, filename_detalle_txt);
        reset(a_txt);
        // creo el binario de detalle
        rewrite(a_det);

        leer_detalle_txt(a_txt, nota);

        while (nota.cod < valor_alto) do begin
            //se supone que haya repetidos, no se controla
            write(a_det, nota);
            leer_detalle_txt(a_txt, nota);
            end;

        close(a_txt);
        close(a_det);
    end;

// (1)
procedure leer_maestro_txt (var a_txt: Text; var alu: alumno);
    begin
        if not eof (a_txt) then
            with alu do begin
                //este es el formato que debe respetar el archivo de texto alumnos.txt
                readln(a_txt, cod, cant_cur, cant_fin);
                readln(a_txt, apellido, nombre);
                end
        else
            // sino valor alto
            alu.cod := valor_alto;
    end;

procedure crearMaestro(var a_mae: maestro);
    var
        a_txt: Text;
        alu: alumno;

    begin
        // abro el alumnos.txt
        assign(a_txt, filename_maestro_txt);
        reset(a_txt);
        // creo el maestro
        rewrite(a_mae);

        leer_maestro_txt(a_txt, alu);

        while (alu.cod < valor_alto) do begin
            //se supone que no hay repetidos, no se controla que haya repetidos
            write(a_mae, alu);
            leer_maestro_txt(a_txt, alu);
            end;

        close(a_txt);
        close(a_mae);
    end;

procedure menu();
	begin
		writeln('');
		writeln(' --- Opciones de archivo --- ');
		writeln('');
		writeln('(1) Crear el archivo maestro a partir de un archivo de texto llamado "alumnos.txt"');
		writeln('(2) Crear el archivo detalle a partir de en un archivo de texto llamado "detalle.txt"');
        writeln('(3) Listar el contenido del archivo maestro en un archivo de texto llamado "reporteAlumnos.txt"');
        writeln('(4) Listar el contenido del archivo detalle en un archivo de texto llamado "reporteDetalle.txt"');
        writeln('(5) Actualizar el archivo maestro');
        writeln('(6) Listar alumnos que tengan mas de cuatro materias con cursada aprobada sin final');
		writeln('');
		writeln('(0) Salir');
		writeln('');
		writeln('Opcion --->> ');
	end;


var
    op: Byte;
    a_mae: maestro;
    a_det: detalle;
begin

    assign(a_mae, filename_maestro_bin);
    assign(a_det, filename_detalle_bin);

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
            1: crearMaestro(a_mae);
            2: crearDetalle(a_det);
            3: listarMaestro(a_mae);
            4: listarDetalle(a_det);
            5: actualizarMaestro(a_mae, a_det);
            6: listar4Cursadas(a_mae);
            else begin
                writeln();
                writeln('Ingrese una opcion correcta !!!');
                writeln();
                readkey();
                end;
            end;
        end;
end.