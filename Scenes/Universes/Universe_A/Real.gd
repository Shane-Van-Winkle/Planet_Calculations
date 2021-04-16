extends Spatial


var G = 0.06 #6.67408*pow(10,-11)#gravitational constant
#draws the orbits once per vbody load
func gravitate(delta): 
	#update the direction
	for body in self.get_children():
		if "mass" in body:
			#update velocities
			body.direction += calculate_acceleration(body) * delta
					
		#update position
	for body in self.get_children():
		if "mass" in body:
			var newPos = body.translation + (body.direction * delta)
			body.translation = newPos 
										
					
				


func calculate_acceleration(thisBody): #return the acceleration from this particular body
	var acceleration = Vector3.ZERO
	for body in self.get_children():
		if "mass" in body and body != thisBody:
			var distanceToObject = (body.translation - thisBody.translation).length_squared()# sqrDist 
			#var distanceToObject = self.translation.distance_to(body.translation)
			if body.mass > 0 and distanceToObject > 0:
				
				var gravityDirection = (body.translation - thisBody.translation).normalized()
				#var gravitationalPull = sqrt(G*(self.mass/distanceToObject))
				acceleration += gravityDirection * G * body.mass / distanceToObject
	return acceleration

	




func _ready():
	pass
	

func _physics_process(delta):
	gravitate(delta)

	pass
