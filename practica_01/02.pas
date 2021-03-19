{Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creados en el ejercicio 1, 
informe por pantalla cantidad de números menores a 1500 y
el promedio de los números ingresados. 
El nombre del archivo a procesar debe ser proporcionado por el usuario una única vez.
Además, el algoritmo deberá listar el contenido del archivo en pantalla.}

program p01e02;

type
	arc_num = file of integer;
	
var
	numeros : arc_num;
	nom_fis : string[12];
	num, min_1500, suma, cant : integer;
	prom : real;

begin
	
	writeln('Ingrese el nombre del archivo fisico (ya creado)');
	read(nom_fis);
	
	assign(numeros, nom_fis);
	reset(numeros);

	min_1500 := 0;
	suma := 0;
	cant := 0;

	while not eof (numeros) do begin
		
		read(numeros, num);
		
		writeln('numero : ', num);
		
		if (num < 1500) then
			min_1500:= min_1500 + 1;
		
		suma := suma + num;
		cant := cant + 1;

		end;

	writeln('Cantidad de numeros menores a 1500 --->> ', min_1500);

	prom := suma/cant; 
	writeln('El promedio de los numeros ingresados --->> ', prom:0:2);

	writeln('Salio del programa');
	close(numeros);

end.
