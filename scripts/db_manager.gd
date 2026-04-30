extends Node

const DB_PATH: String = "user://game_data.db"
const FALLBACK_PATH: String = "user://game_data_fallback.cfg"
const PLAYER_NAME: String = "Jugador"

var db: Variant = null
var sqlite_available: bool = false

func _ready() -> void:
	open_database()

func open_database() -> void:
	db = _create_sqlite_instance()
	sqlite_available = db != null

	if sqlite_available:
		db.path = DB_PATH
		var opened: bool = false
		if db.has_method("open_db"):
			opened = bool(db.open_db())
		elif db.has_method("open"):
			opened = bool(db.open())

		if opened:
			db.query("CREATE TABLE IF NOT EXISTS highscores (id INTEGER PRIMARY KEY, player_name TEXT DEFAULT 'Jugador', max_score INTEGER NOT NULL DEFAULT 0, date TEXT NOT NULL)")
			_ensure_initial_row_sqlite()
			return

	sqlite_available = false
	_ensure_fallback_file()

func _create_sqlite_instance() -> Variant:
	var global_classes: Array = ProjectSettings.get_global_class_list()
	for class_info in global_classes:
		if class_info.has("class") and String(class_info["class"]) == "SQLite":
			if class_info.has("path"):
				var script_resource: Resource = load(String(class_info["path"]))
				if script_resource != null:
					return script_resource.new()
	return null

func _get_query_result() -> Array:
	if db == null:
		return []

	var result_variant: Variant = db.get("query_result")
	if typeof(result_variant) == TYPE_ARRAY:
		return result_variant

	return []

func get_best_score() -> int:
	if sqlite_available:
		return _get_best_score_sqlite()
	return _get_best_score_fallback()

func save_score_if_best(score: int) -> bool:
	var current_best: int = get_best_score()
	if score <= current_best:
		return false

	if sqlite_available:
		_save_score_sqlite(score)
	else:
		_save_score_fallback(score)

	return true

func _ensure_initial_row_sqlite() -> void:
	db.query("SELECT id FROM highscores LIMIT 1")
	var result: Array = _get_query_result()

	if result.is_empty():
		var today: String = Time.get_datetime_string_from_system(false, true)
		db.query("INSERT INTO highscores (id, player_name, max_score, date) VALUES (1, 'Jugador', 0, '%s')" % today)

func _get_best_score_sqlite() -> int:
	db.query("SELECT max_score FROM highscores ORDER BY max_score DESC LIMIT 1")
	var result: Array = _get_query_result()

	if result.is_empty():
		return 0

	var row: Dictionary = result[0]
	if row.has("max_score"):
		return int(row["max_score"])
	return 0

func _save_score_sqlite(score: int) -> void:
	var today: String = Time.get_datetime_string_from_system(false, true)
	db.query("DELETE FROM highscores")
	db.query("INSERT INTO highscores (id, player_name, max_score, date) VALUES (1, '%s', %d, '%s')" % [PLAYER_NAME, score, today])

func _ensure_fallback_file() -> void:
	var config: ConfigFile = ConfigFile.new()
	var error: Error = config.load(FALLBACK_PATH)
	if error != OK:
		config.set_value("highscores", "player_name", PLAYER_NAME)
		config.set_value("highscores", "max_score", 0)
		config.set_value("highscores", "date", Time.get_datetime_string_from_system(false, true))
		config.save(FALLBACK_PATH)

func _get_best_score_fallback() -> int:
	var config: ConfigFile = ConfigFile.new()
	var error: Error = config.load(FALLBACK_PATH)
	if error != OK:
		return 0
	return int(config.get_value("highscores", "max_score", 0))

func _save_score_fallback(score: int) -> void:
	var config: ConfigFile = ConfigFile.new()
	config.load(FALLBACK_PATH)
	config.set_value("highscores", "player_name", PLAYER_NAME)
	config.set_value("highscores", "max_score", score)
	config.set_value("highscores", "date", Time.get_datetime_string_from_system(false, true))
	config.save(FALLBACK_PATH)
