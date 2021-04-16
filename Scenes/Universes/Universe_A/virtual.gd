tool
extends Spatial
export var seconds = 8.0#simulated seconds

export var iterations = 10

export var relativeToBody = false

var referenceBody
var referenceBodyInitialPosition
var timestep = .016667 # ~ 1 / 60 ; delta between frames
var centralBodyCount = 0

var G = 0.06 #6.67408*pow(10,-11)#gravitational constant
onready var reality = get_parent().get_node("Real") 
var realArray = Array()
var this_draw_orbit = true

#draws the orbits once per vbody load
func drawOrbit(): 
	if this_draw_orbit == true:
		#simulation iterations
		for i in iterations:
			var referenceBodyPosition
			if relativeToBody == true:
				#current position of the reference body
				referenceBodyPosition = referenceBody.translation 
			else:
				referenceBodyPosition = Vector3() #all zeroes
			
				#update the direction
			for vbody in self.get_children():
				if "mass" in vbody:
					#update velocities
					vbody.direction += calculate_acceleration(vbody) * timestep
					
				#update position
			for vbody in self.get_children():
				if "mass" in vbody:
					var newPos = vbody.translation + (vbody.direction * timestep)
					vbody.translation = newPos 
										
					if(relativeToBody == true): 
						var referenceFrameOffset = referenceBodyPosition - referenceBodyInitialPosition
						#vbody.drawpoints.append(vbody.translation - )
						newPos -= referenceFrameOffset
						#vbody.translation -= referenceBodyPosition - referenceBodyInitialPosition
					
					if relativeToBody == true and vbody == referenceBody:
						newPos = referenceBodyInitialPosition
						
						#vbody.translation = referenceBodyInitialPosition
					
					
					if vbody.draw_orbit == true:
						vbody.drawpoints.append(newPos)
			#draw the line

		for vbody in self.get_children():
			if "mass" in vbody :
				var lr = self.get_node("ImmediateGeometry")
				lr.begin(Mesh.PRIMITIVE_LINE_STRIP)
				for drawPoint in vbody.drawpoints:
					lr.add_vertex(drawPoint)
				self.remove_child(vbody)
	
			
				lr.end()
				vbody.drawpoints.clear()
	this_draw_orbit = false
			


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

#grabs the real bodies and places them in an array
func getRealBodies():
	reality = get_parent().get_node("Real") 
	for N in reality.get_children():
	#	if N.get_name().left(4) == "Body":
		realArray.append(N)
#			directionArrayUpdate()
	
#grabs the bodies in the array and places them in virtual bodies
func cloneRealBodies():
	for body in realArray:
		var virtualBody = load("res://Scenes/Bodies/vbody.tscn").instance()
		virtualBody.direction = body.direction
		virtualBody.mass = body.mass 
		virtualBody.translation = body.translation
		virtualBody.scale = body.scale
		virtualBody.active = body.active
		virtualBody.draw_orbit = false #body.draw_orbit
		
		
		if self.relativeToBody == true and body.centralBody == true:
				referenceBody = virtualBody
				referenceBodyInitialPosition = body.translation
				centralBodyCount += 1
				

		self.add_child(virtualBody)
	self.add_child(ImmediateGeometry.new())
	
	if centralBodyCount > 1 and relativeToBody == true:
		print("Undefined Behavior: Only one central body should be used.")
		
	if centralBodyCount == 0 and relativeToBody == true:
		print("Undefined Behavior: Add a central body.")

#func calculate_acceleration(): #return the acceleration from this particular body
#	var acceleration = Vector3.ZERO
#	for body in get_parent().get_children():
#		if body == self:
#			pass
#		else:
#			var distanceToObject = translation.distance_to(body.translation)
#			if body.mass>0 and distanceToObject>0:
#				var gravityDirection = (translation - body.translation).normalized()
#				var gravitationalPull = sqrt(G*(self.mass/distanceToObject))
#				acceleration += gravityDirection * gravitationalPull
#	return acceleration

func update():
	getRealBodies()#get the real bodies
	for vbody in self.get_children():
		self.remove_child(vbody)
	cloneRealBodies()
	realArray.clear()#clear for the next search
	pass

func _ready():
	pass
	


var index = 0.0
func _physics_process(delta):
	if(Engine.is_editor_hint()):
		var simSeconds : float = seconds * 60
		if (floor(fmod(index, simSeconds))) == 0.0:	#restart the simulation after a set number of seconds
			update()
			drawOrbit()
			this_draw_orbit = true
			centralBodyCount = 0
#			print(self.get_children()[0].draw_orbit)
			index = 0
	index += 1
	pass
