# como assim se player in range nao é bool?
# ??? como assim if animationtree
extends CharacterBody2D
class_name PlayerBase

##VARIAVEIS COMUNS
## -----------------------------------------------------------------------

var _state_machine
var esta_atacando = false
var portal_entered = false # checa se o player encostou no teleporte ou nao
var last_input_direction: Vector2 = Vector2.DOWN

## -----------------------------------------------------------------------


# VARIAVEIS E CATEGORIAS PARA INSPETOR
## -----------------------------------------------------------------------

@export_category("Variables")
@export var speed : float = 90.0

@export_category("Objects")
@export var _animation_tree : AnimationTree = null
@export var _sprite : Sprite2D

## -----------------------------------------------------------------------


## READY (SÓ READY (??))
## -----------------------------------------------------------------------

func _ready():
	_animation_tree.active = true
	_state_machine = _animation_tree["parameters/playback"]
	
	# Verifica se a variavel global de posição do PortalManager ta como (0,0)
	# ou seja, se foi ou não modificada (pelo que eu entendi)
	if PortalManager.target_position == Vector2(0,0):
		return
	# Sem essa condição o player sempre spawna em (0,0) por causa da linha abaixo
	global_position = PortalManager.target_position
	# Faz sentido ja que na script  portal_manager a posição é inicializada como (0,0)
	
	# Recupera a direção do player sempre q carrega nova cena (note que é o processo inverso da enter_portal()
	last_input_direction = PortalManager.last_facing_direction
	
	# Atualiza os blend positions da AnimationTree para o estado Idle (e Walk, se necessário)
	_update_animation_blend_positions(PortalManager.spawn_facing_direction)
	
## -----------------------------------------------------------------------
	
	
## MOVIMENTAÇÃO DO PLAYER
## -----------------------------------------------------------------------

func _physics_process(_delta: float) -> void:
	# Se estiver entrando no portal, ignora a movimentação normal e trava em idle
	if portal_entered:
		velocity = Vector2.ZERO
		_animate() # ou garante que a animação continue atualiando
		move_and_slide()
		return
	
	_move()
	_animate()
	# move_and_slide ja aplica o delta automaticamente
	move_and_slide()

func _move():
	var input_direction = Vector2.ZERO
	
	if esta_atacando:
		return
	
	# pega um input com um vetor
	input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# chegando o movimento pra rodar animação
	if input_direction != Vector2.ZERO:
		_animation_tree["parameters/idle/blend_position"] = input_direction
		_animation_tree["parameters/walk/blend_position"] = input_direction
		_animation_tree["parameters/attack/blend_position"] = input_direction
		
	# normaliza para nao andar mais rapido na diagonal
	velocity = input_direction.normalized() * speed
		
	if input_direction != Vector2.ZERO:
		last_input_direction = input_direction # Atualiza a última direção ativa
				
func _attack():
	esta_atacando = true
	_state_machine.travel("attack")
	
func finalizar_ataque():
	esta_atacando = false
	set_physics_process(true)
	_state_machine.travel("idle")
	
func _animate():
	if velocity.length() > 1:
		_state_machine.travel("walk")
	else:
		_state_machine.travel("idle")
	
	if Input.is_action_just_pressed("attack"):
		set_physics_process(false)
		_attack()
		
# Função que checa se o inimigo está na área de ataque
func _on_attack_area_body_entered(_body) -> void:
	if _body.is_in_group("enemy"):
		_body.update_health(randi_range(1, 5))
		
## -----------------------------------------------------------------------

		
## TELEPORTE ENTRE CENAS
## -----------------------------------------------------------------------

# Função que ativa quando o player entra num portal de cena pra outra
func enter_portal() -> void:
	
	# Para o player
	portal_entered = true
	velocity = Vector2.ZERO # pq duas vezes?
	
	# Salva a última direção do player no singleton do portal
	PortalManager.last_facing_direction = last_input_direction
	
	# Vai pro estado idle
	if _state_machine:
		_state_machine.travel("idle")
		
# Função que atualiza os parâmetros de animação para a direção que o jogador inputa
func _update_animation_blend_positions(direction: Vector2) -> void:
	
	if direction == Vector2.ZERO:
		return
		
	# Exemplo de atualização de parâmetros de blend position na AnimationTree:
	$AnimationTree.set("parameters/idle/blend_position", direction)
	$AnimationTree.set("parameters/walk/blend_position", direction)

## -----------------------------------------------------------------------
	
	
