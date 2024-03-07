package;

import flixel.FlxG;
import flixel.FlxGame;
import haxe.CallStack;
import haxe.io.Path;
import haxe.ui.HaxeUIApp;
import lime.app.Application;
import lime.ui.Window;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.UncaughtErrorEvent;
import openfl.ui.Mouse;
import sys.FileSystem;
import sys.io.File;

using StringTools;

/*

	Based on Main.hx from Psych Engine
	https://github.com/ShadowMario/FNF-PsychEngine/blob/main/source/Main.hx

 */
class Main extends Sprite
{
	var game = {
		width: 1280, // WINDOW width
		height: 720, // WINDOW height
		initialState: PlayState, // initial game state
		zoom: -1.0, // game state bounds
		framerate: 60, // default framerate
		skipSplash: true, // if the default flixel splash screen should be skipped
		startFullscreen: false // if the game should start at fullscreen mode
	};

	var window:Window;

	public static function main()
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		if (stage != null)
			init();
		else
			addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		setupGame();

		stage.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);

		window = stage.application.createWindow({
			title: "KONTROLNA TABLA",
			width: 800,
			height: 720,
			resizable: false,
		});
		window.stage.color = 0x00000000;

		var app:HaxeUIApp = new HaxeUIApp({container: window.stage});

		app.ready(function()
		{
			app.addComponent(new MainView());
			app.start();
		});

		Mouse.show();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = stage.stageWidth;
		var stageHeight:Int = stage.stageHeight;

		if (game.zoom == -1.0)
		{
			var ratioX:Float = stageWidth / game.width;
			var ratioY:Float = stageHeight / game.height;
			game.zoom = Math.min(ratioX, ratioY);
			game.width = Math.ceil(stageWidth / game.zoom);
			game.height = Math.ceil(stageHeight / game.zoom);
		}

		stage.addChild(new FlxGame(game.width, game.height, game.initialState, #if (flixel < "5.0.0") game.zoom, #end game.framerate, game.framerate,
			game.skipSplash, game.startFullscreen));

		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
	}

	function onCrash(e:UncaughtErrorEvent):Void
	{
		var errMsg:String = "";
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();

		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");

		path = "./crash/" + "Potera_" + dateNow + ".txt";

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(_, file, line, _):
					errMsg += file + " (line " + line + ")\n";
				default:
					Sys.println(stackItem);
			}
		}

		errMsg += "\nUncaught Error: " + e.error + "\n> Crash Handler written by: sqirra-rng";

		if (!FileSystem.exists("./crash/"))
			FileSystem.createDirectory("./crash/");

		File.saveContent(path, errMsg + "\n");

		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));

		Application.current.window.alert(errMsg, "Error!");
		Sys.exit(1);
	}
}
