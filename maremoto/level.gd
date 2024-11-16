extends Node

@onready var player = $Player  # Ruta al nodo del `Player`
@onready var neighbor = $Neighbor  # Ruta al nodo del vecino
# Agrega aquí otros NPCs si los tienes

func _ready():
	# Conectar la señal del vecino para manejar el evento
	neighbor.player_touched_neighbor.connect(_on_player_touched_neighbor)

	# Conectar señales de otros NPCs aquí si es necesario

func _on_player_touched_neighbor():
	# Maneja el evento al colisionar con el vecino
	print("Colisión con el vecino detectada.")
	player.activate_event("CortarArbol", "Axe")  # Cambia a la animación "Talk"
	player.wind_force = 0

# Puedes agregar más métodos para manejar otros NPCs
