package;

import flixel.FlxG;
import flixel.FlxState;
import haxe.ui.containers.VBox;
import haxe.ui.events.MouseEvent;
import haxe.ui.events.UIEvent;

@:build(haxe.ui.ComponentBuilder.build("assets/main-view.xml"))
class MainView extends VBox
{
	@:bind(gamemodeBar, UIEvent.CHANGE)
	function change(e:UIEvent)
	{
		stack1.selectedIndex = gamemodeBar.selectedIndex;

		var curState:FlxState;
		switch (stack1.selectedIndex) // MORE modes planned for later
		{
			case 1:
				curState = new PrvaRunda();
			default:
				curState = new PlayState();
		}

		FlxG.switchState(curState);
	}

	@:bind(timer, MouseEvent.CLICK)
	function toggle(e:MouseEvent)
	{
		PrvaRunda.promentiTimer(timer.selected);
		timer.selected ? FlxG.sound.music.resume() : FlxG.sound.music.pause();
	}

	@:bind(sum, MouseEvent.CLICK)
	function addSum(e:MouseEvent)
	{
		PrvaRunda.dodajSumu();
	}

	@:bind(endgame, MouseEvent.CLICK)
	function e_endgame(e:MouseEvent)
	{
		PrvaRunda.endGame();
	}
}
