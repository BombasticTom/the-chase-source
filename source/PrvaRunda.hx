package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.effects.FlxFlicker;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

class PrvaRunda extends FlxState
{
	public var timer:Timer;

	var vreme:Float = 60.0;

	var novacText:FlxText;
	var novacTimer:FlxTimer;
	var novacZvuk:FlxSound;
	var novac(default, set):Int = 0;

	function set_novac(val:Int):Int
	{
		novacTimer.cancel();

		var sumaPo:Int = Std.int((val - novac) / ponavljanje);
		var curNovac:Int = novac + sumaPo;

		novacZvuk.play(true);

		novacText.text = Utils.separateDigits(Std.string(curNovac));
		novacText.screenCenter(X);

		novacTimer.start(vremePonavljanja / ponavljanje, (tmr:FlxTimer) ->
		{
			novacText.text = Utils.separateDigits(Std.string(curNovac + sumaPo * tmr.elapsedLoops));
			novacText.screenCenter(X);
		}, ponavljanje - 1);

		return novac = val;
	}

	final osvajanje:Int = 300;
	final vremePonavljanja:Float = 1.0;
	final ponavljanje:Int = 5;

	var gameEnded:Bool = false;

	public static var instance:PrvaRunda;

	/**
		Changes state of the timer.
	**/
	public static function promentiTimer(?isActive:Bool)
	{
		if (instance == null || isActive == instance.timer.active)
			return;

		if (isActive != null)
		{
			instance.timer.active = isActive;
			return;
		}

		instance.timer.active = !instance.timer.active;
	}

	/**
		Rewards player cash
	**/
	public static function dodajSumu(?suma:Int)
	{
		if (instance == null)
			return;

		suma = (suma == null) ? instance.osvajanje : suma;
		instance.novac += suma;
	}

	/**
		Ends the game.
	**/
	public static function endGame()
	{
		if (instance == null)
			return;

		instance.gameEnded = true;

		promentiTimer(false);
		FlxFlicker.flicker(instance.timer, 2.41, 0.4);

		new FlxTimer().start(5.4, (tmr:FlxTimer) ->
		{
			FlxG.sound.music.stop();
			FlxG.switchState(new PlayState());
		});
	}

	override function create()
	{
		instance = this;

		timer = new Timer(0, 60, 72);
		timer.onComplete = () ->
		{
			endGame();
		}
		add(timer);

		novacText = new FlxText(0, FlxG.height - 180, 0, "0", 72);
		novacText.font = "Atenta-Medium.ttf";
		novacText.screenCenter(X);
		add(novacText);

		novacTimer = new FlxTimer();
		novacZvuk = new FlxSound().loadEmbedded("assets/sounds/cb_correct.ogg");

		FlxG.sound.playMusic("assets/music/cb_theme.ogg");
		FlxG.sound.music.onComplete = () ->
		{
			FlxG.sound.music.stop();
		}

		super.create();

		FlxG.sound.music.fadeIn();

		new FlxTimer().start(1.5, (tmr:FlxTimer) ->
		{
			timer.start();
			tmr.destroy();
		});
	}
}
