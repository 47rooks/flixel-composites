package;

import flixel.FlxSprite;
import flixel.composites.CompositeSprite;
import flixel.math.FlxPoint;

/**
 * Bird is a simple example CompositeSprite.
 */
class Bird extends CompositeSprite
{
	public function new(x:Float, y:Float):Void
	{
		super(x, y);
		
		var bird = new FlxSprite(0, 0);
		bird.loadGraphic('assets/bird.png');
		
		var leftFlare = new FlxSprite(13, 1);
		leftFlare.loadGraphic('assets/flare.png');
		var rightFlare = new FlxSprite(1, 13);
		rightFlare.loadGraphic('assets/flare.png');
		
		// Set center
		bird.updateHitbox();
		var mp = bird.getMidpoint();
		origin = FlxPoint.get(mp.x - bird.x, mp.y - bird.y);
		trace('origin=${origin}');
		
		add(bird);
		add(leftFlare);
		add(rightFlare);
	}
}