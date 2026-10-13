extends CanvasLayer
class_name SceneTrnsitionClass # Mesmo caso do PortalManagerClass

@onready var _transition_animation : AnimationPlayer = $AnimationPlayer
# pq com _???

# Função global responsável por coordenar a mudança de cena com animação
func change_scene_with_fade(target_scene) -> void:
	# Toca o fade out
	_transition_animation.play("fade_out")
	await _transition_animation.animation_finished
	
	# Troca a cena
	get_tree().change_scene_to_file("res://maps/" + target_scene + ".tscn")
	
	# Espera 1 frame para garantir que a nova cena carregou completamente
	await get_tree().process_frame
	
	# No mapa novo, busca o novo player e trava ele antes de iniciar o Fade In
	var new_player = get_tree().get_first_node_in_group("Player")
	if new_player and new_player.has_method("enter_portal"):
		new_player.enter_portal()
		
	# Toca fade in
	_transition_animation.play("fade_in")
	await _transition_animation.animation_finished
	
	# Agora que o fade in terminou da pra liberar o movimento
	if new_player and "portal_entered" in new_player:
		new_player.portal_entered = false
	
