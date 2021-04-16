tool
extends KinematicBody
#variables
var G = 0.0001 #6.67408*pow(10,-11)#gravitational constant
export var direction = Vector3(0,0,0)
export var active = true
export var mass = 100000000

export var draw_orbit = true

var iterations = 2
var timestep = .016667 # ~ 1 / 60 ; delta between frames
var drawpoints = Array()

var collision = false

#draws the orbit for this particular body
#	direction = Vector3()

func _enter_tree():
	draw_orbit = true
	pass
#	active = false

func _ready():
	draw_orbit = true

#	active = true
	pass

#useless functions
#update the position and velocity
func update_position(newPosition):
	self.translation = newPosition
	
func update_velocity(newVelocity):
	self.direction = newVelocity
	
	
#func calculate_acceleration(object): #return the acceleration from this particular body
#	var acceleration = Vector3.ZERO
#	for body in object.get_children():
#		if "mass" in body:
#			var distanceToObject = (body.translation - self.translation).length_squared()# sqrDist 
#			#var distanceToObject = self.translation.distance_to(body.translation)
#			if body.mass > 0 and distanceToObject > 0:
#
#				var gravityDirection = (body.translation - self.translation).normalized()
#				#var gravitationalPull = sqrt(G*(self.mass/distanceToObject))
#				acceleration += gravityDirection * G * body.mass / distanceToObject
#	return acceleration
#Force = G *((m1 * m2) / r^2)
#the force between two bodies is G times the two masses divided by the distance between them squared


func get_pulled_towards_object(object):
	if "mass" in object and "translation" in object: #the parent node does not have "mass" and neither does the camera
		var distanceToObject = translation.distance_to(object.translation)
		if object.mass>0 and distanceToObject>0:
			var gravitationalPull = sqrt(G*(object.mass/distanceToObject))
			
			var gravityDirection = (object.translation-translation).normalized()
			direction+=gravityDirection*gravitationalPull
			
			collision = move_and_collide(direction)
			if collision != null:
				direction-=collision.remainder*100

	for obj in object.get_children():
		get_pulled_towards_object(obj)


func _physics_process(delta):
	pass
	#drawOrbit()
#	drawOrbit()
#	if active:
#		get_pulled_towards_object(get_parent(), delta)
