extends Node2D
signal player_touched_neighbor  # Declara la señal

@onready var area = $Area2D  # Ruta al nodo Area2D
@onready var ANIM_NEIGHBOR = $NeighborBody
@onready var ANIM_NEIGHBORHAIR = $NeighborHair
@onready var ANIM_NEIGHBORTOOL = $NeighborTool
@onready var dialog_label = $Label  # Nodo para mostrar los mensajes

func _ready():
	# Conecta la señal body_entered del Area2D al método _on_area_entered
	area.body_entered.connect(_on_area_entered)
	hide_dialog()  # Oculta el diálogo al inicio

func _process(_delta: float) -> void:
	ANIM_NEIGHBOR.play("Idle")
	ANIM_NEIGHBORHAIR.play("Hair")
	ANIM_NEIGHBORTOOL.play("Tool")
	
func show_dialog(text: String):
	dialog_label.text = text
	dialog_label.visible = true

func hide_dialog():
	dialog_label.visible = false
func _on_area_entered(body):
	if body is CharacterBody2D:  # Verifica si el cuerpo es del tipo CharacterBody2D
		print("Colisión detectada con el Vecino 2")
		show_dialog("Por favor! Lleva estas provisiones a la casa verde.")  # Mensaje inicial
		emit_signal("player_touched_neighbor")
