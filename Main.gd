extends Node

export (PackedScene) var Mob

var score

func _ready():
	randomize()

func game_over():
	$Music.stop()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$GameOverSound.play()
	
	#Here, call_group calls queue_free method to every node in the group named mobs
	get_tree().call_group("mobs", "queue_free")

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")
	$Music.play()

func _on_StartTimer_timeout():
	$ScoreTimer.start()
	$MobTimer.start()

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)
func _on_MobTimer_timeout():
	$MobPath/MobSpawnLocation.offset = randi()
	#create a mob instance
	var mob = Mob.instance()
	add_child(mob)
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	
	#Location of mob
	mob.position = $MobPath/MobSpawnLocation.position	
	#Direction of mob
	direction += rand_range(-PI/4, PI/4)
	mob.rotation = direction
	
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
	
