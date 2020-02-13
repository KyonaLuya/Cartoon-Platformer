extends KinematicBody2D


# Declare member variables here. Examples:
var velocity : Vector2
var jump_timer
var time_off_floor
var time_since_jump
var facing

const SPEED := 500.0
const GRAVITY := 5000.0
const JUMP_BOOST := 3000.0
const JUMP_TIME := 0.255
const JUMP_VELOCITY := 1050.0
const EDGE_FORGIVENESS := .1
const JUMP_LOCK := .2
const TERMINAL_VELOCITY := 5000

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector2(0, 0)
	jump_timer = 0
	time_off_floor = 0
	time_since_jump = 0
	facing = "left"


func initial_jump():
	velocity.y = -JUMP_VELOCITY
	time_since_jump = 0

func extend_jump(delta):
	jump_timer += delta
	if jump_timer < JUMP_TIME:
		velocity.y -= JUMP_BOOST * delta
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.x = 0
	if velocity.y < TERMINAL_VELOCITY:
		velocity.y += GRAVITY * delta
	time_since_jump += delta
	if Input.is_action_pressed("ui_right"):
		velocity.x += SPEED
		facing = "right"
	if Input.is_action_pressed("ui_left"):
		velocity.x -= SPEED
		facing = "left"
		
	if Input.is_action_pressed("ui_up"):
		extend_jump(delta)
	if is_on_floor():
		jump_timer = 0
		velocity.y = 0
		time_off_floor = 0
		time_since_jump = 0
	else:
		time_off_floor += delta
	if Input.is_action_pressed("ui_up") and time_off_floor < EDGE_FORGIVENESS and time_since_jump < JUMP_LOCK:
		initial_jump()
	
	move_and_slide(velocity, Vector2(0, -1))
		
