extends PlayerBase
class_name NpcBase

##VARIAVEIS COMUNS
## -----------------------------------------------------------------------

# Variavel que vai armazenar o body do player quando ele tiver na area de interação
var _player_in_range : bool = false # agora eu mudei pra quem fazer isso de cima ser o _player
var dialog_opened : bool = false # Vê se o dialogo ta aberto
var _player : PlayerBase = null # Pra usar o freeze()
var current_dialog : String = "first_dialog" # Variavel pra mudar o dialogo quando falar dnv

## VARIAVEIS E CATEGORIAS PARA INSPETOR
## -----------------------------------------------------------------------

# Nome do npc uau
@export var _npc_name : String = ""
# Referência à camada de UI (CanvasLayer) da cena para instanciar a caixa de diálogo fixa na tela
@export var _interface : CanvasLayer

## -----------------------------------------------------------------------

func _ready():
	# Executa o _ready() original do Player primeiro
	# super._ready() deixei isso comentado pq tava ferrando o codigo.
	# por algum motivo fazia o npc spawnar junto com o player na target_position do portal
	
	# Remove o NPC do grupo "Player" forçadamente por codigo pq nao da pra tirar no inspetor aparentemente
	if is_in_group("Player"):
		remove_from_group("Player")
		
	_animation_tree.active = true
	_state_machine = _animation_tree["parameters/playback"]
	_state_machine.travel("idle")
	
	print(is_in_group("Player"))
	
## -----------------------------------------------------------------------

func _physics_process(_delta: float) -> void:
	pass
	
## -----------------------------------------------------------------------
	
# Função reservada que pega um input
func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range == true:
		if event.is_action_pressed("interact") and not dialog_opened:
			_interact()
	else:
		return
		
## -----------------------------------------------------------------------
	
# Função de interação que chama o diálogo
func _interact() -> void:
	
	# Vira o npc pro player
	_face_to_player(_player.global_position)
		
	# instancia (cria uma cópia em memória) da cena da UI do dialogo
	var _dialog_scene : DialogSceneClass = load("res://scenes/dialog_scene.tscn").instantiate()
	
	# Passa o dicionario de dados do singleton DialogManager correspondente a este npc para a UI
	_dialog_scene._dialog_infos = DialogManager._dialog_list[_npc_name]
	
	# Adiciona a janela de dialogo como filha da camada de interface (CanvasLayer) pra exibir na tela
	_interface.add_child(_dialog_scene)
	
	# Congela o player enquanto esta no dialogo
	_player.freeze(true)
	# Define a flag local como verdadeira pra evitar que a interação aconteça dnv
	dialog_opened = true
	
	# Passa a referencia do player pra UI (pra poder descongelar ele quando terminar)
	_dialog_scene.current_player =  _player
	# Passa a referencia desse proprio npc pra UI (pra poder atualizar o estado do dialogo)
	_dialog_scene.current_npc = self
		
	print("Hi, Maple!")
	print(DialogManager._dialog_list[_npc_name])
		
## -----------------------------------------------------------------------
	
# Função que efetivamente faz o npc virar pro player (sistema provisório)
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
			
## -----------------------------------------------------------------------

# Atualiza o Blend Position do estado Idle na AnimationTree para mudar a direção do sprite
func _set_facing_direction(dir : Vector2):
	if $AnimationTree:
		$AnimationTree.set("parameters/idle/blend_position", dir)
		
## -----------------------------------------------------------------------
 
# Signal de quando o player entra na area de interação com o npc
func _on_interation_area_body_entered(body: Node2D) -> void:
	# Se é do grupo Player...
	if body.is_in_group("Player"):
		# Salva o body na variavel, especificando o tipo como CharacterBody2D
		_player_in_range = true
		_player = body as CharacterBody2D
		
## -----------------------------------------------------------------------

# Signal de qaundo o player sai da area de interação com o npc
func _on_interation_area_body_exited(body: Node2D) -> void:
	# Se o body estava na area de interação antes...
	if body == _player:
		# Agora não ta mais
		_player_in_range = false
		_player = null
		
## -----------------------------------------------------------------------
