extends CharacterBody2D

@onready var ANIM_PLAYER = $PlayerSprite
@onready var axe_timer = $AxeTimer  # Ruta al Timer. Asegúrate de que "AxeTimer" esté correctamente nombrado en tu escena
var wind_force = -1000  # Fuerza inicial del viento
var is_event_active = false  # Variable para controlar si un evento está activo
var current_event = ""  # Nombre del evento actual
var space_press_count = 0  # Contador de veces que se ha presionado la tecla de espacio
const SPACE_PRESS_REQUIRED = 5  # Veces necesarias para finalizar el evento

func _ready():
	# Conecta la señal "timeout" del temporizador
	axe_timer.timeout.connect(_on_axe_timer_timeout)

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
		# Si el evento está activo, asegura que el `velocity.x` sea 0
		velocity.x = 0

		# Si el evento está activo, el `Player` se queda en "Idle" y escucha la tecla de espacio
		if Input.is_action_just_pressed("ui_accept") and !axe_timer.is_stopped():  # Solo permite la acción si el temporizador no está activo
			space_press_count += 1
			ANIM_PLAYER.play("Axe", false)  # Reproduce la animación "Axe" sin bucle
			axe_timer.start()  # Inicia el temporizador
			print("Tecla espacio presionada:", space_press_count, "/", SPACE_PRESS_REQUIRED)

			# Si se ha presionado la tecla de espacio 5 veces, termina el evento
			if space_press_count >= SPACE_PRESS_REQUIRED:
				deactivate_event()

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

func activate_event(event_name: String, animation_name: String):
	print("Evento activado:", event_name)
	ANIM_PLAYER.play("Idle")  # Cambia a la animación "Idle"
	wind_force = 0  # Detén el efecto del viento
	is_event_active = true
	current_event = event_name
	space_press_count = 0  # Resetea el contador de teclas presionadas

func deactivate_event():
	print("Evento desactivado:", current_event)
	is_event_active = false
	wind_force = -1000  # Restaura el efecto del viento
	current_event = ""
	ANIM_PLAYER.play("Idle")  # Cambia la animación a "Idle"

# Método llamado cuando el temporizador se detiene
func _on_axe_timer_timeout():
	print("Animación Axe completa, puedes presionar espacio de nuevo.")
