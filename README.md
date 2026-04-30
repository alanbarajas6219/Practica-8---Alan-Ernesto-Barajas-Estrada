# Descripcion - Practica 8
Proyecto en Godot estilo Crossy Road con estetica voxel. 
El jugador controla al personaje Leonix y debe avanzar por carriles, esquivar vehiculos y recolectar monedas distribuidas en el nivel.

## Controles
- W: avanzar.
- S: retroceder.
- A: moverse a la izquierda.
- D: moverse a la derecha.
- Tambien se pueden usar las flechas del teclado.

## Mecanica principal
El jugador se mueve por casillas, como en Crossy Road. Los vehiculos aparecen en los carriles y se desplazan horizontalmente. 
Si el jugador toca un vehiculo, vuelve al inicio del nivel, pero conserva las monedas acumuladas durante la sesion.

## Coleccionables
Se agrego la escena `Collectible.tscn`, construida con un `Area3D`, un `CollisionShape3D`, un mesh sencillo estilo voxel y un sonido de recoleccion.
Cuando el jugador toca una moneda:
1. Se emite la señal `picked`.
2. Aumenta el contador de monedas.
3. Se reproduce un sonido.
4. La moneda desaparece de la escena.
5. Se actualiza la interfaz.
El contador se muestra como:
```text
Monedas: X
```
El total se guarda en el autoload `Session.gd`, por lo que no se pierde al reiniciar el nivel dentro de la misma sesion de juego.

## Base de datos local SQLite
El proyecto incluye el script `db_manager.gd`, encargado de crear y utilizar la base de datos local:
Al terminar una partida por choque con un vehiculo, el juego compara las monedas acumuladas con la mejor puntuacion guardada. 
Si el nuevo total es mayor, se actualiza el record historico.

Para que SQLite funcione de forma completa, se instala desde AssetLib:
```text
Godot-SQLite
Autor: 2shady4u
```
El juego incluye un respaldo local para no romperse si el plugin todavia no ests instalado, pero para que funcione correctamente debe estar activo el plugin `Godot-SQLite`.

## API externa utilizada
API usada:
```text
Advice Slip API
https://api.adviceslip.com/advice
```
El proyecto usa un nodo `HTTPRequest` para hacer una peticion REST y procesar la respuesta JSON.
La respuesta de la API afecta el gameplay de esta manera:
- Si el ID del consejo recibido es "par", los vehiculos aumentan su velocidad un 25%.
- Si el ID del consejo recibido es "impar", los vehiculos reducen su velocidad un 20%.
- El consejo recibido se muestra en pantalla dentro de la interfaz.
Ademas, el juego vuelve a consultar la API cada 10 segundos mediante un `Timer` llamado `APITimer`.
