extends PlayerBase
class_name NpcBase

# Variavel que vai armazenar o body do player quando ele tiver na area de interação
var _player_in_range : CharacterBody2D = null

@export var _npc_name : String = ""

func _ready():
	_animation_tree.active = true
	_state_machine = _animation_tree["parameters/playback"]
	_state_machine.travel("idle")

func _physics_process(_delta: float) -> void:
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and _player_in_range:
		_interact()
	
func _interact() -> void:
		_face_to_player(_player_in_range.global_position)
		
		print("Hi, Maple!")
		print(DialogManager._dialog_list[_npc_name])
	
func _face_to_player(player_position : Vector2) -> void:
	# Vetor direção + determinação do eixo predominante, chamando a função
	var direction = (player_position - global_position).normalized()
	
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			_set_facing_direction(Vector2.RIGHT)
		else:
			_set_facing_direction(Vector2.LEFT)
	else:
		if direction.y > 0:
			_set_facing_direction(Vector2.DOWN)
		else:
			_set_facing_direction(Vector2.UP)
			
func _set_facing_direction(dir : Vector2):
	if $AnimationTree:
		$AnimationTree.set("parameters/idle/blend_position", dir)
 
# Signal de quando o player entra na area de interação com o npc
func _on_interation_area_body_entered(body: Node2D) -> void:
	# Se é do grupo Player...
	if body.is_in_group("Player"):
		# Salva o body na variavel, especificando o tipo como CharacterBody2D
		_player_in_range = body as CharacterBody2D

func _on_interation_area_body_exited(body: Node2D) -> void:
	# Se o body estava na area de interação antes...
	if body == _player_in_range:
		# Agora não ta mais
		_player_in_range = null
