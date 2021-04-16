extends Camera


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var focus = get_parent().get_node("Real/Sun")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	self.translation.x = focus.translation.x
	self.translation.z = focus.translation.z
	self.translation.y = focus.translation.y + 100
#	pass
