# JGD game jam 2025
This is the repo for JGD game jam 2025.

## 如何运行：
**在Godot中：** 在下方链接下载LLM gguf，存放到项目目录的guff目录下。
Taptap Gamejam版本包含下面两个Default的gguf。如果不下载gguf，在chat_ui.tscn里勾选debug mode也可以运行。

## LLM gguf download:
**Default:**  [Qwen/Qwen3-4B-GGUF](https://huggingface.co/Qwen/Qwen3-4B-GGUF/blob/main/Qwen3-4B-Q4_K_M.gguf)

**Default:** [Qwen3-0.6B-Q4_K_S-GGUF](https://huggingface.co/AnHoang200901/Qwen3-0.6B-Q4_K_S-GGUF/blob/main/qwen3-0.6b-q4_k_s.gguf) (471MB, 这个笨得没法用，但是体积小，可以用来测试游戏流程。)

[Llama3-8B-Chinese-Chat-GGUF-4bit ](https://huggingface.co/shenzhi-wang/Llama3-8B-Chinese-Chat-GGUF-4bit/tree/main) (~5 GB)

[Xwen-7B-Chat.i1-Q4_K_M](https://huggingface.co/xwen-team/Xwen-7B-Chat-i1-GGUF/blob/main/Xwen-7B-Chat.i1-Q4_K_M.gguf) (~5 GB)


## Wwise Soundbank:
下载 [git lfs](https://docs.github.com/en/repositories/working-with-files/managing-large-files/installing-git-large-file-storage)

之后就可以正常使用，否则你只会下载一个指针，可能会崩溃。

由于Wwise soundbank超过100MB了（从某个版本后），所以Soundbank要手动下载之后放到\jgd2025\jgd2025\Taptap Gamejam 2025\GeneratedSoundBanks\Mac或者Windows目录下：
https://drive.google.com/drive/folders/1vkVRwcnIh8iUeOh7wYxWTO5DedC81Ih0?usp=sharing

如果不替换soundbank，main上是老的soundbanks，应该会缺少声音，但是不知道会不会崩溃？（待发现）


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
Pushing to the branch `release` will automatically export the Windows build. (buggy now)
# 3D Pixel Art Post Processing Shader for Godot 4
This repo has the source code for the Youtube tutorial: https://youtu.be/WBoApONC7bM
