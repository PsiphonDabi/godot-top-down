extends CanvasLayer

@onready var item_grid: GridContainer = $ItemGrid
@onready var cursor: Sprite2D = $Cursor

## -----------------------------------------------------------------------

const ITEM_SLOT_SCENE = preload("res://scenes/item_slot.tscn")

## -----------------------------------------------------------------------

func _ready() -> void:
	_populate_inventory()
	
	# Pega todos os filhos do grid que são botões/slots e dá foco no primeiro
	var slots = item_grid.get_children()
	if slots.size() > 0:
		slots[0].grab_focus()
		
## -----------------------------------------------------------------------

func _process(delta: float) -> void:
	# Encontra qual botão/slot está com foco atualmente no jogo
	var focused_control = get_viewport().gui_get_focus_owner() # kkkk what
	
	# Se o foco atual estiver dentro do nosso inventário, move o cursor até ele
	if focused_control and focused_control.get_parent() == item_grid:
		# Posiciona o cursor pixel art ao lado do slot selecionado
		cursor.global_position = focused_control.global_position + Vector2(-16, 8)
		
## -----------------------------------------------------------------------
		
# É aqui que ocorre a listagem dos itens do InventoryManager
func _populate_inventory() -> void:
	# Limpa os slots antigos da tela
	for child in item_grid.get_children():
		child.queue_free()
		
	# Cria um slot visual para cada item que o jogador possui no inventário global
	for item in InventoryManager.items:
		var slot = ITEM_SLOT_SCENE.instantiate()
		item_grid.add_child(slot)
		
		# Preenche o nome do item no slot recém-criado
		slot.set_item_data(item)
		
## -----------------------------------------------------------------------
		
func _unhandled_input(event: InputEvent) -> void:
	# Se apertar Esc ou a tecla de voltar/cancelar
	if event.is_action_pressed("ui_cancel"):
		queue_free() # Destrói a cena do inventário e some da tela
