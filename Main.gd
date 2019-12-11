extends Node2D

var times := []
var fps := 0.0
var last_update := -1


func _input(event):
    if event is InputEventKey:
        if event.is_action_pressed("ui_toggle_fullscreen"):
            print("Toggeling fullscreen")
            OS.window_fullscreen = !OS.window_fullscreen


func _process(delta):

    # A bit more precise FPS measurement than Engine.get_frames_per_second()
    var now := OS.get_ticks_msec()
    times.append(now)
    while times.size() > 60:
        times.pop_front()

    delta = (times[-1] - times[0]) * 0.001
    if delta != 0:
        fps = times.size() / delta
    
    if last_update == -1 or now - last_update > 200:
        $Player/Camera2D/FpsLabel.text = "%.1f" % fps
        last_update = now
