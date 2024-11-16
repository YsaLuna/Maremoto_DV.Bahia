extends Node2D

signal player_touched_neighbor  # Declara una señal

@onready var area = $Area2D

func _ready():
	# Conecta la señal `body_entered` del `Area2D` al método `_on_area_entered`
	area.body_entered.connect(_on_area_entered)

func _on_area_entered(body):
	# Verifica si el cuerpo que ha entrado es el `Player`
	if body.name == "Player":
		emit_signal("player_touched_neighbor")  # Emite la señal al colisionar
