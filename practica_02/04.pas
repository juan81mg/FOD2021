{Suponga que trabaja en una oficina donde está montada una LAN (red local). 
La misma fue construida sobre una topología de red que conecta 5 máquinas entre sí y 
todas las máquinas se conectan con un servidor central.

Semanalmente cada máquina genera un archivo de logs informando las sesiones abiertas 
por cada usuario en cada terminal y por cuánto tiempo estuvo abierta.
Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion.

Debe realizar un procedimiento que reciba los archivos detalle y 
genere un archivo maestro con los siguientes datos: 
cod_usuario, fecha, tiempo_total_de_sesiones_abiertas.

Notas:
- Cada archivo detalle está ordenado por cod_usuario y fecha.
- Un usuario puede iniciar más de una sesión el mismo dia en la misma o en diferentes
máquinas.
- El archivo maestro debe crearse en la siguiente ubicación física: /var/log.}

program p02e04;

const
    dim = 5;
    valor_alto = '9999';

type
    str4 = String[4];
    str20 = String[20];
    log_mae = record
        cod_usuario: str4;
        fecha: LongInt;
        tiempo_sesion: Real;
        end;
    log_det = record
        cod_usuario: str4;
        fecha: LongInt;
        tiempo_total_de_sesiones_abiertas: Real;
        end;

    archivo_maestro = file of log_mae;

    detalle = file of log_det; //archivo con los logs
    archivo_detalle = array[0..dim] of detalle; //los archivos de cada maquina
    reg_detalle = array[0..dim] of log_det; //guardo actual de cada maquina

procedure leer(var a_detalle: detalle; var log_detalles: log_det);
    begin
        if not eof(a_detalle) then
		    read(a_detalle, log_detalles)
	    else	
		    log_detalles.cod_usuario := valor_alto;   
    end;

procedure minimo(var vec_reg: reg_detalle; var detalles: archivo_detalle; var min: log_det);
    var
        j: integer;
        pos: integer;
    begin
        //para controlar el orden de codigo y fecha
        min.cod_usuario:= valor_alto; 
        min.fecha:= 9999;

        for j:= 1 to dim do begin
            if (vec_reg[j].cod_usuario < min.cod_usuario) or ((vec_reg[j].cod_usuario = min.cod_usuario) and (vec_reg[j].fecha < min.fecha)) then begin
                pos:= j;
                min:= vec_reg[j];
                //guardo la posicion y actualizo min para comparar
                end;
            end;
        
        leer(detalles[pos], vec_reg[pos]);
        //leo el siguiente cuando vuelvo a buscar el minimo

    end;

procedure crear_maestro(var maestro: archivo_maestro; var detalles: archivo_detalle);
    var
        i, h: integer;
        vec_reg: reg_detalle;
        name: string;
        min: log_det;
        registro_maestro: log_mae;
    begin
        assign(maestro, '04_maestro.dat');
        rewrite(maestro);

        for i := 1 to dim do begin
            Str(i, name);
            assign(detalles[i], '04_detalle_' + name);
            reset(detalles[i]);
            leer(detalles[i], vec_reg[i]);
            end;
            //guardo el primer elemento de cada archivo

            minimo(vec_reg, detalles, min);
            //saco el minimo de todo el vector de elementos
            //writeln('.:.:. minimo .:.:.', min.cod_usuario);

            while (min.cod_usuario <> valor_alto)do begin
                //armo el registro maestro para el archivo
                registro_maestro.cod_usuario:= min.cod_usuario;
                registro_maestro.fecha:= min.fecha;
                registro_maestro.tiempo_sesion:= 0;
                while (registro_maestro.cod_usuario = min.cod_usuario) and (registro_maestro.fecha = min.fecha)do begin
                    registro_maestro.tiempo_sesion:= registro_maestro.tiempo_sesion + min.tiempo_total_de_sesiones_abiertas;
                    minimo(vec_reg, detalles, min);
                    end;
                write(maestro, registro_maestro);
                //writeln('maestro -->>> codigo: ', registro_maestro.cod_usuario, ' fecha: ', registro_maestro.fecha, ' tiempo: ', registro_maestro.tiempo_sesion:0:2 );
                end;
        for h:= 1 to dim do
            close(detalles[h]);
        close(maestro);
	end;

procedure crear_detalles(var detalles: archivo_detalle);
    var
        i: integer;
        nombre: str4;
        log: log_det;
        ok: char;
    begin
        writeln('.:.:. creando archivos detalle .:.:.');
        for i:=1 to dim do begin
            Str(i, nombre);
            assign(detalles[i], '04_detalle_' + nombre);
            rewrite(detalles[i]);
            writeln('Archivo DETALLE numero ', i);
            ok:= 'y';
            //suponiendo que en cada maquina hay al menos una sesion guardada
            while (ok = 'y')do begin
                with log do begin
                    write('Codigo usuario --->> ');
                    ReadLn(cod_usuario);	
                    write('Fecha --->> ');
                    readln(fecha);
                    write('Tiempo de la sesion --->> ');
                    readln(tiempo_total_de_sesiones_abiertas);                
                    end;
                writeln('desea agregar una sesion mas ???...(y/n)');
                readln(ok);
                write(detalles[i], log);
                end;
            close(detalles[i]);
            end;
    end;

var
    maestro: archivo_maestro;
    detalles: archivo_detalle;

begin
    //crear_detalles(detalles);
    crear_maestro(maestro, detalles);
end.