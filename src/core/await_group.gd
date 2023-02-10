class_name AwaitGroup

## Awaits on a set of functions started at the same time.
##
## Based on code at:
## https://github.com/godotengine/godot-proposals/issues/3469#issuecomment-952457003

signal finished

var running: bool:
	get:
		return _funcs_run > 0

var _funcs_run := 0


static func wait(funcs: Array[Callable]) -> void:
	var group = AwaitGroup.new(funcs)
	if group.running:
		await group.finished


func _init(funcs: Array[Callable]):
	_funcs_run = funcs.size()
	for f in funcs:
		_call_func(f)


func _call_func(f: Callable) -> void:
	@warning_ignore("redundant_await")
	await f.call()
	_funcs_run -= 1
	if _funcs_run == 0:
		finished.emit()
