# EXPLICAR
extends Button

@onready var name_label: Label = $ItemName

# Configura o texto do slot com base no item recebido
func set_item_data(item: ItemData) -> void:
	if item:
		name_label.text = item.item_name
		visible = true
	else:
		name_label.text = ""
		visible = false
