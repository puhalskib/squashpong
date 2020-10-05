package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.system.FlxSound;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.addons.effects.FlxTrail;
import flixel.math.FlxRandom;
import flixel.addons.display.shapes.FlxShapeBox;

class PlayState extends FlxState
{

	static inline var WALL_THICK:Int = 20;

	var _plOne:FlxSprite;
	var _plTwo:FlxSprite;
	var _ball:FlxSprite;

	var _walls:FlxGroup;
	var _bottomWall:FlxSprite;

	var _text:FlxText;

	var _trail:FlxTrail;

	var _hitSound:FlxSound;
	var _explosionSound:FlxSound;
	var _winSound:FlxSound;

	var _hitCounter:Int;
	var _plOneScore:Int;
	var _plTwoScore:Int;
	var _rand:FlxRandom;
	

	override public function create()
	{
		super.create();

		//make mouse invisible
		FlxG.mouse.visible = false;

		//add movement data text
		_text = new FlxText(0,WALL_THICK,FlxG.width, "sample text", 40);
    	_text.setFormat(null, 40, FlxColor.WHITE, FlxTextAlign.CENTER);
    	_text.alpha = 0.6;

		//random number generator
		_rand = new FlxRandom();

		//background
		var b = new FlxSprite(0,0);
		b.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);

		//player one
		_plOne = new FlxSprite(100,400);
		_plOne.makeGraphic(100,10, FlxColor.BLUE);
		_plOne.immovable = true;

		//player two
		_plTwo = new FlxSprite(350,400);
		_plTwo.makeGraphic(100,10, FlxColor.RED);
		_plTwo.immovable = true;

		//squash ball
		_ball = new FlxSprite(50,50);
		_ball.makeGraphic(8, 8, FlxColor.WHITE);

		_ball.elasticity = 1; //ball bounces with its full velocity into the opposite direction
		_ball.maxVelocity.set(300,100);
		_ball.velocity.y = 100;
		_ball.velocity.x = _rand.int(-250, 250);

		// Effect Sprite
		_trail = new FlxTrail(_ball);

		//ball wall colision boxes
		_walls = new FlxGroup();

		var leftWall = new FlxSprite(0, 0);
		leftWall.makeGraphic(WALL_THICK, FlxG.height, FlxColor.GRAY);
		leftWall.immovable = true; //wall won't move during collisions
		_walls.add(leftWall);

		var rightWall = new FlxSprite(FlxG.width-WALL_THICK, 0);
		rightWall.makeGraphic(WALL_THICK, FlxG.height, FlxColor.GRAY);
		rightWall.immovable = true; //wall won't move during collisions
		_walls.add(rightWall);

		var topWall = new FlxSprite(0, 0);
		topWall.makeGraphic(FlxG.width, WALL_THICK, FlxColor.GRAY);
		topWall.immovable = true; //wall won't move during collisions
		_walls.add(topWall); 

		_bottomWall = new FlxSprite(0, FlxG.height-1);
		_bottomWall.makeGraphic(FlxG.width, WALL_THICK, FlxColor.TRANSPARENT);
		_bottomWall.immovable = true; //wall won't move during collisions
		_walls.add(_bottomWall);

		//add score boxes
		var redScoreBox = new FlxShapeBox((FlxG.width/2) - 90,WALL_THICK,90,50, {thickness: 0}, FlxColor.RED);
		var blueScoreBox = new FlxShapeBox((FlxG.width/2),WALL_THICK,90,50, {thickness: 0}, FlxColor.BLUE);
		redScoreBox.alpha = 0.6; blueScoreBox.alpha = 0.6;

		//add sound
		_hitSound = FlxG.sound.load(AssetPaths.hit01__wav);
		_explosionSound = FlxG.sound.load(AssetPaths.explosion__wav);
		_winSound = FlxG.sound.load(AssetPaths.win01__wav);
		_winSound.persist;

		//initialize player scores
		_plOneScore = 0;
		_plTwoScore = 0;

		//initialize hit counter
		_hitCounter = 0;

		//adding in sprites in order
		add(b);
		add(_walls);
		add(redScoreBox);
		add(blueScoreBox);
		add(_text);

		add(_plOne);
		add(_plTwo);
		add(_ball);
		add(_trail);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		//reset player velocity to 0
		_plOne.velocity.x = 0; _plOne.velocity.y = 0;
		_plTwo.velocity.x = 0; _plTwo.velocity.y = 0;

		//player one movement
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

		//player two movement
		if (FlxG.keys.pressed.LEFT && _plTwo.x > WALL_THICK) {
			_plTwo.velocity.x = -300;
		}
		else if (FlxG.keys.pressed.RIGHT && _plTwo.x < FlxG.width - WALL_THICK - 100) {
			_plTwo.velocity.x = 300;
		}
		
		if (FlxG.keys.pressed.UP && _plTwo.y > WALL_THICK) {
			_plTwo.velocity.y = -300;
		}
		else if (FlxG.keys.pressed.DOWN && _plTwo.y < FlxG.height - WALL_THICK - 10) {
			_plTwo.velocity.y = 300;
		}




		//collisions
		FlxG.collide(_ball,_walls, wallHit);
		FlxG.collide(_ball,_plOne, playerHit);
		FlxG.collide(_ball,_plTwo, playerHit);

		//update text
		_text.text = "" + _plOneScore + " " + _plTwoScore;
	}

	function startRound():Void {
		_hitCounter = 0;

		//win check
		if(_plOneScore > 10 || _plTwoScore > 10) {
			if(_plOneScore - _plTwoScore > 1 || _plTwoScore - _plOneScore > 1 ) {
				//cannot get the sound to play
				//I do not know why. Maybe the file is too big
				//cannot get the sound to play anywhere in the playstate or winstate
				_winSound.play(); //should work through states because _winSound.persist = true
				if(_plOneScore > _plTwoScore) {
					FlxG.switchState(new WinState("Blue Player"));
				} else {
					FlxG.switchState(new WinState("Red Player"));
				}
			}
		}

		//random ball starting position
		_ball.x = _rand.int(WALL_THICK + 8, FlxG.width-WALL_THICK - 12);
		_ball.y = WALL_THICK + 8;

		//random ball starting velocity
		_ball.velocity.x = _rand.int(-250, 250);
		_ball.velocity.y = 100;

		//reset players alpha and collision box
		_plOne.solid = true;
		_plOne.alpha = 1;
		_plTwo.solid = true;
		_plTwo.alpha = 1;
	}

	function wallHit(ball:FlxSprite, wall:FlxSprite):Void
	{
		//score
		if(wall == _bottomWall) {
			if(_plOne.solid == true && _plTwo.solid == true) {
				startRound();
			}
			else if(_plTwo.solid == false) {
				_plOneScore++;

				//backwall hit sound
				_explosionSound.pan = ( (_ball.x * 2)/FlxG.width) - 1;
				_explosionSound.play();

				//reset ball
				startRound();
			} else if(_plOne.solid == false) {
				_plTwoScore++;
				//backwall hit sound
				_explosionSound.pan = ( (_ball.x * 2)/FlxG.width) - 1;
				_explosionSound.play();

				//reset ball
				startRound();
			}
		} else {
			//hit sound
			_hitSound.pan = ( (_ball.x * 2)/FlxG.width) - 1;
			_hitSound.play(true);
		}
	}


	function playerHit(ball:FlxSprite, player:FlxSprite):Void 
	{
		//camera shake
		FlxG.camera.shake(0.01, 0.2);

		//increment hit counter
		_hitCounter++;

		//increase maxvelocity of the ball
		_ball.maxVelocity.set(300,100 + (_hitCounter*60));

		//hit sound
		_hitSound.pan = ( (_ball.x * 2)/FlxG.width) - 1;
		_hitSound.play(true);

		player.alpha = 0.3;
		player.solid = false;

		if(player == _plOne) {
			_plTwo.alpha = 1;
			_plTwo.solid = true;
		} else {
			_plOne.alpha = 1;
			_plOne.solid = true;
		}

		var playermid:Int = Std.int(player.x) + 50;
		var ballmid:Int = Std.int(ball.x) + 4;
		var difference:Int;

		//direct ball toward the side of the player
		if (ballmid < playermid)
		{
			// Ball is on the left of the player
			difference = playermid - ballmid;
			ball.velocity.x = (-10 * difference);
		}
		else
		{
			// Ball on the right of the bat
			difference = ballmid - playermid;
			ball.velocity.x = (10 * difference);
		}
	}
}
