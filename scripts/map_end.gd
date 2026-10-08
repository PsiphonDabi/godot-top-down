extends Area2D
class_name Portal


@export var next_map : String = "" # Mapa alvo do teleporte
@export var target_position : Vector2 # Posição alvo no mapa alvo do teleporte
@export var facing_direction : Vector2 = Vector2.DOWN


func _on_body_entered(_body: Node2D) -> void:
	
	# Checa se o corpo que entrou na área é do grupo Player
	if not _body.is_in_group("Player"):
		return
		
	# Parando o player quando encosnta no teleporte
	if _body is CharacterBody2D and _body.has_method("enter_portal"):
		_body.enter_portal()
	
	# Armazena a posição de destino no singleton
	PortalManager.target_position = target_position
	
	# Armazena a direção de saída (pós teleporte) no singleton
	PortalManager.spawn_facing_direction = facing_direction
	
	# Inicia a transição
	SceneTransition.change_scene_with_fade(next_map)
