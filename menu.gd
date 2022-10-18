extends CanvasLayer

onready var http_request: HTTPRequest = get_node("HTTPRequest")

var can_refresh: bool

func _ready() -> void:
	var _connect_request_completed = http_request.connect("request_completed", self, "_request_completed")
	
func _process(_delta):
	if http_request.get_http_client_status() != null:
		$Menu/Infor/Conection.text = ""
		can_refresh = true
	else:
		$Menu/Infor/Conection.text = "SEM CONEXÃO"
		can_refresh = false
		
func _on_refresh_pressed() -> void:
	if can_refresh:
		var _request = http_request.request("https://economia.awesomeapi.com.br/json/last/USD-BRL")
		$Menu/Buttons/Refresh.disabled = true
		$Wait.start(2)
		
func _request_completed(_result: int, _response_code: int, _headers: PoolStringArray, body: PoolByteArray) -> void:
	var json = JSON.parse(body.get_string_from_utf8())
	if json.error == OK:
		var value = json.get_result()
		$Menu/Infor/Value/Label.text = str(value["USDBRL"]["high"])
	else:
		print("Error")
		
func _on_exit_pressed() -> void:
	get_tree().quit()
func _on_wait_timeout():
	$Menu/Buttons/Refresh.disabled = false
