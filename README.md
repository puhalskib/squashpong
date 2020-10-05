# squashpong
pong inspired squash

### How to play

After running the application, use {w,a,s,d} to move the blue player and use {up, left, down, right} to move the red player in the four cardinal directions.

### Features

- [Cardinal Movement Vectors](#player-movement)
- [Sound Effects]()
- [Ball Speed Increase](#speed-increase)
- [Collision Boxes](#Collision)
- [Score](#win-check)
- [Win Condition](#win-check)
- [Squash Turns](#squash-turns)

## Code Snippets

### Player Movement

```haxe
//blue movement
if (FlxG.keys.pressed.A && _plOne.x > WALL_THICK) {
	_plOne.velocity.x = -300;
}
else if (FlxG.keys.pressed.D && _plOne.x < FlxG.width - WALL_THICK - 100) {
	_plOne.velocity.x = 300;
}

if (FlxG.keys.pressed.W && _plOne.y > WALL_THICK) {
	_plOne.velocity.y = -300;
}
else if (FlxG.keys.pressed.S && _plOne.y < FlxG.height - WALL_THICK - 10) {
	_plOne.velocity.y = 300;
}
```

### Collision

```haxe
FlxG.collide(_ball,_walls, wallHit);
FlxG.collide(_ball,_plOne, playerHit);
FlxG.collide(_ball,_plTwo, playerHit);
```

### Win Check

```haxe
if(_plOneScore > 10 || _plTwoScore > 10) {
	if(_plOneScore - _plTwoScore > 1 || _plTwoScore - _plOneScore > 1 ) {
		if(_plOneScore > _plTwoScore) {
			FlxG.switchState(new WinState("Blue Player"));
		} else {
			FlxG.switchState(new WinState("Red Player"));
		}
	}
}
```

### Squash Turns

```haxe
//reset players alpha and collision box
_plOne.solid = true;
_plOne.alpha = 1;
_plTwo.solid = true;
_plTwo.alpha = 1;
```

### Speed Increase

```haxe
//increment hit counter
_hitCounter++;

//increase maxvelocity of the ball
_ball.maxVelocity.set(300,100 + (_hitCounter*60));
```

## Design Choice

I kept the sprites simple in order to keep the hitboxes consistent and feel good to the user. The FlxTrail is used for the ball to get a good feeling for how fast it is moving and how fast the speed is increasing. The max y speed increases incrementally with each hit from a player sprite. This is so that rounds do not last forever and someone eventually wins a round since the player speed is limited. The players have the ability to move up and down because in squash you are able to do that and it gives the game another axis for strategy. Alpha changes to indicate whos turn it is to hit the squash ball. The walls on the left, top and right come into the application so the user knows the ball can bounce off of those walls and not the bottom. 

**Sept 2020**
