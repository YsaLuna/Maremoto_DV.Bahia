extends Node2D

@onready var player = $Player  # Ruta al nodo del Player
@onready var neighbor = $Neighbor  # Ruta al primer vecino
@onready var neighbor2 = $Neighbor2  # Ruta al segundo vecino (asegúrate de que exista en tu escena)
@onready var final = $Final  # Nodo Area2D del punto final

func _ready():
	# Conectar la señal del primer vecino
	neighbor.player_touched_neighbor.connect(_on_player_touched_neighbor)

	# Conectar la señal del segundo vecino
	neighbor2.player_touched_neighbor.connect(_on_player_touched_neighbor2)
	
	# Conectar la señal `body_entered` del nodo `final`
	final.body_entered.connect(_on_body_entered)

func _on_player_touched_neighbor():
	# Maneja el evento al colisionar con el primer vecino
	print("Colisión con el vecino detectada.")
	player.activate_first_event()  # Activa el evento "Talar Arbol"
	neighbor.disable_collision()  # Desactiva el área de colisión del vecino

func _on_player_touched_neighbor2():
	# Maneja el evento al colisionar con el segundo vecino
	print("Colisión con el vecino2 detectada.")
	player.activate_second_event()  # Activa el evento "Llevar Caja"

func _on_body_entered(body):
	if body is CharacterBody2D:  # Verifica si el cuerpo es el jugador
		# Cambia a la escena "Nivel1"
		get_tree().change_scene_to_file("res://Scenes/Nivel1.tscn")
