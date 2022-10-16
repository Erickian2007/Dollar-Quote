extends CanvasLayer

onready var http_request: HTTPRequest = get_node("HTTPRequest")

func _ready() -> void:
	http_request.connect("request_completed", self, "_request_completed")
	
func _on_refresh_pressed() -> void:
	http_request.request("https://economia.awesomeapi.com.br/json/last/USD-BRL")
	
func _request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var json = JSON.parse(body.get_string_from_utf8())
	if json.error == OK:
		var value = json.get_result()
		$Menu/Infor/Value/Label.text = str(value["USDBRL"]["high"])
	else:
		print("Error")
		
func _on_exit_pressed() -> void:
	get_tree().quit()

