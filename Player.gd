extends Area2D

#user-defined signal: `hit`
#emitted when the player collides with an enemy
signal hit

#export: Visible in the inspector
export var speed = 400
var screen_size

#holds the click position
var target = Vector2()

# Called when the node enters the scene tree 
#for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()
	
# Called when the input event occurs
func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target = event.position

#' this will be called for every frame
#' delta is the elapsed time
func _process(delta):
	var velocity = Vector2() #Player's movement vector.
	
	if position.distance_to(target) > 10:
		velocity = target - position
	
#	if Input.is_action_pressed("ui_right"):
#		velocity.x += 1
#	if Input.is_action_pressed("ui_left"):
#		velocity.x -= 1
#	if Input.is_action_pressed("ui_up"):
#		velocity.y -= 1
#	if Input.is_action_pressed("ui_down"):
#		velocity.y += 1

	if(velocity.length() > 0):
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	#if the player is moving left, or right
	if velocity.x != 0:
		#use walk animation for the sprite
		$AnimatedSprite.animation = "walk"
		#no vertical flipping
		$AnimatedSprite.flip_v = false
		#flip the sprite horizontally if going left
		$AnimatedSprite.flip_h = velocity.x < 0
	#if the player is moving up or down
	elif velocity.y != 0:
		#use up animation for the sprite
		$AnimatedSprite.animation = "up"
		#flip the sprite vertically if going down
		$AnimatedSprite.flip_v = velocity.y > 0
	


func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	
	#Initial target is start position
	target = pos
	
	show()
	$CollisionShape2D.disabled = false
