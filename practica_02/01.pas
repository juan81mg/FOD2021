{Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. 
La información del archivo se encuentra ordenada por código de empleado y 
cada empleado puede aparecer más de una vez en el archivo de comisiones.

Realice un procedimiento que reciba el archivo anteriormente descripto y lo compacte.
En consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.

NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez.}

program p02e01;
uses
    crt;
const
    valor_alto = 99999;
type
    empleado = record
        cod: integer;
        nombre: string[14];
        monto: real;
        end;
    archivo = file of empleado;

var
    com_det: archivo;
    com_mae: archivo;
    op: integer;

procedure nombreArchivo(var comisiones: archivo);
	var 
		nom_fis: string[12];
	begin
		writeln('Ingrese el nombre del archivo binario ');
		readln(nom_fis);
		assign(comisiones, nom_fis);
	end;

procedure mostrarMaestro(var arc: archivo);
    var
        emp: empleado;
    begin
        nombreArchivo(arc);
        Reset(arc);
        while not eof(arc) do begin
            read(arc,emp);
            writeln('Codigo: ', emp.cod, '. Nombre: ', emp.nombre, ' Comision: ', emp.monto:0:2);
            end;
        close(arc);
    end;

procedure leer(var arc: archivo; var dato: empleado);
    begin
        if (not eof(arc)) then
            read(arc, dato)
        else
            dato.cod := valor_alto;
    end;

procedure compactar(var com_det: archivo; var com_mae: archivo);
    var
        reg_det, reg_mae: empleado;
    begin
        nombreArchivo(com_det);
        Reset(com_det);
        nombreArchivo(com_mae);
        Rewrite(com_mae);
        leer(com_det, reg_det);

        while (reg_det.cod < valor_alto) do begin
            //cargo el codigo y nombre en el reg maestro
            reg_mae.cod:= reg_det.cod;
            reg_mae.nombre:= reg_det.nombre;
            //y seteo la comision en 0
            reg_mae.monto:= 0;

            while (reg_mae.cod = reg_det.cod) do begin
                //sumo las comisiones si el mismo empleado
                reg_mae.monto:= reg_mae.monto + reg_det.monto;
                leer(com_det, reg_det);
                //va sumando las comision de los registros siguiente iguales
                end;       
            //si es valor_alto, almacena el valor en reg_d para que el while principal deje de iterar.
            write(com_mae, reg_mae);
            end;
        close(com_mae);
        close(com_det);
    end;

procedure cargar(var com: empleado);
    begin
        writeln('Ingrese el codigo del empleado (0 para salir): ');
        readln(com.cod);
        if (com.cod <> 0)then begin
            writeln('Ingrese el nombre: ');
            readln(com.nombre);
            writeln('Ingrese el monto: ');
            readln(com.monto);
            end;
    end;

procedure crearDetalle(var com_det:archivo);
    var
        comision: empleado;
    begin
        nombreArchivo(com_det);
        Rewrite(com_det);
        cargar(comision);
        while (comision.cod <> 0) do begin
            write(com_det, comision);
            cargar(comision);
            end;
        reset(com_det);
    end;

procedure menu();
    begin
        writeln('');
		writeln(' --- Opciones de archivo --- ');
		writeln('');
		writeln('(1) Crear un archivo Detalle');
		writeln('(2) Compactar el archivo Detalle');
   		writeln('(3) Mostrar el archivo Maestro');
		writeln('');
		writeln('(0) Salir');
		writeln('');
		write('Opcion --->> ');
    end;

begin
    op:= -1;
    while (op <> 0) do begin
        menu();
        readln(op);
        case op of 
            0: begin
                writeln('');
                writeln('Salio del programa');
                readkey;
                end;
            1: crearDetalle(com_det);
            2: compactar(com_det, com_mae);
            3: mostrarMaestro(com_mae);
            else begin
                writeln();
                writeln('Ingrese una opcion correcta !!!');
                writeln();
                end;
            end;
        end;
end.