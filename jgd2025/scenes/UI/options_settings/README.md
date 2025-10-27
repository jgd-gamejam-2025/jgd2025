# 游戏设置 UI (Options Settings)# 音量设置 UI



游戏设置界面，包含音频和显示设置。这是一个用于调节游戏音量的设置界面。



## 功能## 功能特性



### 音频设置- ✅ **三个独立音量控制**

- **主音量**: 控制整体音量（0-100%）  - 主音量（Master）

- **背景音乐**: 单独控制 BGM 音量（0-100%）  - 背景音乐（BGM）

- **音效**: 单独控制音效音量（0-100%）  - 音效（SFX）



### 显示设置- ✅ **实时调节**

- **全屏模式**: 切换全屏/窗口模式  - 拖动滑块即时生效

- **分辨率**: 选择游戏分辨率  - 显示当前音量百分比

  - 1920×1080 (Full HD)

  - 1600×900 (HD+)- ✅ **设置保存**

  - 1366×768 (WXGA)  - 自动保存到 `user://settings.cfg`

  - 1280×720 (HD)  - 下次启动时自动加载

  - 2560×1440 (2K)

  - 3840×2160 (4K)- ✅ **音频系统支持**

  - 支持 Godot 原生音频总线

## 使用方法  - 预留 Wwise RTPC 接口



### 实例化设置界面- ✅ **便捷操作**

  - 重置为默认值按钮

```gdscript  - 关闭按钮

# 在游戏中打开设置菜单

var settings_scene = preload("res://scenes/UI/options_settings/options_settings.tscn")## 使用方法

var settings = settings_scene.instantiate()

add_child(settings)### 1. 在场景中添加

```

```gdscript

### 监听设置变化# 加载并添加到场景树

var volume_settings = preload("res://scenes/UI/volume_settings/volume_settings.tscn").instantiate()

```gdscriptadd_child(volume_settings)

# 监听音量变化

settings.volume_changed.connect(func(bus_name: String, value: float):# 或者直接在编辑器中拖入场景

	print("%s 音量变更为: %d%%" % [bus_name, int(value)])```

)

### 2. 在菜单中调用

# 监听显示设置变化

settings.display_settings_changed.connect(func():```gdscript

	print("显示设置已更改")func _on_settings_button_pressed():

)    var volume_settings = load("res://scenes/UI/volume_settings/volume_settings.tscn").instantiate()

```    get_tree().root.add_child(volume_settings)

```

### 音频系统配置

### 3. 监听音量变化

可选择使用 Godot 原生音频总线或 Wwise：

```gdscript

```gdscriptvar volume_settings = preload("res://scenes/UI/volume_settings/volume_settings.tscn").instantiate()

# 使用 Wwise RTPCvolume_settings.volume_changed.connect(_on_volume_changed)

@export var wwise_bgm_rtpc: String = "BGM_Volume"add_child(volume_settings)

@export var wwise_sfx_rtpc: String = "SFX_Volume"

@export var wwise_master_rtpc: String = "Master_Volume"func _on_volume_changed(bus_name: String, value: float):

```    print("%s 音量改变为: %d%%" % [bus_name, int(value)])

```

## 配置持久化

## 配置音频总线

设置自动保存到 `user://settings.cfg`，下次启动时会自动加载：

在 Godot 项目设置中，需要配置以下音频总线：

- `master_volume`: 主音量

- `bgm_volume`: BGM 音量1. **Master** - 主音频总线（默认存在）

- `sfx_volume`: 音效音量2. **BGM** - 背景音乐总线

- `fullscreen`: 全屏状态3. **SFX** - 音效总线

- `resolution_index`: 分辨率索引

设置路径：`项目 -> 项目设置 -> Audio -> Buses`

## 节点结构

## Wwise 集成

```

OptionsSettings (Control)如果使用 Wwise，需要在 `_set_wwise_rtpc()` 函数中实现 RTPC 设置：

└── Panel

    └── PanelContainer```gdscript

        └── MarginContainerfunc _set_wwise_rtpc(rtpc_name: String, value: float) -> void:

            └── VBoxContainer    # 示例实现

                ├── TitleLabel (游戏设置)    if rtpc_name != "":

                ├── HSeparator        AkSoundEngine.SetRTPCValue(rtpc_name, value, self)

                ├── AudioLabel (音频设置)```

                ├── MasterVolumeContainer

                ├── BGMVolumeContainer在脚本的 export 变量中设置 RTPC 名称：

                ├── SFXVolumeContainer- `wwise_bgm_rtpc`: BGM 音量的 RTPC 名称

                ├── HSeparator2- `wwise_sfx_rtpc`: 音效音量的 RTPC 名称

                ├── DisplayLabel (显示设置)- `wwise_master_rtpc`: 主音量的 RTPC 名称

                ├── FullscreenContainer

                ├── ResolutionContainer## 自定义样式

                ├── HSeparator3

                └── ButtonContainer可以通过修改 `.tscn` 文件中的以下部分来自定义外观：

                    ├── ResetButton (重置默认)

                    └── CloseButton (关闭)- `StyleBoxFlat_1`: 面板背景样式

```- 字体大小：`theme_override_font_sizes/font_size`

- 颜色：在 StyleBox 中修改 `bg_color`

## API

## 配置文件位置

### 信号

音量设置保存在：`user://settings.cfg`

- `volume_changed(bus_name: String, value: float)` - 音量变更时触发

- `display_settings_changed()` - 显示设置变更时触发格式示例：

```ini

### 方法[audio]

master_volume=80.0

- `reset_to_default()` - 重置所有设置为默认值bgm_volume=70.0

sfx_volume=80.0

## 注意事项```



- 分辨率更改后，窗口模式下会自动居中## 注意事项

- 全屏切换会立即生效

- 设置会在游戏重启后保持- 音量值范围：0-100

- 使用 UniqueNode 系统引用 UI 节点（%NodeName）- 内部转换为 dB 范围：-80 到 0 dB

- 确保音频总线名称匹配

## 配置文件位置- 关闭按钮会销毁整个 UI 节点


设置保存在：`user://settings.cfg`

格式示例：
```ini
[settings]
master_volume=80.0
bgm_volume=70.0
sfx_volume=80.0
fullscreen=false
resolution_index=0
```
