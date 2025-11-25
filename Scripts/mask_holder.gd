extends Node

enum Masks { HAPPY, SAD, ANGRY, SURPRISE, FEAR, LOVE }
var currentMask = Masks.HAPPY
var masks = []
var index = 0

func _ready() -> void:
	masks.append(Masks.HAPPY)
	masks.append(Masks.SAD)
	currentMask = Masks.HAPPY

func cycle() :
	index = fmod((index+1+masks.size()), masks.size())
	currentMask = masks[index]
	
func addMask(mask) :
	masks.append(mask)
