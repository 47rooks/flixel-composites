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
		_o = new FlxObject(10, 200, 50, 100);
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
		
		Assert.equals(-25, s.origin.x);
		Assert.equals(20, s.origin.y);
	}
	
	function testScaleCallback():Void
	{
		_testCs.scale.set(2.0, 2.0);
		
		var s = cast(_testCs._compositeObject._members[2], FlxSprite);
		_testCs.update(0.016);

		Assert.equals(2.0, s.scale.x);
		Assert.equals(2.0, s.scale.y);
	}
	function testUpdateHitboxLR():Void
	{
		_testCs.updateHitbox();
		
		Assert.equals(60, _testCs.width);
		Assert.equals(300, _testCs.height);
	}
	
	function testUpdateHitboxUL():Void
	{
		_testCs.add(new FlxObject(-100, -50, 45, 20));
		_testCs.updateHitbox();
		
		Assert.equals(160, _testCs.width);
		Assert.equals(350, _testCs.height);
	}
	
	function testUpdateHitboxLL():Void
	{
		_testCs.add(new FlxObject(-100, 350, 45, 20));
		_testCs.updateHitbox();
		
		Assert.equals(160, _testCs.width);
		Assert.equals(370, _testCs.height);
	}
	
	function testUpdateHitboxUR():Void
	{
		_testCs.add(new FlxObject(100, -50, 45, 20));
		_testCs.updateHitbox();
		
		Assert.equals(145, _testCs.width);
		Assert.equals(350, _testCs.height);
	}
}