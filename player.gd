extends CharacterBody2D


@onready var collision1 = $Area2D/CollisionShape2D

var canJump = true

var isrolling = false

var SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var damage = 10

@onready var anims = $Anims

var isAttacking = false

var slashSequence = 0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		anims.play("Jump")
		
	if isAttacking == true or isrolling:
		canJump = false
	else:
		canJump = true
		
		
	if isrolling == true:
		anims.play("roll")
	
			
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("w"):
		if canJump == true:
			if is_on_floor():
				velocity.y = JUMP_VELOCITY
				
			
		#turn hitbox
	if anims.flip_h == true:
		collision1.position = Vector2(-19, 11)
			
	if anims.flip_h == false:
		collision1.position = Vector2(19, 11)
	
	
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	#rolling
	var direction = Input.get_axis("a", "d")
	if Input.is_action_just_pressed("Q"):
			if not isAttacking:
				if is_on_floor():
					if not isrolling:
						isrolling = true
						anims.position.y = 7
						SPEED = 350 
						velocity.x = direction * SPEED
						if velocity.x == 0:
							if anims.flip_h == true:
								velocity.x = -SPEED
							if anims.flip_h == false:
								velocity.x = SPEED

	
	
	if direction:
		if direction == 1:
			anims.flip_h = false
			
		if direction == -1:
			anims.flip_h = true
			
		if not isrolling:
			velocity.x = direction * SPEED
		
		
		if isAttacking == false and is_on_floor() and isrolling == false:
			anims.play("Run")
			
		if not is_on_floor() and not isrolling:
			anims.play("Jump")
	else:
		if not isrolling:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if isAttacking == false and is_on_floor() and not isrolling:
			anims.play("Idle")


		if not is_on_floor() and isrolling == false:
			anims.play("Jump")
			
		
	move_and_slide()
	
	
func _unhandled_input(_event):
	if Input.is_action_just_pressed("Attack"): 
		if isAttacking == false and isrolling == false:
			if is_on_floor():
				
				$Area2D.set_deferred("monitoring", true)
				
				isAttacking = true
			
				if isAttacking:
					if slashSequence == 0:
						anims.play("Slash1")
					if slashSequence == 1:
						anims.play("Slash2")
					if slashSequence == 2:
						slashSequence = 0
						anims.play("Slash1")
			
				collision1.disabled = false
			
			print("Attack")


func _on_anims_animation_finished():
	if anims.animation == "Slash1" or "Slash2":
			slashSequence += 1
			collision1.disabled = true
			isAttacking = false
			
	if anims.animation == "roll":
		anims.position.y = 0
		isrolling = false
		SPEED = 300.0
		
		


func _on_area_2d_area_entered(area):
	if area.is_in_group("Enemy"):
		area.takeDamage(damage)
		$Area2D.set_deferred("monitoring", false)
			
