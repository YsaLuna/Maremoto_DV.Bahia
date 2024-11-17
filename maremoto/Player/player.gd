extends CharacterBody2D

@onready var ANIM_PLAYER = $PlayerSprite


var wind_force = -500  # Fuerza inicial del viento
var is_event_active = false  # Variable para controlar si hay un evento activo
var current_event = ""  # Nombre del evento actual
var space_press_count = 0  # Contador de veces que se ha presionado la tecla de espacio
const SPACE_PRESS_REQUIRED = 5  # Veces necesarias para finalizar el primer evento

# Variables y lógica para el segundo evento
var first_point_reached = false  # Indica si el primer punto ha sido alcanzado

func _ready():
	pass
	# Conecta las señales body_entered de los puntos


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
	if not is_event_active:
		if Input.is_key_pressed(KEY_W):
			move_local_y(-2)
		if Input.is_key_pressed(KEY_A):
			move_local_x(-2)
		if Input.is_key_pressed(KEY_S):
			move_local_y(2)
		if Input.is_key_pressed(KEY_D):
			move_local_x(2)

# Función para manejar el primer evento: "Talar Arbol"
func handle_first_event():
	velocity.x = 0  # Detén el movimiento horizontal
	if Input.is_action_just_pressed("ui_accept"):
		space_press_count += 1
		ANIM_PLAYER.play("Axe")  # Reproduce la animación "Axe"
		print("Tecla espacio presionada:", space_press_count, "/", SPACE_PRESS_REQUIRED)
		if space_press_count >= SPACE_PRESS_REQUIRED:
			deactivate_event()

# Función para manejar el segundo evento: "Llevar Caja"
func handle_second_event():
	if Input.is_action_just_pressed("ui_accept"):
		ANIM_PLAYER.play("Carry")  # Reproduce la animación "Carry"

# Función para activar el primer evento: "Talar Arbol"
func activate_first_event():
	print("Evento activado: Talar Arbol")
	ANIM_PLAYER.play("Idle")  # Cambia a la animación "Idle"
	wind_force = 0  # Detén el efecto del viento
	is_event_active = true
	current_event = "Talar Arbol"
	space_press_count = 0  # Resetea el contador

# Función para activar el segundo evento: "Llevar Caja"
func activate_second_event():
	print("Evento activado: Llevar Caja")
	ANIM_PLAYER.play("Idle")  # Cambia a la animación "Idle"
	wind_force = 0  # Detén el efecto del viento
	is_event_active = true
	current_event = "Llevar Caja"
	first_point_reached = false  # Resetea el estado del evento

# Función para desactivar cualquier evento activo
func deactivate_event():
	print("Evento desactivado:", current_event)
	is_event_active = false
	wind_force = -1000  # Restaura el efecto del viento
	current_event = ""
	ANIM_PLAYER.play("Idle")  # Cambia la animación a "Idle"

# Función que se ejecuta cuando se toca el primer punto
func _on_first_point_entered(area):
	if not first_point_reached and is_event_active and current_event == "Llevar Caja":
		first_point_reached = true
		print("Primer punto alcanzado")

# Función que se ejecuta cuando se toca el segundo punto
func _on_second_point_entered(area):
	if first_point_reached and is_event_active and current_event == "Llevar Caja":
		print("Segundo punto alcanzado, evento completado")
		deactivate_event()
