extends Node2D
signal player_touched_neighbor  # Declara la señal

@onready var area = $Area2D  # Ruta al nodo Area2D
@onready var collision_shape = $Area2D/CollisionShape2D  # Ruta al nodo CollisionShape2D
@onready var ANIM_NEIGHBOR = $NeighborBody
@onready var ANIM_NEIGHBORHAIR = $NeighborHair
@onready var ANIM_NEIGHBORTOOL = $NeighborTool
@onready var dialog_label = $DialogLabel  # Nodo para mostrar los mensajes

func _ready():
	# Conecta la señal body_entered del Area2D al método _on_area_entered
	area.body_entered.connect(_on_area_entered)
	hide_dialog()  # Oculta el diálogo al inicio

func _on_area_entered(body):
	if body.name == "Player":
		show_dialog("¡Ayuda! No podemos salir. Rompe el tronco.")  # Mensaje inicial
		body.connect("tree_cut_complete", self, "_on_tree_cut_complete")  # Escuchar señal del jugador
		
func _on_tree_cut_complete():
	show_dialog("¡Gracias!")  # Mensaje de agradecimiento
	
func show_dialog(text: String):
	dialog_label.text = text
	dialog_label.visible = true

func hide_dialog():
	dialog_label.visible = false

func _process(_delta: float) -> void:
	ANIM_NEIGHBOR.play("Idle")
	ANIM_NEIGHBORHAIR.play("Hair")
	ANIM_NEIGHBORTOOL.play("Tool")

#func _on_area_entered(body):
	#if body is CharacterBody2D:  # Verifica si el cuerpo es del tipo CharacterBody2D
	#	print("Colisión detectada con el Vecino")
	#	emit_signal("player_touched_neighbor")

# Método para desactivar el área de colisión de forma segura
func disable_collision():
	collision_shape.call_deferred("set_disabled", true)
