# JGD game jam 2025
This is the repo for JGD game jam 2025.

## 如何运行：
**游玩exe：** 下载[Llama3-8B-Chinese-Chat-GGUF-4bit](https://huggingface.co/shenzhi-wang/Llama3-8B-Chinese-Chat-GGUF-4bit/tree/main)，在游戏目录下（和exe同目录）创建文件夹gguf，放到该目录下。游戏需要几秒钟加载。

```
eve.exe/
eve.pck/
gguf/
	Llama3-8B-Chinese-Chat-q4_0-v2_1.gguf
...
```

**在Godot中：** 在下方链接下载一个LLM gguf，在chat_ui.tscn中的NobodyWhoModel中选择下载的gguf。

## LLM gguf download:
**Default:** [Llama3-8B-Chinese-Chat-GGUF-4bit ](https://huggingface.co/shenzhi-wang/Llama3-8B-Chinese-Chat-GGUF-4bit/tree/main) (~5 GB)

[Xwen-7B-Chat.i1-Q4_K_M](https://huggingface.co/xwen-team/Xwen-7B-Chat-i1-GGUF/blob/main/Xwen-7B-Chat.i1-Q4_K_M.gguf) (~5 GB)

[Qwen3-0.6B-Q4_K_S-GGUF](https://huggingface.co/AnHoang200901/Qwen3-0.6B-Q4_K_S-GGUF/blob/main/qwen3-0.6b-q4_k_s.gguf) (471MB, 这个笨得没法用，但是体积小，可以用来测试游戏流程。)


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
# 3D Pixel Art Post Processing Shader for Godot 4
This repo has the source code for the Youtube tutorial: https://youtu.be/WBoApONC7bM
