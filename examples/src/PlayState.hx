package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.composites.CompositeSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * This state provides a basic example of composite movements.
 */
class PlayState extends BaseState
{
	var _testCo:CompositeSprite;
	
	public function new()
	{
		super();
		
		_testCo = _createComposite();
		add(_testCo);
		_createHelp();
	}
	
	function _createComposite():CompositeSprite
	{
		var co = new CompositeSprite(100, 100);
		var big = new FlxSprite(100, 100);
		big.makeGraphic(100, 200, FlxColor.RED);
		
		var small = new FlxSprite(190, 90);
		small.makeGraphic(20, 20, FlxColor.BLUE);
		
		var small2 = new FlxSprite(190, 290);
		small2.makeGraphic(20, 20, FlxColor.GREEN);
		
		co.add(big);
		co.add(small);
		co.add(small2);
		
		co.origin.set(big.x + big.width / 2.0, big.y + big.height / 2.0);
		co.updateHitbox();
		
		return co;
	}
	
	function _createHelp():Void
	{
		var help = new FlxText(10, FlxG.height - 30, "WASD - movement. SHIFT-A/D - rotate CCW, CW. CTRL-UP/DOWN/1 - scale up/down - 1 resets to 1.0 scale.",
			20);
		add(help);
	}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.pressed.SHIFT)
		{
			// Rotation
			if (FlxG.keys.pressed.A)
			{
				_testCo.angle -= 10;
			}
			if (FlxG.keys.pressed.D)
			{
				_testCo.angle += 10;
			}
		}
		else if (FlxG.keys.pressed.CONTROL)
		{
			// Scaling
			if (FlxG.keys.pressed.UP)
			{
				_testCo.scale.x += 0.1;
				_testCo.scale.y += 0.1;
			}
			if (FlxG.keys.pressed.DOWN)
			{
				_testCo.scale.x -= 0.1;
				_testCo.scale.y -= 0.1;
			}
			if (FlxG.keys.justReleased.NUMPADONE)
			{
				_testCo.scale.x = 1.0;
				_testCo.scale.y = 1.0;
			}
		}
		else
		{
			// Position
			if (FlxG.keys.pressed.W)
			{
				_testCo.y -= 10;
			}
			if (FlxG.keys.pressed.S)
			{
				_testCo.y += 10;
			}
			if (FlxG.keys.pressed.A)
			{
				_testCo.x -= 10;
			}
			if (FlxG.keys.pressed.D)
			{
				_testCo.x += 10;
			}
		}
		super.update(elapsed);
	}
}