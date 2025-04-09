extends Node

var vida_personaje: int = 100
var vida_personaje_maxima: int = 100
var ataque_personaje: float = 1.0
var velocidad_personaje: float = 170.0
var defensa_personaje: float = 1.0
var cooldown_disparo: float = 1.0
var cooldown_garra: float = 0.5
var recuperacion: int

func _process(delta: float) -> void:
	recuperacion = vida_personaje_maxima/3

var coins: int = 0
var xp: int = 0
