extends Node2D

var times := []
var fps := 0.0
var last_update := -1


func _input(event):
    if event is InputEventKey:
        if event.is_action_pressed("ui_toggle_fullscreen"):
            print("Toggeling fullscreen")
            OS.window_fullscreen = !OS.window_fullscreen
        if event.is_action_pressed("ui_toggle_mouse"):
            print("Toggeling mouse")
            var mouse_mode := Input.get_mouse_mode()
            if mouse_mode == Input.MOUSE_MODE_CAPTURED:
                Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
                get_tree().paused = true
            else:
                Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
        if event.scancode == KEY_F12 and not event.echo:
            $World/AccumWorldViewport.get_texture().get_data().save_png("all_visibility.png")
            $World/ShadowWorldViewport.get_texture().get_data().save_png("cur_visibility.png")
            print("Saved visibility")


func _process(delta):

    # A bit more precise FPS measurement than Engine.get_frames_per_second()
    var now := OS.get_ticks_msec()
    times.append(now)
    while times.size() > 60:
        times.pop_front()

    delta = (times[-1] - times[0]) * 0.001
    if delta != 0:
        fps = times.size() / delta
    
    var player_pos = $Player.position
    
    if last_update == -1 or now - last_update > 200:
        $CanvasLayer/MarginContainer/VBoxContainer/FpsLabel.text = "%.1f %.1f %.1f" % [player_pos.x, player_pos.y, fps]
        last_update = now
        
    if get_tree().paused:
        $CanvasLayer/MarginContainer/VBoxContainer/PauseLabel.text = "PAUSED"
    else:
        $CanvasLayer/MarginContainer/VBoxContainer/PauseLabel.text = "RUNNING"
