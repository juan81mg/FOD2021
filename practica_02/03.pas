{Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.

Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro.

La información que se recibe en los detalles es: código de producto y cantidad
vendida. 

Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo.

Nota: todos los archivos se encuentran ordenados por código de productos.
En cada detalle puede venir 0 o N registros de un determinado producto}

program p02e03;

uses
    sysutils;

const
    valor_alto = '9999';
    dim = 30;

type
    str20 = string[20];

    alimento = record
        cod: String[4];
        nombre: str20;
        descripcion: String[40];
        stk_dis: integer;
        stk_min: integer;
        precio: real;
        end;

    stock = record
        cod: String[4];
        cant: integer;
        end;

    archivo_maestro = file of alimento;
    archivo_detalle = file of stock;

    //declaro un vector con archivos de detalle
    vector_detalle = array [1..dim] of archivo_detalle;
    //uso un vector para guardar los elementos de cada archivo de detalle a la ves
    vector_registro_detalle = array [1..dim] of stock;

var
    maestro: archivo_maestro;
    registro_maestro: alimento;

    vector: vector_detalle; //vector de archivos de detalles
    registro_detalle: stock; //registro detalle

    vector_registros: vector_registro_detalle; //vector con registros de cada archivo de detalle

    i: integer;
    actual: String[4];
    total: integer;

procedure leer (var archivo: archivo_detalle; var dato: stock);
    begin
        if not eof(archivo) then 
            read (archivo, dato)
        else 
            dato.cod := valor_alto;
    end;

procedure minimo(var vector: vector_detalle; var vector_registros: vector_registro_detalle; 
                    var registro_detalle: stock);
    var
        i: integer;
        cod_min: string[4];
        pos: Integer;
    begin
        cod_min:= '999';

        for i:=1 to dim do begin
            if (vector_registros[i].cod < cod_min)then begin
                cod_min:= vector_registros[i].cod;
                registro_detalle:= vector_registros[i];
                pos:= i;
                end;
            leer(vector[pos], vector_registros[pos]);
            end;
    end;

begin
    assign(maestro, '03_maestro.dat');
    Reset(maestro);

    for i := 1 to dim do begin
        assign (vector[i], '03_detalle' + IntToStr(i)); //IntoToStr, convierte de integer a string
        reset(vector[i]);
        //guardo el actual registro de cada archivo detalle
        leer(vector[i], vector_registros[i]);
        end; 


    minimo(vector, vector_registros, registro_detalle);

    while(registro_detalle.cod <> valor_alto)do begin
        read(maestro, registro_maestro);
        actual:= registro_detalle.cod;

        while(registro_detalle.cod <> registro_maestro.cod) do begin
            read(maestro, registro_maestro);
            end;
        
        while(registro_detalle.cod = actual) and (registro_detalle.cod <> valor_alto)do begin
            total:= registro_detalle.cant;
            actual:= registro_detalle.cod;
            minimo(vector, vector_registros, registro_detalle);          
            end;

        registro_maestro.stk_dis := total;
        seek(maestro, FilePos(maestro)-1);
        write(maestro, registro_maestro);
        end;
end.