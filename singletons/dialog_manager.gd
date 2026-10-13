extends Node
class_name DialogManagerClass

var _dialog_list : Dictionary = {
	
	"angel": {
		
		"picture": "res://assets/characters/pictures/maple_padrao.png",
		
		"current_dialog": "first_dialog",
		
		"first_dialog": {
			0: {
				"type": "message",
				"text": "Dialogo teste"
			},
			
			1: {
				"type": "message",
				"text": "Dialogo teste 2"
			}
		},
		
		"second_dialog": {
			0: {
				"type": "message",
				"text": "Teste3."
			}
			
		}
		
	}

}
