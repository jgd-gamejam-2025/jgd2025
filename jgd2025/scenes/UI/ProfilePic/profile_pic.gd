extends Control

func show_eve():
	$ImageFrame/Eve.show()
	$ImageFrame/Unknown.hide()
	

func show_unknown():
	$ImageFrame/Unknown.show()
	$ImageFrame/Eve.hide()
