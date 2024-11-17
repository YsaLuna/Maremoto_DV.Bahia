extends CanvasModulate

@onready var color_rect = $ColorRect  # Referencia al nodo `ColorRect`
@onready var rain_particles = $Particles2D  # Referencia al nodo `Particles2D`
@onready var thunder_sound = $AudioStreamPlayer  # Referencia al nodo `AudioStreamPlayer`

var transition_speed = 1.0  # Velocidad de la transición de color
var is_lightening = true  # Controla si el filtro se está aclarando
var max_brightness = 0.8  # Máxima claridad del filtro
var min_brightness = 0.5  # Mínima oscuridad del filtro
var alpha = 0.5  # Transparencia del filtro gris

func _ready():
	# Configurar el ColorRect
	color_rect.color = Color(0.5, 0.5, 0.5, alpha)  # Gris con transparencia

	# Configurar las partículas de lluvia
	rain_particles.amount = 1000  # Número de gotas de lluvia
	rain_particles.gravity = Vector2(0, 800)  # Gravedad hacia abajo
	rain_particles.lifetime = 2.0  # Tiempo de vida de las gotas
	rain_particles.speed_scale = 1.5  # Escala de velocidad de las gotas
	rain_particles.emitting = true  # Empieza a emitir partículas

	# Configurar el sonido de la tormenta
	thunder_sound.loop = true  # Reproduce el sonido en bucle
	thunder_sound.play()  # Inicia el sonido de la tormenta

func _process(delta):
	# Simula el cambio de color de la tormenta
	var color = color_rect.color
	if is_lightening:
		color.r = min(color.r + transition_speed * delta, max_brightness)
		color.g = min(color.g + transition_speed * delta, max_brightness)
		color.b = min(color.b + transition_speed * delta, max_brightness)
		if color.r >= max_brightness:
			is_lightening = false
	else:
		color.r = max(color.r - transition_speed * delta, min_brightness)
		color.g = max(color.g - transition_speed * delta, min_brightness)
		color.b = max(color.b - transition_speed * delta, min_brightness)
		if color.r <= min_brightness:
			is_lightening = true
	color.a = alpha
	color_rect.color = color
