# JGD game jam 2025
This is the repo for JGD game jam 2025.

## 目录结构：
Scene 和 gdscript 放在 `scenes` 的对应子目录下，其余srcipts在`other_scripts`下：


```
scenes/
	gun/
		gun.tscn      # scene file (Godot)
		gun.gd        # GDScript attached to the scene
	player/
		player.tscn
		player.gd
	ui/
		hud.tscn
		hud.gd
		
other_scripts/
	random_script.gd
```


## Auto Build：
Pushing to the branch `release` will automatically export the Windows build.

## LLM gguf download:
Default: [Llama3-8B-Chinese-Chat-GGUF-4bit](https://huggingface.co/shenzhi-wang/Llama3-8B-Chinese-Chat-GGUF-4bit/tree/main)

[Xwen-7B-Chat.i1-Q4_K_M](https://huggingface.co/xwen-team/Xwen-7B-Chat-i1-GGUF/blob/main/Xwen-7B-Chat.i1-Q4_K_M.gguf)
# 3D Pixel Art Post Processing Shader for Godot 4
This repo has the source code for the Youtube tutorial: https://youtu.be/WBoApONC7bM
