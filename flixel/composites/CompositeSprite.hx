package flixel.composites;

import flixel.FlxBasic;
import flixel.FlxSprite;

class CompositeSprite extends FlxSprite implements IComposite
{
	var _members:Array<FlxBasic>;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		_members = new Array<FlxBasic>();
	}

	public function add(member:FlxBasic, ?name:String) {}

	public function remove(?member:FlxBasic, ?name:String) {}
}
