extends CanvasLayer


var max_life: Button
var attack: Button

var max_life_price: Label
var attack_price: Label


func _ready() -> void:
	GameManager.hud_visibility(true)
	max_life = get_node("Control/MaxLife/ItemMaxLife")
	attack = get_node("Control/Attack/ItemAttack")
	
	max_life_price = get_node("Control/MaxLife/Price/TextPrice")
	attack_price = get_node("Control/Attack/Price/TextPrice")
	
	GameManager.change_reset_store.connect(reset_items)


func _on_item_max_life_pressed() -> void:
	if GameManager.coins >= int(max_life_price.text):
		AudioManager.play_sound("casher_register.mp3", 0.0, false, 0.0, 0.4)
		GameManager.MAX_PLAYER_LIFE += 2
		GameManager.player_life += 2
		max_life.disabled = true
		max_life.visible = false
		GameManager.coins -= int(max_life_price.text)


func _on_item_attack_pressed() -> void:
	if GameManager.coins >= int(max_life_price.text):
		AudioManager.play_sound("casher_register.mp3", 0.0, false, 0.0, 0.4)
		GameManager.player_attack += 1
		attack.disabled = true
		attack.visible = false
		GameManager.coins -= int(max_life_price.text)


func reset_items() -> void:
	max_life.disabled = false
	max_life.visible = true
	
	attack.disabled = false
	attack.visible = true


func _on_close_shop_pressed() -> void:
	GameManager.store_visibility(false)
