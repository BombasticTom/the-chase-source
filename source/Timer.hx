package;

import flixel.text.FlxText;
import flixel.util.FlxAxes;

class Timer extends FlxText
{
	public var startTime:Int;
	public var curTime:Float;

	public var onComplete:() -> Void;

	public function start()
	{
		curTime = startTime;
		active = true;
	}

	public function pause()
	{
		active = false;
	}

	public function resume()
	{
		active = true;
	}

	override public function new(X:Float, Y:Float, Size:Int, startTime:Int = 60)
	{
		super(X, Y, 300, Utils.convToM(startTime), Size, true);

		this.startTime = startTime;

		font = "assets/Atenta-Medium.ttf";
		alignment = CENTER;
		screenCenter(FlxAxes.X);

		active = false;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		curTime -= elapsed;
		text = Utils.convToM(Math.ceil(curTime));

		if (curTime <= 0)
		{
			active = false;
			onComplete();
		}
	}

	override function destroy()
	{
		onComplete = null;
		super.destroy();
	}
}
