package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUIButton;
import flixel.composites.CompositeSprite;
import flixel.math.FlxPoint;
import flixel.path.FlxPath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

/**
 * Path following example.
 */
class PathFollowingState extends BaseState
{
	var _bird:CompositeSprite;
	var _path:FlxPath;
	var _pathPoints:Array<FlxPoint>;
	var _button:FlxUIButton;
	var _bg:FlxSprite;
	
	override public function create()
	{
		_bg = new FlxSprite();
		_bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.CYAN);
		add(_bg);
		
		_pathPoints = new Array<FlxPoint>();
		_path = new FlxPath();
		_path.immovable = false;
		_path.autoRotate = true;
		_path.centerMode = ORIGIN;
		_path.angleOffset = 135;
		_path.onComplete = (p) ->
		{
			// Reset path
			_pathPoints.resize(0);
		};
		
		_bird = new Bird(0, 0);
		_bird.path = _path;
		// _bird.origin.set(8, 8);
		_bird.angle = 135;
		_bird.screenCenter();
		_bird.setSize(16, 16); // updateHitbox() and add() need to sort out a hitbox size
		_bird.updateHitbox();
		add(_bird);
		
		_createHelp();
		_button = new FlxUIButton(600, FlxG.height - 30, "Start", () ->
		{
			_path.start(_pathPoints, 400, FORWARD, true);
		});
		add(_button);
	}
	
	function _createHelp():Void
	{
		var help = new FlxText(10, FlxG.height - 30, "Click to place points on the path, click start to have bird follow the path", 20);
		help.addFormat(new FlxTextFormat(FlxColor.BLACK));
		add(help);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (!_path.active && FlxG.mouse.justReleased)
		{
			var p = FlxG.mouse.getPosition();
			if (_pathPoints.length > 0)
			{
				var s = _pathPoints[_pathPoints.length - 1];
				FlxSpriteUtil.drawLine(_bg, s.x, s.y, p.x, p.y, {color: FlxColor.BLACK});
			}
			_pathPoints.push(FlxG.mouse.getPosition());
		}
	}
}