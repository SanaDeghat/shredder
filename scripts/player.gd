extends CharacterBody2D


const SPEED = 300.0
const DOWN_SPEED = 1900.0
const RISE_SPEED = 2400.0  
const JUMP_HEIGHT = 460.0

var rising := false
var jump_target_y := 0.0

func get_gravity_local():
	return get_gravity()*4

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("up_key") and is_on_floor():
		rising = true
		jump_target_y = position.y - JUMP_HEIGHT

	if Input.is_action_just_pressed("down_key"):
		rising = false
		velocity.y = DOWN_SPEED

	if rising:
		var remaining := position.y - jump_target_y
		velocity.y = -min(RISE_SPEED, remaining / delta)
		if remaining <= 0.5 or is_on_ceiling():
			rising = false
			velocity.y = 0.0
	elif not is_on_floor():
		velocity += get_gravity_local() * delta

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
