class_name CameraZoom_StatUp
extends Statup

@export var zoom_decrement: float = 0.1
@export var min_zoom_limit: float = 0.3 

func apply_upgrade(player: Player):
	var camera = Globals.camera
	
	if not camera:
		camera = player.get_viewport().get_camera_2d()
	
	if camera:
		var zoom_change = Vector2(zoom_decrement, zoom_decrement)
		if "normal_zoom" in camera:
			camera.normal_zoom -= zoom_change
			
			camera.normal_zoom.x = max(camera.normal_zoom.x, min_zoom_limit)
			camera.normal_zoom.y = max(camera.normal_zoom.y, min_zoom_limit)
			
			if "max_zoom_in" in camera:
				camera.max_zoom_in = camera.normal_zoom + Vector2(0.15, 0.15)
			if "max_zoom_out" in camera:
				camera.max_zoom_out = camera.normal_zoom - Vector2(0.05, 0.05)
			var tween = player.create_tween()
			tween.tween_property(camera, "zoom", camera.normal_zoom, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			
			print("Upgrade Applied: New Normal Zoom is ", camera.normal_zoom)
			
		else:
			var new_zoom = camera.zoom - zoom_change
			new_zoom.x = max(new_zoom.x, min_zoom_limit)
			new_zoom.y = max(new_zoom.y, min_zoom_limit)
			
			var tween = player.create_tween()
			tween.tween_property(camera, "zoom", new_zoom, 0.5)
	else:
		print("Error: No Camera found to zoom!")
