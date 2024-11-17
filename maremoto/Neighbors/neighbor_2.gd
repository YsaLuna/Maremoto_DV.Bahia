extends Node2D
signal player_touched_neighbor  # Declara la señal

@onready var area = $Area2D  # Ruta al nodo Area2D
@onready var ANIM_NEIGHBOR = $NeighborBody
@onready var ANIM_NEIGHBORHAIR = $NeighborHair
@onready var ANIM_NEIGHBORTOOL = $NeighborTool

func _ready():
	# Conecta la señal body_entered del Area2D al método _on_area_entered
	area.body_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	ANIM_NEIGHBOR.play("Idle")
	ANIM_NEIGHBORHAIR.play("Hair")
	ANIM_NEIGHBORTOOL.play("Tool")

func _on_area_entered(body):
	if body is CharacterBody2D:  # Verifica si el cuerpo es del tipo CharacterBody2D
		print("Colisión detectada con el Vecino 2")
		emit_signal("player_touched_neighbor")
