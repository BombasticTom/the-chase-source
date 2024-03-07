package;

class Utils
{
	public static function padNumber(value:Int, length:Int):String
	{
		var strValue:String = Std.string(value);
		while (strValue.length < length)
		{
			strValue = "0" + strValue;
		}
		return strValue;
	}

	public static function separateDigits(num:String, separator:String = "."):String
	{
		var str:String = '';
		var len:Int = num.length;
		for (i in 0...len)
		{
			var idx:Int = len - i - 1;
			if (i > 0 && i % 3 == 0)
				str = separator + str;
			str = num.charAt(idx) + str;
		}
		return str;
	}

	public static function convToM(s:Int):String
	{
		var m:Int = Math.floor(s / 60);
		s %= 60;
		return '$m:${padNumber(s, 2)}';
	}
}
