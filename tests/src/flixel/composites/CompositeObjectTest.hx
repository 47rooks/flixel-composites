package flixel.composites;

import utest.Assert;
import utest.Test;

/**
 * FlxObject subclass test class.
 */
class SubObject extends FlxObject {}

/**
 * FlxBasic subclass test class.
 */
class SubBasic extends FlxBasic {}

/**
 * CompositeObject unit tests.
 */
@:access(flixel.composites.CompositeObject)
class CompositeObjectTest extends Test
{
	var _testCo:CompositeObject;
	
	function setup():Void
	{
		_testCo = new CompositeObject(5, 15);
		var b = new FlxBasic();
		var o = new FlxObject(10, 200);
		var s = new FlxSprite(50, 30);
		
		_testCo.add(b);
		_testCo.add(o);
		_testCo.add(s);
	}
	
	function testCreate():Void
	{
		Assert.notNull(_testCo);
	}
	
	function testDestroy():Void
	{
		_testCo.destroy();
		Assert.isFalse(_testCo.exists);
	}
	
	function testKill():Void
	{
		_testCo.kill();
		Assert.isFalse(_testCo.alive);
	}
	
	function testAdd():Void
	{
		Assert.equals(3, _testCo._members.length);
		Assert.isOfType(_testCo._members[0], FlxBasic);
		Assert.isOfType(_testCo._members[1], FlxObject);
		Assert.isOfType(_testCo._members[2], FlxSprite);
	}
	
	function testToString()
	{
		Assert.equals('(CompositeObject: (x: 5 | y: 15 | w: 0 | h: 0 | visible: true | velocity: (x: 0 | y: 0)) | memberCount: 3)', _testCo.toString());
	}
	
	function testAddSubclass():Void
	{
		var so = new SubObject();
		var sb = new SubBasic();
		
		_testCo.add(so);
		_testCo.add(sb);
		
		Assert.isOfType(_testCo._members[3], SubObject);
		Assert.isOfType(_testCo._members[4], SubBasic);
	}

	function testUpdateMember():Void
	{
		_testCo._updateMember(_testCo._members[1], _testCo._memberData[1]);

		Assert.equals(15, cast(_testCo._members[1], FlxObject).x);
		Assert.equals(215, cast(_testCo._members[1], FlxObject).y);
	}

	function testUpdate():Void {
		_testCo.update(0.016);

		Assert.equals(15, cast(_testCo._members[1], FlxObject).x);
		Assert.equals(215, cast(_testCo._members[1], FlxObject).y);

		Assert.equals(55, cast(_testCo._members[2], FlxObject).x);
		Assert.equals(45, cast(_testCo._members[2], FlxObject).y);
	}
}
