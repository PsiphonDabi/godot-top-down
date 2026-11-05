extends CanvasLayer

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var resume: TextureButton = $BackgroundOverlay/MenuHolder/Resume
@onready var item_button: TextureButton = $BackgroundOverlay/MenuHolder/Item
@onready var quit: TextureButton = $BackgroundOverlay/MenuHolder/Quit

## -----------------------------------------------------------------------

# Carrega a cena do inventário para poder usá-la depois
const INVENTORY_SCENE = preload("res://scenes/inventory_menu.tscn")

## -----------------------------------------------------------------------

var menu_is_opened : bool = false # Guarda se o menu esta aberto ou não
var inventory_instance: Node = null # Guarda a referência da janela de inventário aberta
# Essa variável guarda o "espaço" (referência) da janela de inventário quando ela ta ativa na tela

## -----------------------------------------------------------------------

func _ready() -> void:
	visible = false
	
## -----------------------------------------------------------------------
	
# Função de input para gerenciar o uso do esc ou teclas análogas de cancel
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		
		# CASO 1: Se o inventário tiver aberto o esc fecha APENAS o inventário e volta pro pause
		if inventory_instance and is_instance_valid(inventory_instance):
			# Só vai fechar o inventario se ele exisrir e tiver ativo naquele momento
			
			# if inventory_instance: checa se ta null (se o iventario foi aberto ou nao)
			
			# if is_instance_valid(inventory_instance): No Godot, às vezes um nó pode ser
			# deletado da tela (por exemplo, se algo destruiu ele antes), mas a variável
			# ainda continua guardando um "endereço fantasma" na memória.
			# Essa função integrada do Godot verifica se o objeto ainda existe de verdade
			# na árvore do jogo e não foi destruído ou corrompido.
			
			inventory_instance.queue_free() # Deleta a cena de inventário
			inventory_instance = null # Limpa a variável
			
			# Faz o menu de pause aparecer de novo na tela
			self.visible = true
			
			# Devolve o foco para o botão de itens do pause menu
			item_button.grab_focus()
			
			# "Consome" o evento para ele não fechar o pause junto
			get_viewport().set_input_as_handled()
			
			# O Viewport é a "janela" ou a área visual onde o seu jogo está sendo
			# renderizado e onde os eventos de entrada (teclado, mouse, controle)
			# chegam primeiro. Esse comando pega o viewport atual para que você
			# possa dar ordens diretas a ele sobre como lidar com o que está acontecendo na tela
			
			# set_input_as_handled(): trata a entrada (nesse caso o esc) como resolvida
			
			# Sem essa linha, apertando esc para fechar o inventário, o mesmo
			# esc continuaria viajando pelo sistema do jogo e bagunçando outros comandos
			# (como tentar abrir ou fechar o menu de pause ao mesmo tempo). Com ela, você
			# garante que o Esc fechou apenas o inventário e parou ali, sem efeitos colaterais
			
			return
		
		# CASO 2: Abrir e fechar menu normal, sem inventario
		if menu_is_opened == true:
			# Lógica do resume game
			menu_is_opened = false # Avisa que fechou o menu
			animator.play("resume_game") # Toca animação de resume
			get_tree().paused = false # Despausa o game
			await animator.animation_finished # Espera a animação termianr
			visible = false # Deixa a cena de menu invisivel
		else:
			# Lógica do pause game
			menu_is_opened = true # Avisa que abriu o menu
			visible = true # Deixa a cena visivel
			animator.play("pause_game") # Toca a animação de pause
			get_tree().paused = true # Pausa i game
			resume.grab_focus() # Deixa o seletor de botões encima do resume já de início
			
## -----------------------------------------------------------------------
	
func _on_resume_pressed() -> void:
	menu_is_opened = false # Avisa que fechou o menu
	animator.play("resume_game") # Toca animação de resume
	get_tree().paused = false # Despausa o game
	await animator.animation_finished # Espera a animação termianr
	visible = false # Deixa a cena de menu invisivel
	
## -----------------------------------------------------------------------

func _on_item_pressed() -> void:
	# Só abre se já não houver um inventário aberto
	if not inventory_instance:
		# Instancia a cena do inventário
		inventory_instance = INVENTORY_SCENE.instantiate()
		
		# Adiciona a cena como filha da cena atual (aparecendo na tela de pause)
		get_tree().current_scene.add_child(inventory_instance)
		
		# Esconde o menu de pause principal enquanto o inventário estiver aberto
		self.visible = false
		
## -----------------------------------------------------------------------

func _on_quit_pressed() -> void:
	menu_is_opened = false # Só por precaução
	get_tree().quit()
