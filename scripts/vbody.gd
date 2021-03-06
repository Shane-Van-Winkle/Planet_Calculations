tool
extends KinematicBody
#variables
var G = 6.67408*pow(10,-11)#gravitational constant
export var direction = Vector3(0,0,0)
export var active = true
export var mass = 100000000

export var draw_orbit = true

var iterations = 2
var timestep = .1
var drawpoints = Array()

#draws the orbit for this particular body
func drawOrbit(): #only draw if it is the editor
	draw_orbit = true
	if draw_orbit == true:
#		drawpoints.clear()
		#simulate iterations
		for i in iterations:
		
#			#update the direction
##			for vbody in self.get_parent().get_children():
			direction += calculate_acceleration(get_parent().get_children()) * timestep
			
#			print(self.get_name())
#			print(direction)
#			#update the position
##			for vbody in self.get_parent().get_children():
##			move_and_collide(direction)
#			var newPosition = translation +  direction * timestep
#			translation = newPosition
							#update the direction
#			for vbody in self.get_parent().get_children():
			#print(self.get_name(), " ",  i)

			#update the position
#			for vbody in self.get_parent().get_children():
			var newPosition = translation + direction 
			translation = newPosition
			#everything else is for drawing relative to a central body
#			drawpoints.append(newPosition)
			#draw the line
			
		
#		var lr = get_node("LineRenderer")
#		lr.clear()
#		lr.begin(Mesh.PRIMITIVE_LINE_STRIP)
#		for point in drawpoints:
#			print("FLIP")
#			lr.add_vertex(point)
#		lr.end()
	drawpoints.clear()
	draw_orbit = false
	direction = Vector3()

func _enter_tree():
	pass
#	active = false

func _ready():
	draw_orbit = true
#	active = true
	pass

	
func set_direction(newDir):
	direction = newDir
	
#Force = G *((m1 * m2) / r^2)
#the force between two bodies is G times the two masses divided by the distance between them squared

#split into two functions:
	#calcuate acceleration
	#update position
	

func get_pulled_towards_object(object, delta):
	if "mass" in object and "translation" in object: #only use bodies effected by physics in case of other objects
		var distanceToObject = translation.distance_to(object.translation)
		if object.mass > 0 and distanceToObject > 0: #divide by zero or rooting a negative number
			var gravitationalPull = sqrt(G * (object.mass / distanceToObject))
			
			var gravityDirection = (object.translation-translation).normalized()
			direction+=gravityDirection*gravitationalPull
			
			var collision = move_and_collide((direction) * (delta))
			if(collision != null):
				direction -= collision.remainder * 100
			
	for obj in object.get_children():
		get_pulled_towards_object(obj, delta)
		
#this function calculates the acceleration of a specific body
#given an array of all other bodies and a specific body 

#just have a for loop externally with self.get_children() as the thing
#use a for loop in the physics process


func calculate_acceleration(vbodies):
	var acceleration = Vector3()
	for j in vbodies:
			var distanceToObject = translation.distance_to(j.translation)
			if j.mass > 0 and distanceToObject > 0: #divides by zero if the vbody is itself
				var gravitationalPull = sqrt(G * (j.mass / distanceToObject))
	
				var gravityDirection = (j.translation - translation).normalized()
				acceleration += gravityDirection * gravitationalPull
	return acceleration
#			var collision = move_and_collide((direction) * (delta))
#			if(collision != null):
#				direction-=collision.remainder*100

#the old one did not care about being against this body
func calculate_acceleration2(vbodies):

	var acceleration = Vector3()
	var distanceToObject = translation.distance_to(vbodies.translation)
	if vbodies.mass > 0 and distanceToObject > 0: #divide by zero or rooting a negative number
		var gravitationalPull = sqrt(G * (vbodies.mass / distanceToObject))
			
		var gravityDirection = (vbodies.translation-translation).normalized()
		acceleration += gravityDirection * gravitationalPull
		return acceleration
		var collision = move_and_collide((direction) * (timestep))
		if(collision != null):
			direction-=collision.remainder*100

	for vbody in vbodies.get_children():
		calculate_acceleration2(vbodies)




func _physics_process(delta):
	drawOrbit()
#	if active:
#		get_pulled_towards_object(get_parent(), delta)
