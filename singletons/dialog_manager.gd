extends Node
class_name DialogManagerClass

var _dialog_list : Dictionary = {
	
	"angel": {
		
		"current_dialog": "first_dialog",
		
		"first_dialog": {
			0: {
				"picture": "res://assets/characters/pictures/maple_emote_2.png",
				"type": "message",
				"text": "Maple:
					Lumia! Você tá aqui!"
			},
			
			1: {
				"picture": "res://assets/characters/pictures/angel_emote_4.png",
				"type": "message",
				"text": "Lumia:
					Maple! Que bom te ver!"
			},
			
			2: {
				"picture": "res://assets/characters/pictures/maple_emote_2.png",
				"type": "message",
				"text": "Maple:
					Cê pintou o cabelo?"
			},
			
			3: {
				"picture": "res://assets/characters/pictures/maple_emote_5.png",
				"type": "message",
				"text": "Maple:
					Tá bem legal em você!"
			},
			
			4: {
				"picture": "res://assets/characters/pictures/angel_emote_3.png",
				"type": "message",
				"text": "Lumia:
					Ah, na verdade esse é só um design novo.
					Meu visual ainda está passando por uns testes."
			},
			
			5: {
				"picture": "res://assets/characters/pictures/maple_padrao.png",
				"type": "message",
				"text": "Maple:
					Tendi! Espero que você fique pronta logo, então."
			},
			
			6: {
				"picture": "res://assets/characters/pictures/maple_emote_3.png",
				"type": "message",
				"text": "Maple:
					Mal posso esperar pra gente sair juntas!
					A gente se ve por aí!"
			},
			
			7: {
				"picture": "res://assets/characters/pictures/angel_teste.png",
				"type": "message",
				"text": "Lumia:
					Eu também! Se cuida, ok?"
			},
			
		},
		
		"second_dialog": {
			0: {
				"picture": "res://assets/characters/pictures/angel_teste.png",
				"type": "message",
				"text": "Lumia:
					Se cuida, ok?"
			}
			
		}
		
	},

	"chest_item": {
		
		"current_dialog": "first_dialog",
		
		"is_opened": false,
		
		"stored_id": "",
		
		"first_dialog": {
			0: {
				"picture": "",
				"type": "message",
				"text": "Você pegou um item!"
			},
			
		},
		
		"second_dialog": {
			0: {
				"picture": "",
				"type": "message",
				"text": "Não tem mais nada aqui!"
			}
			
		}
		
	}
	
}
