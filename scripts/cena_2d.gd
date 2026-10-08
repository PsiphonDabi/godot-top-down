extends Node2D
	
@export var proxima_cena : PackedScene

#conectando o sinal body_entered para saber quando a area 2d colidiu com algum corpo

#funcao que age como ponto de recepcao do sinal
func _on_area_2d_body_entered(body) -> void:
	get_tree().change_scene_to_packed(proxima_cena)
