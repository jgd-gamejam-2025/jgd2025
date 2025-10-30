# options_settings.gd
extends CanvasLayer

# 音量控制节点
@onready var bgm_slider: HSlider = %BGMSlider
@onready var bgm_value_label: Label = %BGMValueLabel
@onready var sfx_slider: HSlider = %SFXSlider
@onready var sfx_value_label: Label = %SFXValueLabel
@onready var master_slider: HSlider = %MasterSlider
@onready var master_value_label: Label = %MasterValueLabel

# 显示设置节点
@onready var fullscreen_checkbox: CheckBox = %FullscreenCheckBox
@onready var resolution_option: OptionButton = %ResolutionOption

# Wwise RTPC 名称（如果使用 Wwise）
@export var wwise_bgm_rtpc: String = "Music_volume"
@export var wwise_sfx_rtpc: String = "SFX_volume"
# @export var wwise_master_rtpc: String = "Master_Volume"

# 音频总线名称（如果使用 Godot 原生音频）
# const BUS_MASTER = "Master"
# const BUS_BGM = "BGM"
# const BUS_SFX = "SFX"

# 预设分辨率
const RESOLUTIONS = [
	Vector2i(1920, 1080),
	Vector2i(1600, 900),
	Vector2i(1366, 768),
	Vector2i(1280, 720),
	Vector2i(2560, 1440),
	Vector2i(3840, 2160),
]

signal volume_changed(bus_name: String, value: float)
signal display_settings_changed()


func _ready() -> void:
	# 连接音量滑块信号
	if master_slider:
		master_slider.value_changed.connect(_on_master_slider_changed)
	if bgm_slider:
		bgm_slider.value_changed.connect(_on_bgm_slider_changed)
	if sfx_slider:
		sfx_slider.value_changed.connect(_on_sfx_slider_changed)
	
	# 连接显示设置信号
	if fullscreen_checkbox:
		fullscreen_checkbox.toggled.connect(_on_fullscreen_toggled)
	if resolution_option:
		resolution_option.item_selected.connect(_on_resolution_selected)
	
	# 初始化分辨率选项
	_init_resolution_options()
	
	# 加载保存的设置
	_load_settings()
	
	hide()


func _init_resolution_options() -> void:
	"""初始化分辨率选项"""
	if not resolution_option:
		return
	
	resolution_option.clear()
	for res in RESOLUTIONS:
		resolution_option.add_item("%d × %d" % [res.x, res.y])


func _load_settings() -> void:
	"""从配置文件加载所有设置"""
	# 加载音量设置
	var master_volume = _get_saved_value("master_volume", 80.0)
	var bgm_volume = _get_saved_value("bgm_volume", 70.0)
	var sfx_volume = _get_saved_value("sfx_volume", 80.0)
	
	if master_slider:
		master_slider.value = master_volume
	if bgm_slider:
		bgm_slider.value = bgm_volume
	if sfx_slider:
		sfx_slider.value = sfx_volume
	
	# 应用音量
	_apply_master_volume(master_volume)
	_apply_bgm_volume(bgm_volume)
	_apply_sfx_volume(sfx_volume)
	
	# 加载显示设置
	var is_fullscreen = _get_saved_value("fullscreen", false)
	var resolution_index = _get_saved_value("resolution_index", 0)
	
	if fullscreen_checkbox:
		fullscreen_checkbox.button_pressed = is_fullscreen
	if resolution_option:
		resolution_option.selected = resolution_index
	
	# 应用显示设置
	_apply_fullscreen(is_fullscreen)
	_apply_resolution(resolution_index)


func _get_saved_value(key: String, default_value):
	"""从配置文件获取保存的值"""
	if FileAccess.file_exists("user://settings.cfg"):
		var config = ConfigFile.new()
		var err = config.load("user://settings.cfg")
		if err == OK:
			return config.get_value("settings", key, default_value)
	return default_value


func _save_value(key: String, value) -> void:
	"""保存值到配置文件"""
	var config = ConfigFile.new()
	if FileAccess.file_exists("user://settings.cfg"):
		config.load("user://settings.cfg")
	
	config.set_value("settings", key, value)
	config.save("user://settings.cfg")


# === 显示设置函数 ===

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	"""全屏切换"""
	_apply_fullscreen(toggled_on)
	_save_value("fullscreen", toggled_on)
	display_settings_changed.emit()


func _on_resolution_selected(index: int) -> void:
	"""分辨率选择"""
	_apply_resolution(index)
	_save_value("resolution_index", index)
	display_settings_changed.emit()


func _apply_fullscreen(is_fullscreen: bool) -> void:
	"""应用全屏设置"""
	# 在编辑器中运行时不修改窗口模式
	if OS.has_feature("editor"):
		return
	
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _apply_resolution(index: int) -> void:
	"""应用分辨率设置"""
	# 在编辑器中运行时不修改窗口大小
	if OS.has_feature("editor"):
		return
	
	if index < 0 or index >= RESOLUTIONS.size():
		return
	
	var resolution = RESOLUTIONS[index]
	DisplayServer.window_set_size(resolution)
	
	# 如果是窗口模式，居中窗口
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		var screen_size = DisplayServer.screen_get_size()
		var window_size = DisplayServer.window_get_size()
		var center_pos = (screen_size - window_size) / 2
		DisplayServer.window_set_position(center_pos)


# === 音量设置函数 ===



func _on_master_slider_changed(value: float) -> void:
	"""主音量滑块改变"""
	_apply_master_volume(value)
	_save_value("master_volume", value)
	if master_value_label:
		master_value_label.text = "%d%%" % int(value)
	volume_changed.emit("Master", value)


func _on_bgm_slider_changed(value: float) -> void:
	"""BGM 音量滑块改变"""
	_apply_bgm_volume(value)
	_save_value("bgm_volume", value)
	if bgm_value_label:
		bgm_value_label.text = "%d%%" % int(value)
	volume_changed.emit("BGM", value)


func _on_sfx_slider_changed(value: float) -> void:
	"""音效音量滑块改变"""
	_apply_sfx_volume(value)
	_save_value("sfx_volume", value)
	if sfx_value_label:
		sfx_value_label.text = "%d%%" % int(value)
	volume_changed.emit("SFX", value)


func _apply_master_volume(value: float) -> void:
	"""应用主音量设置"""
	pass
	## 转换 0-100 的值到 -80 到 0 dB（Godot 音频总线）
	#var db_value = linear_to_db(value / 100.0)
	#var bus_idx = AudioServer.get_bus_index(BUS_MASTER)
	#if bus_idx >= 0:
		#AudioServer.set_bus_volume_db(bus_idx, db_value)
	#
	## 如果使用 Wwise，设置 RTPC
	#_set_wwise_rtpc(wwise_master_rtpc, value)


func _apply_bgm_volume(value: float) -> void:
	"""应用 BGM 音量设置"""
	# var db_value = linear_to_db(value / 100.0)
	# var bus_idx = AudioServer.get_bus_index(BUS_BGM)
	# if bus_idx >= 0:
	# 	AudioServer.set_bus_volume_db(bus_idx, db_value)
	
	# 如果使用 Wwise，设置 RTPC
	_set_wwise_rtpc(wwise_bgm_rtpc, value)


func _apply_sfx_volume(value: float) -> void:
	"""应用音效音量设置"""
	# var db_value = linear_to_db(value / 100.0)
	# var bus_idx = AudioServer.get_bus_index(BUS_SFX)
	# if bus_idx >= 0:
	# 	AudioServer.set_bus_volume_db(bus_idx, db_value)
	
	# 如果使用 Wwise，设置 RTPC
	_set_wwise_rtpc(wwise_sfx_rtpc, value)

func _set_wwise_rtpc(rtpc_name: String, value: float) -> void:
	"""设置 Wwise RTPC（如果 Wwise 可用）"""
	# 这里需要根据你的 Wwise 集成实现
	Wwise.set_rtpc_value(rtpc_name, value, LevelManager)
	pass


func linear_to_db(linear: float) -> float:
	"""将线性值转换为分贝值"""
	if linear <= 0:
		return -80.0
	return 20.0 * log(linear) / log(10.0)


func reset_to_default() -> void:
	"""重置为默认设置"""
	# 重置音量
	# if master_slider:
	# 	master_slider.value = 80.0
	if bgm_slider:
		bgm_slider.value = 70.0
	if sfx_slider:
		sfx_slider.value = 80.0
	
	# 重置显示设置
	if fullscreen_checkbox:
		fullscreen_checkbox.button_pressed = false
	if resolution_option:
		resolution_option.selected = 0


func _on_close_button_pressed() -> void:
	Wwise.post_event("UI_Choose", LevelManager)
	hide()

func _on_select() -> void:
	Wwise.post_event("UI_Prechoose", LevelManager)
	
func _on_pressed() -> void:
	Wwise.post_event("UI_Choose", LevelManager)


func _on_resolution_option_item_focused(index: int) -> void:
	Wwise.post_event("UI_Prechoose", LevelManager)


func _on_resolution_option_item_selected(index: int) -> void:
	Wwise.post_event("UI_Choose", LevelManager)
