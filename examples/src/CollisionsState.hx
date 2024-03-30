package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.composites.CompositeSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

/**
 * Path following example.
 */
class CollisionsState extends BaseState
{
	var _bigBird:BigBird;
	var _littleBird:CompositeSprite;
	var _bg:FlxSprite;
	var _s:FlxSprite;
	var _debugCenter:FlxSprite;
	var _blockEmitter:FlxEmitter;
	var _block:FlxSprite;
	
	override public function create()
	{
		_bg = new FlxSprite();
		_bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.CYAN);
		add(_bg);
		
		_bigBird = new BigBird(0, 0);
		_bigBird.angle = BigBird.BIRD_ANGLE;
		_bigBird.screenCenter();
		_bigBird.updateHitbox();
		add(_bigBird);
		
		_s = new FlxSprite();
		_s.loadGraphic('assets/bird.png');
		_s.origin.set(4, 4);
		_s.angle = 45;
		_s.scale.set(1.0, 1.0);
		_s.updateHitbox();
		_s.setPosition(100, 100);
		add(_s);
		
		_debugCenter = new FlxSprite();
		_debugCenter.makeGraphic(2, 2, FlxColor.WHITE);
		add(_debugCenter);
	}
	
	override public function update(elapsed:Float):Void
	{
		FlxG.collide(_bigBird.getSingleCollider(), _blockEmitter);
		
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.W)
		{
			_bigBird.updateSpeed(FlxPoint.get().setPolarDegrees(10.0, _bigBird.angle - BigBird.BIRD_ANGLE));
		}
		if (FlxG.keys.justPressed.S)
		{
			_bigBird.updateSpeed(FlxPoint.get().setPolarDegrees(-10.0, _bigBird.angle - BigBird.BIRD_ANGLE));
		}
		if (FlxG.keys.pressed.D)
		{
			_bigBird.angle = (_bigBird.angle + 10.0);
			_bigBird.updateHitbox();
		}
		if (FlxG.keys.pressed.A)
		{
			_bigBird.angle = (_bigBird.angle - 10.0);
			_bigBird.updateHitbox();
		}
		
		if (FlxG.keys.pressed.CONTROL)
		{
			// Scaling
			if (FlxG.keys.pressed.UP)
			{
				_bigBird.scale.x += 0.1;
				_bigBird.scale.y += 0.1;
				_bigBird.updateHitbox();
			}
			if (FlxG.keys.pressed.DOWN)
			{
				_bigBird.scale.x -= 0.1;
				_bigBird.scale.y -= 0.1;
				_bigBird.updateHitbox();
			}
			if (FlxG.keys.justReleased.NUMPADONE)
			{
				_bigBird.scale.x = 1.0;
				_bigBird.scale.y = 1.0;
				_bigBird.updateHitbox();
			}
		}
		if (FlxG.keys.justPressed.I)
		{
			_s.scale.set(_s.scale.x * 1.1, _s.scale.y * 1.1);
			_s.updateHitbox();
		}
		if (FlxG.keys.justPressed.K)
		{
			_s.scale.set(_s.scale.x / 1.1, _s.scale.y / 1.1);
			_s.updateHitbox();
		}
		if (FlxG.keys.pressed.O)
		{
			_s.angle = _s.angle + 10.0;
			_s.updateHitbox();
		}
		if (FlxG.keys.pressed.U)
		{
			_s.angle = _s.angle - 10.0;
			_s.updateHitbox();
		}
		
		if (FlxG.mouse.justReleased)
		{
			spawnBlocks();
		}
		_debugCenter.setPosition(_s.x + _s.origin.x - 1, _s.y + _s.origin.y - 1);
	}
	
	function spawnBlocks():Void
	{
		if (_blockEmitter != null)
		{
			remove(_blockEmitter);
		}
		var m = FlxG.mouse.getPosition();
		var birdMp = _bigBird.getMidpoint();
		var a = m.degreesTo(FlxPoint.get(birdMp.x, birdMp.y));
		trace('launchAngle=${a}, bb.x=${birdMp.x}, bb.y=${birdMp.y}, m=${m}');
		
		_blockEmitter = new FlxEmitter(m.x, m.y, 20);
		_blockEmitter.launchMode = CIRCLE;
		_blockEmitter.launchAngle.set(a - 15, a + 15);
		_blockEmitter.setSize(10, 10);
		_blockEmitter.makeParticles(10, 10, FlxColor.BLACK);
		_blockEmitter.speed.set(40, 80);
		_blockEmitter.allowCollisions = ANY;
		_blockEmitter.lifespan.set(5, 5);
		add(_blockEmitter);
		_blockEmitter.start(true, 0.1);
	}
}