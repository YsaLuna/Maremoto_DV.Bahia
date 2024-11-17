extends CharacterBody2D

@onready var ANIM_PLAYER = $PlayerSprite
@onready var destination_point = $"../DestinationPoint"  # Ruta al nodo `Area2D` del punto de destino
@onready var instruction_label = $InstructionLabel  # Ruta directa al nodo `Label` dentro de `Player`

@onready var tree_asset = $"../TreeAsset"  # Cambia la ruta al nodo correcto

var wind_force = -500  # Fuerza inicial del viento
var is_event_active = false  # Variable para controlar si hay un evento activo
var current_event = ""  # Nombre del evento actual
var space_press_count = 0  # Contador de veces que se ha presionado la tecla de espacio
const SPACE_PRESS_REQUIRED = 5  # Veces necesarias para finalizar el primer evento
var original_speed = 2  # Velocidad original del jugador
var reduced_speed = 1  # Velocidad reducida para el segundo evento

# Variables y lógica para el segundo evento
var first_point_reached = false  # Indica si el jugador ha llegado al destino

func _ready():
	# Conecta la señal `body_entered` del punto de destino
	destination_point.body_entered.connect(_on_destination_point_entered)
	update_instruction("¡Bienvenido! Usa las teclas WASD para moverte.")

func _process(_delta: float) -> void:
	if not is_event_active:
		# Aplica el viento solo si no hay un evento activo
		if velocity.x == 0:
			velocity.x += wind_force * _delta

		# Verifica si se presiona alguna tecla de movimiento
		if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_D):
			ANIM_PLAYER.play("Run")
		else:
			ANIM_PLAYER.play("Idle")

		# Voltea la animación dependiendo de la dirección
		if Input.is_key_pressed(KEY_A):
			ANIM_PLAYER.flip_h = true
		elif Input.is_key_pressed(KEY_D):
			ANIM_PLAYER.flip_h = false
	else:
		# Si un evento está activo, controla cuál se está ejecutando
		if current_event == "Talar Arbol":
			handle_first_event()
		elif current_event == "Llevar Caja":
			handle_second_event()

	move_and_slide()

func _physics_process(_delta: float) -> void:
	var speed = original_speed if not is_event_active else reduced_speed
	if not is_event_active or current_event == "Llevar Caja":
		if Input.is_key_pressed(KEY_W):
			move_local_y(-speed)
		if Input.is_key_pressed(KEY_A):
			move_local_x(-speed)
		if Input.is_key_pressed(KEY_S):
			move_local_y(speed)
		if Input.is_key_pressed(KEY_D):
			move_local_x(speed)

# Función para manejar el primer evento: "Talar Arbol"
func handle_first_event():
	velocity.x = 0  # Detén el movimiento horizontal
	if Input.is_action_just_pressed("ui_accept"):
		space_press_count += 1
		ANIM_PLAYER.play("Axe")  # Reproduce la animación "Axe"
		print("Tecla espacio presionada:", space_press_count, "/", SPACE_PRESS_REQUIRED)
		update_instruction("Presiona espacio: " + str(space_press_count) + "/" + str(SPACE_PRESS_REQUIRED))
		if space_press_count >= SPACE_PRESS_REQUIRED:
			deactivate_event()

# Función para manejar el segundo evento: "Llevar Caja"
func handle_second_event():
	ANIM_PLAYER.play("Carry")  # Cambia a la animación "Carry"
	update_instruction("Lleva la caja al destino marcado.")
	wind_force = -2000
	

# Función para actualizar el texto del `Label`
func update_instruction(text: String):
	instruction_label.text = text

# Función para activar el primer evento: "Talar Arbol"
func activate_first_event():
	print("Evento activado: Talar Arbol")
	ANIM_PLAYER.play("Idle")  # Cambia a la animación "Idle"
	wind_force = 0  # Detén el efecto del viento
	is_event_active = true
	current_event = "Talar Arbol"
	space_press_count = 0  # Resetea el contador
	update_instruction("Presiona espacio 5 veces para talar el árbol.")

# Función para activar el segundo evento: "Llevar Caja"
func activate_second_event():
	print("Evento activado: Llevar Caja")
	ANIM_PLAYER.play("Carry")  # Cambia a la animación "Carry"
	wind_force = 0  # Detén el efecto del viento
	is_event_active = true
	current_event = "Llevar Caja"
	first_point_reached = false  # Resetea el estado del evento
	update_instruction("Lleva la caja al destino marcado.")

# Función para desactivar cualquier evento activo
func deactivate_event():
	print("Evento desactivado:", current_event)
	is_event_active = false
	wind_force = -1000  # Restaura el efecto del viento
	current_event = ""
	ANIM_PLAYER.play("Idle")  # Cambia la animación a "Idle"
	update_instruction("Evento completado. Usa las teclas WASD para seguir moviéndote.")
	# Haz que el nodo desaparezca al finalizar el evento
	tree_asset.visible = false  # Hace que el árbol desaparezca

# Función que se ejecuta cuando se llega al punto	 de destino
func _on_destination_point_entered(area):
	if area.name == "Player" and is_event_active and current_event == "Llevar Caja":
		print("Punto de destino alcanzado, evento completado")
		deactivate_event()
