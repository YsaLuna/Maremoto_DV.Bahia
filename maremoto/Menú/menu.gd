extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Menú/contexto.tscn")


func _on_créditos_pressed() -> void:
	get_tree().change_scene_to_file("res://Menú/creditos.tscn")


func _on_salir_pressed() -> void:
	get_tree().quit()
