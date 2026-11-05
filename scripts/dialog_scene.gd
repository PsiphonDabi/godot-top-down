extends Control
class_name DialogSceneClass

##VARIAVEIS COMUNS
## -----------------------------------------------------------------------

var _dialog_index : int = 0 # Indice que tem no _dialog_list que ordena as falas no dialog_manager
var _dialog_infos : Dictionary = {} # |Informações de cada dialogo no dialog_manager
var current_dialog : String = "" # Variavel que armazena qual dialogo (tipo first_dialog, second_dialog, etc)
var _player : CharacterBody2D = null # Armazena o player (criado para usar o freeze())

var current_player : PlayerBase # Isso aq é mais pra usar o freeze por enquanto
var current_npc # Pra usar algumas variaveis de npc, como dialog_opened e current_dialog
# OBSERVAÇÃO: removi a tipagem de NpcBase do current_npc pra funcionar essa variavel no object_area

var dialog_speed : float = 0.015

## -----------------------------------------------------------------------

func _ready() -> void:
	print (_dialog_infos)
	print(current_dialog)
	current_dialog = _dialog_infos["current_dialog"] # Informações da caixa de dialogo atual
	# E tambem pega o second_dialog do singleton do dialog_manager
	_load_dialog()
	
## -----------------------------------------------------------------------

# Função que gera a caixa de dialogo
func _load_dialog() -> void:
	# # Obtém as informações e configurações do bloco de diálogo atual baseado no índice
	var infos_current_dialog : Dictionary = _dialog_infos[current_dialog][_dialog_index]
	# O primeiro indice pega qual o dialogo da vez (first, second, ...)
	# O segundo pega o indice dentro de cada dialogo (qual caixa de dialogo aparece)
	
	if not infos_current_dialog["picture"].is_empty():
		# Carrega a picture que tem na _dialog_list
		$dialogbox/picture.texture = load(infos_current_dialog["picture"])	
	else:
		$dialogbox/picture.texture = null
	
	# Possibilidades de dialogo: message e question
	match infos_current_dialog["type"]:
		"message":
			$dialogbox/dialog.text = infos_current_dialog["text"]  # Pega o texto da _dialog_list
			$dialogbox/VBoxContainer.hide()
			$dialogbox/dialog.show()
			# Se tiver um vbox (dialogo de escolhas), esconede pra mostrar o dialogo 
			
			$dialogbox/dialog.visible_ratio = 0 # Inicializa a caixa com nada escrito
			
		"question":
			$dialogbox/dialog.hide()
			$dialogbox/VBoxContainer.show()
			# Se tiver um dialogo normal, esconde pra mostrar o de escolha
			$dialogbox/VBoxContainer/choicesdialog.text = infos_current_dialog["text"]
			
			$dialogbox/VBoxContainer/choicesdialog.visible_ratio = 0 # Inicializa a caixa com nada escrito
			
			# Esconde as escolhas do dialogo de escolhas
			for _choice in $dialogbox/VBoxContainer/HBoxContainer.get_children():
				_choice.hide()
				# Difernça entre get_child() e get_children()???
			
			# Botando as escolhas
			var _index : int = 0
			for _choice in infos_current_dialog["choices"]:
				# Acessando a escolha pra ela receber o que tem na DialogScene
				var _container_choice : NinePatchRect = $dialogbox/VBoxContainer/HBoxContainer.get_child(_index)
				
				# Proxima escolha
				_container_choice.get_node("text").text = _choice
				_container_choice.show()
				_index += 1
				
# Usamos o process para a atualização das caixas de dialogo
func _process(_delta: float) -> void:
	
	# Fazendo as letras aparecerem uma a uma na velocidade dialog_speed (sistema provisório)
	if $dialogbox/dialog.visible_ratio < 1.0:
		$dialogbox/dialog.visible_ratio += dialog_speed
	
	# Se confirmar passa pro proximo dialogo
	if Input.is_action_just_pressed("interact"):
		# Se o indice passsa do tamamho do array de dialogos, encerra a conversa
		if _dialog_index >= _dialog_infos[current_dialog].size():
			_end_dialog()
			return
		# Carrega o proximo dialogo e aumenta o indice
		_load_dialog()
		_dialog_index += 1

# Função que encerra o nó do dialogo
func _end_dialog() -> void:
	if current_npc.current_dialog == "first_dialog":
		if _dialog_infos.has("second_dialog"):
			_dialog_infos["current_dialog"] = "second_dialog"
	
	current_player.freeze(false) # Descongela o player dps do dialogo fechar
	current_npc.dialog_opened = false
	
	queue_free() # Da um fim no nó do dialogo na cena
	
	
