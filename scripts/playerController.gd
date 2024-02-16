extends CharacterBody2D

#region Player animation
@onready var texture = $Texture

func _on_texture_animation_looped():
	if texture.animation == "jump":
		texture.play("falling")
#endregion

#region Physics Constants
const SPEED = 100.0
const RUN_SPEED = 300.0

const JUMP_VELOCITY = -400.0
const JUMP_HOLD_VELOCITY = -50.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#endregion

var t = 0.0

#region Physics Movement Loop
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Input.is_action_pressed("player_left"):
		texture.flip_h = true
	elif Input.is_action_pressed("player_right"):
		texture.flip_h = false
	
	if not is_on_floor() and texture.animation != "jump":
		texture.play("falling")
	
	var direction = Input.get_axis("player_left", "player_right")
	if direction:
		velocity.x = direction * SPEED

		if(Input.is_action_pressed("player_sprint")):
			velocity.x = direction * RUN_SPEED
		
		if is_on_floor() and not texture.animation == "jump":
			if(Input.is_action_pressed("player_sprint")):
				texture.play("run")
			else:
				texture.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor() and not texture.animation == "jump":
			texture.play("idle")
	
	# Handle jump.
	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		texture.play("jump")
	
	if Input.is_action_just_pressed("player_jump") and not is_on_floor():
		velocity.y += JUMP_HOLD_VELOCITY
	
	$Camera.position = $Camera.position.lerp(-velocity*0.2, 0.1)
	
	move_and_slide()
#endregion
