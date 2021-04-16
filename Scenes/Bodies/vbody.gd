tool
extends KinematicBody
#variables
var G = 6.67408*pow(10,-11)#gravitational constant
export var direction = Vector3(0,0,0)
export var active = true
export var mass = 100000000

var draw_orbit = false
var timestep = .016667  # = 1 / 60 frames per second
var drawpoints = Array()

func _enter_tree():
	draw_orbit = false
	pass
#	active = false

func _ready():
	draw_orbit = false

	pass

	
	
#Force = G *((m1 * m2) / r^2)
#the force between two bodies is G times the two masses divided by the distance between them squared


func get_pulled_towards_object(object):
	if "mass" in object and "translation" in object:#the parent does not have "mass"
		var distanceToObject = translation.distance_to(object.translation)
		if object.mass>0 and distanceToObject>0:
			var gravitationalPull = sqrt(G*(object.mass/distanceToObject))
			
			var gravityDirection = (object.translation-translation).normalized()
			direction+=gravityDirection*gravitationalPull
			
			var collision = move_and_collide(direction*timestep)
			if collision != null:
				direction-=collision.remainder*100

	for obj in object.get_children():
		get_pulled_towards_object(obj)




func _physics_process(delta):
	pass
#	drawOrbit()
#	if active:
#		get_pulled_towards_object(get_parent(), delta)
