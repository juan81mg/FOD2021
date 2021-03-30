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