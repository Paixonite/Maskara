extends Node2D

@export var maxHealth = 3;
@export var currentHealth = maxHealth

func damage(amount : int) :
	currentHealth-=amount
	
func heal (amount : int) :
	currentHealth+=amount
