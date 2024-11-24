extends Node2D

@onready var npc: AnimatedSprite2D = $npc
@onready var message_box: Sprite2D = $npc/MessageBox
@onready var message: Label = $npc/MessageBox/message

func  _ready() -> void:
	npc.play("talk")

#func _on_text_changed(new_text: String) -> void:
	#animate_message_box()
#
#func animate_message_box() -> void:
	#var tween = get_tree().create_tween()
	#tween.tween_property(message_box, "scale", Vector2(0.6, 0.6), 0.3)
	#tween.set_trans(Tween.TRANS_SINE)
	#tween.set_ease(Tween.EASE_OUT)
#
	#tween.tween_property(message_box, "scale", Vector2(0.527, 0.51), 0.3)
	#tween.set_trans(Tween.TRANS_SINE)
	#tween.set_ease(Tween.EASE_IN)
