extends RigidBody3D

var listener: TCPServer = TCPServer.new()
var client: StreamPeerTCP = null

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
		"jump":
			print("Jump command received")
		"walk":
			print("Walk command received")
		"idle":
			print("Idle command received")
			
			
func move_backward():
	print("moving backward")

func move_forward():
	print("moving forward")

func move_left():
	print("turning left")

func move_right():
	print("turning right")

func jump():
	print("jumping")

func stop():
	print("stopping")
