extends Camera2D

var target : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_target()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position = target.position

func get_target(): # nao sei sei o _ no comeco da funcao influencia nesse caso
	var nodes = get_tree().get_nodes_in_group("Player")
	if nodes.size() == 0: # nao achou o player na cena
		push_error("Player not found")
		return
		
	target = nodes[0]
