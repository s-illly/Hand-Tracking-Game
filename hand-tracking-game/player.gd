extends RigidBody3D

var listener: TCPServer = TCPServer.new()
var client: StreamPeerTCP = null
var move_dir := Vector3.ZERO 
var speed: float = 5.0

func _ready():
	var result := listener.listen(65432)
	if result != OK:
		print("Failed to start server: ", result)
	else:
		print("Server is listening on port 65432")

func _process(_delta):
	if client == null and listener.is_connection_available():
		client = listener.take_connection()
		print("Python connected!")

	if client != null and client.get_available_bytes() > 0:
		var message := client.get_utf8_string(client.get_available_bytes()).strip_edges()
		print("Received from Python:", message)
		handle_command(message)

func handle_command(cmd: String):
	match cmd:
		"slow walking forward":
			speed = 2.0
			move_forward()
		"fast walking forward":
			speed = 6.0
			move_forward()
		"slow walking backward":
			speed = 2.0
			move_backward()
		"fast walking backward":
			speed = 6.0
			move_backward()
		"turning left":
			speed = 5.0
			move_left()
		"turning right":
			speed = 5.0
			move_right()
		"jump":
			jump()
		"idle":
			idle()
			
			
func move_backward():
	move_dir = transform.basis.z.normalized()

func move_forward():
	move_dir = -transform.basis.z.normalized()

func move_left():
	move_dir = -transform.basis.x.normalized()

func move_right():
	move_dir = transform.basis.x.normalized()

func jump():
	apply_impulse(Vector3.ZERO, Vector3.UP * 8.0)

func stop():
	move_dir = Vector3.ZERO
	
func idle():
	move_dir = Vector3.ZERO
	
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	state.linear_velocity = move_dir * speed
