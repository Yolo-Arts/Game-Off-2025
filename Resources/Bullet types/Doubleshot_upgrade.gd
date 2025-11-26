extends cannon_ball_upgrade
class_name double_shot

var spread = 20.0
var packed_scene = PackedScene.new()
var cannonballs_array = []

func apply_cannonball_upgrade(Cannonball_scene):
	
	var cannonball_shot = Cannonball_scene.instantiate()
	var new_cannonball = Cannonball.new()
	new_cannonball.set_owner(cannonball_shot)
	cannonball_shot.add_child(new_cannonball)
	
	cannonballs_array = cannonball_shot.get_cannonballs()
	cannonballs_array[0].position += Vector2(0,spread)
	cannonballs_array[1].position -= Vector2(0,spread)
	
	packed_scene.pack(cannonball_shot)
	
	var test = packed_scene.instantiate()
	var test2 = test.get_cannonballs()
	
	return packed_scene
	
	
	
