extends Area2D
class_name ObjectArea

##VARIAVEIS COMUNS
## -----------------------------------------------------------------------

var _player_in_range : bool = false # Ve se o player ta no alcance de interação
var _player : PlayerBase # Pra usar o freeze()
var dialog_opened : bool = false # Vê se o dialogo ta aberto
var current_dialog : String = "first_dialog" # Variavel pra mudar o dialogo quando falar dnv

## VARIAVEIS E CATEGORIAS PARA INSPETOR
## -----------------------------------------------------------------------

# Nome do objeto no dialog_manager
@export var _object_name : String = ""
# Referência à camada de UI (CanvasLayer) da cena para instanciar a caixa de diálogo fixa na tela
@export var _interface : CanvasLayer

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
		
		# Instancia (cria uma cópia em memória) da cena da UI do dialogo
		var _dialog_scene : DialogSceneClass = load("res://scenes/dialog_scene.tscn").instantiate()
		# Aqui a gente usa a função da chave pra permitir que filhos sobrescrevam
		var dialog_key = _get_dialog_key()
		
		# Passa o dicionario de dados do singleton DialogManager correspondente a este objeto para a UI
		_dialog_scene._dialog_infos = DialogManager._dialog_list[dialog_key]
		
		# Adiciona a janela de dialogo como filha da camada de interface (CanvasLayer) pra exibir na tela
		_interface.add_child(_dialog_scene)
		
		# Congela o player enquanto esta no dialogo
		_player.freeze(true)
		# Define a flag local como verdadeira pra evitar que a interação aconteça dnv
		dialog_opened = true
		
		# Passa a referencia do player pra UI (pra poder descongelar ele quando terminar)
		_dialog_scene.current_player =  _player
		# Passa a referencia desse proprio npc pra UI (pra poder atualizar o estado do dialogo)
		_dialog_scene.current_npc = self # ATENÇÃO: o nome ta como npc mas serve tanto pra npc quanto pra objeto
		
		print("Hi, Maple!")
		print(DialogManager._dialog_list[_object_name])
	
## -----------------------------------------------------------------------

# Função que define qual chave buscar no DialogManager (pode ser sobrescrita por filhos)
func _get_dialog_key() -> String:
	return _object_name # _object_name por padrao
	
## -----------------------------------------------------------------------

func _on_body_entered(body: Node2D) -> void:
	# Se é do grupo Player...
	if body.is_in_group("Player"):
		# Salva o body na variavel, especificando o tipo como CharacterBody2D
		_player_in_range = true
		_player = body as CharacterBody2D

## -----------------------------------------------------------------------

func _on_body_exited(body: Node2D) -> void:
	# Se o body estava na area de interação antes...
	if body == _player:
		# Agora não ta mais
		_player_in_range = false
		_player = null
