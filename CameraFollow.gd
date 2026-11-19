extends Camera3D

@export var target: Node3D
@export var follow_speed: float = 5.0

func _process(delta):
    if target == null:
        return

    var target_position = target.global_position + Vector3(0, 7, 10)

    global_position = global_position.lerp(
        target_position,
        follow_speed * delta
    )

    look_at(target.global_position, Vector3.UP)
