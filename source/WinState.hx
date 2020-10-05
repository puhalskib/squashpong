package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.system.FlxSound;

class WinState extends FlxState
{
	var _winText:FlxText;
	var _bg:FlxSprite;
	var _bgEye:FlxSprite;
	var _startButton:FlxButton;
	var _player:String;

	public function new(p:String) 
	{
		super();
		_player = p;
	}

	override public function create():Void
	{

		//make mouse visible
		FlxG.mouse.visible = true;

		// Add the game text and set some formatting options along with a shadow; you can also
		// pass in your own font if you have one embedded or it uses Flixel's default one
		_winText = new FlxText(0, 90, FlxG.width, "" + _player + " wins", 50);
		_winText.setFormat(null, 50, FlxColor.WHITE, CENTER);
		add(_winText);

		//restart button
		_startButton = new FlxButton(137, 195, "Restart", onStart);
		_startButton.makeGraphic(137,30, FlxColor.GRAY);
		add(_startButton);

		// Some credit text
		add(new FlxText(280, 200, 200, "by Ben Puhalski", 16));
	}

	function onStart():Void
	{
		FlxG.cameras.fade(FlxColor.BLACK, 1, false, onFade);
	}
	function onFade():Void
	{
		FlxG.switchState(new PlayState());
	}
}