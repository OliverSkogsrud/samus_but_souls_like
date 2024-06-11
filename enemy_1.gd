extends Area2D

var health = 30

var dead = false

@onready var anims = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if health <= 0:
		anims.play("Death")
		dead = true
		
	
	

func takeDamage(damage):
	health -= damage
	print(health)


func _on_animated_sprite_2d_animation_finished():
	if anims.animation == "Death":
		queue_free()

