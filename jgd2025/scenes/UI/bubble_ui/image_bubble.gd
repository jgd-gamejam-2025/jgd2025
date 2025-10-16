extends HBoxContainer

@onready var texture: TextureRect = %TextureRect
@onready var anim_player: AnimatedSprite2D = %Sticker

func set_sticker(anim_name: String):
	anim_player.animation = anim_name
	anim_player.show()
	anim_player.play()
	texture.hide()

func set_texture(texture: Texture):
	texture.texture = texture
	texture.show()
	anim_player.hide()
