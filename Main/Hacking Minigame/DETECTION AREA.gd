extends Control

var detection_area_xy = "a"

signal s_detection_area_xy

func _ready():
	detection_area_xy = self.position + $Area2D.position
	s_detection_area_xy.emit(detection_area_xy)
