{Realizar un algoritmo que cree un archivo de números enteros no ordenados 
y permita incorporar datos al archivo. 
Los números son ingresados desde teclado. 
El nombre del archivo debe ser proporcionado por el usuario desde teclado. 
La carga finaliza cuando se ingrese el número 30000, que no debe incorporarse al archivo.}

program p01e01;

type
	arc_num = file of integer;
	
var
	numeros: arc_num;
	nom_fis: string[12];
	num: integer;

begin
	
	writeln('Ingrese el nombre del archivo fisico');
	read(nom_fis);
	
	assign(numeros, nom_fis);
	rewrite(numeros);

	writeln('Agregue un numero entero (3000 para salir)');
	read(num);
	
	while(num <> 3000) do begin
		write(numeros, num);
		
		writeln('Agregue un numero entero (3000 para salir)');
		read(num);
		end;

	writeln('Salio del programa');
	close(numeros);

end.
