package flixel.composites;

import flixel.FlxBasic;

/**
 * The composite interface definition 
 */
interface IComposite
{
	/**
	 * Add a member to this composite.
	 * 
	 * @param member the member to add
	 * @param name an optional name for the member
	 */
	public function add(member:FlxBasic, name:Null<String> = null):Void;
	
	/**
	 * Remove the member specified by reference to the original member object or by name.
	 * If both member and name are specified and they do not refer to the same member
	 * an exception will be thrown.
	 * 
	 * @param member the member to remove
	 * @param name the name of the member
	 */
	public function remove(member:Null<FlxBasic> = null, name:Null<String> = null):Void;
}
