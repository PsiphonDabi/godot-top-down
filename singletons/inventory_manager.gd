extends Node

var items : Array[ItemData] = [] # Uma lista simples guardando os itens que o player tem

func add_item(item : ItemData) -> void:
	items.append(item)
	print("Item coletado: ", item.item_name)

func remove_item(item : ItemData) -> void:
	if items.has(item):
		items.erase(item)
