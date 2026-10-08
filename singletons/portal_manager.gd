extends Node
class_name PortalManagerClass # Tentei colocar PortalManager mas ele n deixou
# Aparentemente é pq ja tem um singleton com p nome PortalManager mas n sei pq isso eh problema

var target_position: Vector2 # variavel global que vai ser usada em map_end.gd
var last_facing_direction : Vector2 = Vector2.DOWN # Armazena a direção do player antes do teleporte
# (Inicializada como pra baixo)
var spawn_facing_direction : Vector2 = Vector2.DOWN
