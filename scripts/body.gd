extends KinematicBody
#variables
#var G = 0.0001#6.67408*pow(10,-11)#gravitational constant
export var direction = Vector3(0,0,0) #initial and current velocity
export var active = true #whether the body moves or not, still has gravity
export var mass = 100000000 #determines the mass
export var draw_orbit = true #draws the line coming from the body

export var centralBody = false #eases making other bodies orbit this one. 

func _enter_tree():
	pass
#	active = false

func _ready():
#	active = true
	pass
