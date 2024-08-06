package;

import flixel.FlxSprite;
import flixel.composites.CompositeSprite;
import flixel.math.FlxPoint;

/**
 * Bird is a simple example CompositeSprite.
 */
class BigBird extends CompositeSprite
{
	public static final BIRD_ANGLE = 135;
	
	var _speed:Float = 0.0;
	
	public function new(x:Float, y:Float):Void
	{
		super(x, y);
		
		var bird = new FlxSprite(0, 0);
		bird.loadGraphic('assets/bigBird.png');
		
		var leftFlare = new FlxSprite(128, 32);
		leftFlare.loadGraphic('assets/bigFlare.png');
		var rightFlare = new FlxSprite(32, 128);
		rightFlare.loadGraphic('assets/bigFlare.png');
		var noseFlare = new FlxSprite(-80, -80);
		noseFlare.loadGraphic('assets/bigFlare.png');
		
		// Set center
		bird.updateHitbox();
		var mp = bird.getMidpoint();
		origin = FlxPoint.get(mp.x - bird.x, mp.y - bird.y);
		
		add(bird);
		add(leftFlare);
		add(rightFlare);
		add(noseFlare);
	}
	
	public function updateSpeed(deltaVel:FlxPoint):Void
	{
		velocity.addPoint(deltaVel);
		var len = Math.round(velocity.length / 10) * 10;
		velocity.normalize();
		velocity *= len;
	}
	
	public function updateVelocity():Void
	{
		velocity.setPolarDegrees(velocity.length, angle - BIRD_ANGLE);
	}
}
