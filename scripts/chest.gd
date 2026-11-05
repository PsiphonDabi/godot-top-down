extends ObjectArea
class_name ChestBase

## -----------------------------------------------------------------------

@export var _chest_id : String = "" # NÃO é o mesmo que _object_name: aqui serve pra identificar por
# exemplo os diferentes baús de um mapa mesmo que eles tenham a mesma função/mesmo nome no dialog_manager
@export var item_to_give : ItemData # Item que vai ter no baú

## -----------------------------------------------------------------------

var is_opened : bool = false # Ve se o bau foi aberto
@onready var _sprite : AnimatedSprite2D = $AnimatedSprite2D # Animação

## -----------------------------------------------------------------------

func _ready() -> void:
	var scene_name = get_tree().current_scene.name # pra encaixar mais facil na chave abaixo
	var chest_id_key = scene_name + "_" + _object_name + "_" + _chest_id
	# Chave que vai literalmente diferenciar todos os baús do jogo, tanto por mapa
	# quanto por ID
	
	# Checa se a chave do baú do momento está ou não armazenado no DialogManager
	# ou seja, checa o ID e o mapa
	if not DialogManager._dialog_list.has(chest_id_key):
		# Se não está no DialogManager ainda significa que é a primeira vez que o baú
		# é carregado na cena
		
		# O template serve para "fazer cópias" com o duplicate, é tipo um modelo base
		# Não dá pra usar object_data direto pq isso afetaria todos os baús, de
		# modo que todos estivessem conectados (não queremos isso)
		var template = DialogManager._dialog_list.get(_object_name, {})
		
		# Fazendo essa igualdade, cada baú possui sua cópia única 
		DialogManager._dialog_list[chest_id_key] = template.duplicate(true)
		# Daí cada um possui seu estado independente sem afetar o modelo original
		
	# Armazena o caminho que remete aos dados que identificam o baú
	var object_data = DialogManager._dialog_list[chest_id_key]
	print("Baú carregado -> Chave: ", chest_id_key, " | Dados: ", object_data)
	
	# Atualiza a variavel local is_opened com base no que foi guardado no DialogManager
	if object_data.has("is_opened"):
		is_opened = object_data["is_opened"]
	
	# Define a animação correta (aberto ou fechado) logo ao carregar a cena
	_update_visual_state()
	
## -----------------------------------------------------------------------	

# Sobrescreve a _interact() do object_area
func _interact() -> void:
	# Atualiza o estado do baú se for a primeira abertura
	if not is_opened:
		is_opened = true
		
		# Faz a animação
		_update_visual_state()
		
		var scene_name = get_tree().current_scene.name # atalho pro nome da cena
		# Chave de identificação do baú
		var chest_id_key = scene_name + "_" + _object_name + "_" + _chest_id
		
		# Guarda a informação no singleton, assim uma vez aberto o bau sempre vai ta aberto
		if DialogManager._dialog_list[chest_id_key].has("is_opened"):
			DialogManager._dialog_list[chest_id_key]["is_opened"] = true
		
		# Implementação de sistema de inventario
		if item_to_give:
			InventoryManager.add_item(item_to_give)
			# Aqui da pra por um sonzinho ou uma janela de aviso
		else:
			print("Aviso: O baú ", name, " foi aberto, mas não possui item configurado no Inspetor")
	
	# Chama a _interact() original da classe pai pra abrir o dialogo etc
	super._interact()
	
## -----------------------------------------------------------------------
	
# Função pra retornar a chave de acesso ao baú. Pode ser sobrescrita
func _get_dialog_key() -> String:
	var scene_name = get_tree().current_scene.name
	var chest_id_key = scene_name + "_" + _object_name + "_" + _chest_id
	return chest_id_key
	
## -----------------------------------------------------------------------

func _update_visual_state() -> void:
	if is_opened:
		_sprite.play("chest_open")
	else:
		_sprite.play("chest_idle")
