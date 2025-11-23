extends Node2D

@export var maxHealth = 5;
@export var currentHealth = maxHealth
@export var cooldownTime = 2.5
var cooldown = false

func damage(amount : int) :
	if !cooldown : 
		currentHealth -= amount
		cooldown = true
	await get_tree().create_timer(cooldownTime).timeout
	cooldown = false
	
func heal (amount : int) :
	currentHealth+=amount
