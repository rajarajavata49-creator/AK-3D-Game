extends Control

var joy_finger = -1
var jump_finger = -1
var joy_vector = Vector2.ZERO
var joy_center = Vector2.ZERO
var jump_center = Vector2.ZERO

func _ready():
    set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    joy_center = Vector2(110, size.y - 110)
    jump_center = Vector2(size.x - 110, size.y - 110)

func _draw():
    draw_circle(joy_center, 65, Color(0.2, 0.2, 0.2, 0.35))
    draw_circle(joy_center + joy_vector * 35, 28, Color(0.8, 0.8, 0.8, 0.6))
    draw_circle(jump_center, 48, Color(0.1, 0.6, 1.0, 0.5))
    draw_string(
        ThemeDB.fallback_font,
        jump_center - Vector2(17, -8),
        "JUMP",
        HORIZONTAL_ALIGNMENT_LEFT,
        -1,
        18,
        Color.WHITE
    )

func _input(event):
    if event is InputEventScreenTouch:
        if event.pressed:
            if event.position.distance_to(joy_center) < 100 and joy_finger == -1:
                joy_finger = event.index
                _update_joy(event.position)
            elif event.position.distance_to(jump_center) < 75 and jump_finger == -1:
                jump_finger = event.index
                Input.action_press("ui_accept")
        else:
            if event.index == joy_finger:
                joy_finger = -1
                joy_vector = Vector2.ZERO
                _update_actions()
            if event.index == jump_finger:
                jump_finger = -1
                Input.action_release("ui_accept")
        queue_redraw()

    elif event is InputEventScreenDrag and event.index == joy_finger:
        _update_joy(event.position)

func _update_joy(pos):
    joy_vector = (pos - joy_center).limit_length(65) / 65
    _update_actions()
    queue_redraw()

func _update_actions():
    for action in ["ui_left", "ui_right", "ui_up", "ui_down"]:
        Input.action_release(action)

    if joy_vector.x < -0.25:
        Input.action_press("ui_left")
    if joy_vector.x > 0.25:
        Input.action_press("ui_right")
    if joy_vector.y < -0.25:
        Input.action_press("ui_up")
    if joy_vector.y > 0.25:
        Input.action_press("ui_down")
