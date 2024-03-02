package;

import flixel.FlxG;
import flixel.FlxState;

class BaseState extends FlxState
{
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (FlxG.keys.justReleased.ESCAPE)
		{
			FlxG.switchState(MenuState.new);
		}
	}
}