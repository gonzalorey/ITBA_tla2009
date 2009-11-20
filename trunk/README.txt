Compilaci�n:

Para compilar, pararse sobre la misma carpeta en la que se encuentra este archivo README y escribir
make. Esto generar� dos archivos ejecutables, pwiki y plexemes, en la misma carpeta.


Modo de uso:
El archivo pwiki recibe como par�metro obligatorio el nombre de un archivo con wikitext para traducir
a html, y como par�metro opcional el nombre de un archivo en donde se dejar� el archivo html
traducido. En caso de no proporcionar un nombre de archivo de salida, la salida se deja por
default en el archivo out.html.

El archivo plexemes recibe como �nico par�metro el nombre de un archivo con wikitext. Imprime en la
salida est�ndar dos tablas: la primer tabla tiene los lexemas encontrados y a que clase de token
pertenece cada uno; la segunda tabla imprime la cantidad de lexemas que aparecieron por cada clase de
token.