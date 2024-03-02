package flixel.composites;

import utest.Assert;
import utest.Test;

/**
 * FlxSprite subclass test class.
 */
class SubSprite extends FlxSprite {}

/**
 * CompositeObject unit tests.
 */
@:access(flixel.composites.CompositeObject)
@:access(flixel.composites.CompositeSprite)
class CompositeSpriteTest extends Test
{
	var _testCs:CompositeSprite;
	var _b:FlxBasic;
	var _o:FlxObject;
	var _s:FlxSprite;
	
	function setup():Void
	{
		_testCs = new CompositeSprite(5, 15);
		_b = new FlxBasic();
		_o = new FlxObject(10, 200);
		_s = new FlxSprite(50, 30);
		
		_testCs.add(_b);
		_testCs.add(_o);
		_testCs.add(_s);
	}
	
	function testCreate():Void
	{
		Assert.notNull(_testCs);
	}
	
	function testDestroy():Void
	{
		_testCs.destroy();
		Assert.isFalse(_testCs.exists);
		Assert.isNull(_testCs.origin);
		Assert.isNull(_testCs.scale);
	}
	
	function testOriginCallback():Void
	{
		_testCs.origin.set(_o.width / 2.0, _o.height / 2.0);
		
		var s = cast(_testCs._compositeObject._members[2], FlxSprite);
		_testCs.update(0.016);
		
		Assert.equals(-50, s.origin.x);
		Assert.equals(-30, s.origin.y);
	}
	
	function testScaleCallback():Void
	{
		_testCs.scale.set(2.0, 2.0);
		
		var s = cast(_testCs._compositeObject._members[2], FlxSprite);
		_testCs.update(0.016);

		Assert.equals(2.0, s.scale.x);
		Assert.equals(2.0, s.scale.y);
	}
	// FIXME - add hitbox update tests
}