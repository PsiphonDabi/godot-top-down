extends PlayerBase
class_name NpcBase

# Variavel que vai armazenar o body do player quando ele tiver na area de interação
var _player_in_range : bool = false # agora eu mude pra quem fazer isso de cima ser o _player

var dialog_opened : bool = false

var _player : PlayerBase = null # Para freeze()

var current_dialog : String = "first_dialog" # Variavel pra mudar o dialogo quando falar dnv

@export var _npc_name : String = ""

@export var _interface : CanvasLayer #ainda n sei pra q isso aq

func _ready():
	# Executa o _ready() original do Player primeiro
	#super._ready() deixei isso comentado pq tava ferrando o codigo.
	#por algum motivo fazia o npc spawnar junto com o player na target_position do portal
	
	# Remove o NPC do grupo "Player" forçadamente por codigo pq nao da pra tirar no inspetor aparentemente
	if is_in_group("Player"):
		remove_from_group("Player")
		
	_animation_tree.active = true
	_state_machine = _animation_tree["parameters/playback"]
	_state_machine.travel("idle")
	
	print(is_in_group("Player"))

func _physics_process(_delta: float) -> void:
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range == true:
		if event.is_action_pressed("interact") and not dialog_opened:
			_interact()
	else:
		return
	
func _interact() -> void:
		_face_to_player(_player.global_position)
		
		var _dialog_scene : DialogSceneClass = load("res://scenes/dialog_scene.tscn").instantiate()
		_dialog_scene._dialog_infos = DialogManager._dialog_list[_npc_name]
		
		_dialog_scene.current_dialog = current_dialog
		
		_interface.add_child(_dialog_scene)
		_player.freeze(true)
		dialog_opened = true
		
		_dialog_scene.current_player =  _player
		_dialog_scene.current_npc = self
		
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
		_player_in_range = true
		_player = body as CharacterBody2D

func _on_interation_area_body_exited(body: Node2D) -> void:
	# Se o body estava na area de interação antes...
	if body == _player:
		# Agora não ta mais
		_player_in_range = false
		_player = null
