extends Control

func show_eve():
	$ImageFrame/Eve.show()
	$ImageFrame/Eve2.hide()
	$ImageFrame/Unknown.hide()
	

func show_unknown():
	$ImageFrame/Unknown.show()
	$ImageFrame/Eve.hide()
	$ImageFrame/Eve2.hide()


func show_eve2():
	$ImageFrame/Unknown.hide()
	$ImageFrame/Eve.hide()
	$ImageFrame/Eve2.show()
