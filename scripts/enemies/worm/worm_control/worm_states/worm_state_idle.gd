extends WormStateGravityBase

func physics_update(delta: float): 
	worm.play_animation(worm.animations.IDLE)
	worm.velocity.x = 0
