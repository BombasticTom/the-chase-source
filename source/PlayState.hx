package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

// Placeholder menu class which will get overhauled in the future
class PlayState extends FlxState
{
	var dumText:FlxText;

	override public function create()
	{
		dumText = new FlxText(0, 0, 0, "POTERA", 32);
		dumText.screenCenter();
		add(dumText);
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// Fullscreen window test
		if (FlxG.keys.justPressed.F)
		{
			if (!FlxG.fullscreen)
			{
				FlxG.resizeGame(1920, 1080);
				FlxG.resizeWindow(1920, 1080);
			}
			else
			{
				FlxG.resizeGame(1280, 720);
				FlxG.resizeWindow(1280, 720);
			}
			FlxG.fullscreen = !FlxG.fullscreen;
		}
	}
}
