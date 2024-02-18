package flixel.composites;

import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.composites.CompositeObject;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil;

typedef SpriteMemberData =
{
	var clazz:Class<FlxBasic>;
	var relativeOrigin:FlxPoint;
}

/**
 * A CompositeSprite supports all functions of a FlxSprite with the addition that
 * it contains member FlxSprites. The members function in a subordinate way to the
 * composite. The exact nature of action is determined by the operation. For example
 * scaling occurs from the same central point within the composite, thus making the
 * composite act as one large sprite would. Likewise rotation. All member properties
 * are derived from the composite properties. Thus member position is relative
 * to the composite position.
 * 
 * Currently there is no notion of what it means to compose sprites and so this
 * layer is only to record sprite-level data that affects orientation and scaling
 * and so on. In this composites system the CompositeObject uses its object nature
 * while CompositeSprite does not use its sprite nature. This feels like it
 * will be a problem later but we'll see.
 * 
 * CompositeSprite delegates to a CompositeObject to store and manipulate members
 * because it cannot use extension. This is a result of the fact that FlxSprite
 * and FlxObject must be extended to permit the Composite*s to be used in 
 * the same places and the non-composite forms. This is because flixel does not
 * use its interface definitions IFlxObject and IFlxSprite.
 */
@:access(flixel.composites.CompositeObject)
class CompositeSprite extends FlxSprite implements IComposite
{
	var _compositeObject:CompositeObject;
	var _memberData:Array<SpriteMemberData>; // member data for FlxSprite types
	
	public function new(x:Float, y:Float)
	{
		super(x, y);
		_compositeObject = new CompositeObject(x, y);
		_memberData = new Array<SpriteMemberData>();
		
		origin = new FlxCallbackPoint(originCallback);
		scale = new FlxCallbackPoint(scaleCallback);
		
		scale.set(1.0, 1.0);
	}
	
	override public function update(elapsed:Float):Void
	{
		// Update Composite itself first then update the members
		// using the new values of the composite.
		super.update(elapsed);
		
		_compositeObject.update(elapsed);
		
		// This will duplicate updates for FlxSprite members
		for (i => m in _compositeObject._members)
		{
			if (m.exists && m.active && m is FlxSprite)
			{
				_updateMember(m, _memberData[i]);
				
				m.update(elapsed);
			}
		};
	}
	
	function _updateMember(member:FlxBasic, data:SpriteMemberData):Void
	{
		if (member is FlxSprite)
		{
			var m = cast(member, FlxSprite);
			m.origin = data.relativeOrigin;
		}
	}
	
	override public function draw():Void
	{
		// Do not call super.draw() as this FlxSprite is a container object
		// to implement the FlxSprite interface and store composite-level
		// sprite data. But it is to have no visualization itself.
		
		_compositeObject.draw();
	}
	
	function originCallback(new_origin:FlxPoint):Void
	{
		// This will duplicate updates for FlxSprite members
		for (i => m in _compositeObject._members)
		{
			if (m.exists && m.active && m is FlxSprite)
			{
				var s = cast(m, FlxSprite);
				_memberData[i].relativeOrigin = new FlxPoint(x + origin.x - s.x, y + origin.y - s.y);
			}
		}
	}
	
	function scaleCallback(new_scale:FlxPoint):Void
	{
		// This will duplicate updates for FlxSprite members
		for (i => m in _compositeObject._members)
		{
			if (m.exists && m.active && m is FlxSprite)
			{
				var s = cast(m, FlxSprite);
				s.scale = new_scale;
				// _memberData[i].relativeScale = new FlxPoint(x + origin.x - s.x, y + origin.y - s.y);
			}
		}
	}
	
	// ---- Overrides for the FlxBasic behaviours
	
	/*   FlxBasic needs full review but so far.

		I don't think any properties need overriding
		flixelType will be the object type not the composite which is in theory
			what we want. If not then a new type will be required which would be tricky from outside.
			Hopefully not needed.

		function destroy():Void; - there may need to be explicit destroy code

		function kill():Void; - this should kill all objects in the composite
		function revive():Void; - this should revive all objects in the composite

		function toString():String; - probably should be specialized for the composite

		At the moment actually there is no good reason to override kill() or revive().
	 */
	override public function destroy():Void
	{
		origin = FlxDestroyUtil.destroy(origin);
		scale = FlxDestroyUtil.destroy(scale);
		
		super.destroy();
	}
	
	// ---- End of FlxBasic overrides
	// ---- Overrides for the FlxObject behaviours
	// FIXME Is this override required ?
	
	/*
		Object properties
		x,y -> simple additive
		width, height -> computed from members or arbitrarially set
						 likely updateHitbox() has to be called - cannot be auto
						 unless there is a flag.
		pixelperfectrender -> per object, default in composite ?? FIXME
		pixelperfectposition -> per object, default in composite ?? FIXME
		angle -> simple additive
		moves -> per object, default follows composite ? (hard to do and requires addressing then to override)
		immovable -> per object
		solid -> per object
		scrollfactor -> simple additive, perhaps multiplicative - how do it work ?
		velocity -> simple additive
		acceleration -> simple additive
		drag -> simple additive
		maxVelocity -> composite wide cap ?
		last -> per object
		mass -> in theory additive from content but as it's really primitive not sure.
		elasticity -> per object - only relates to collisions and thus depends on collision model
				if single collider then only composite. If per object collider then who knows
					don't think we can just add naturally from the group
		angularVelocity -> simple additive
		angularAcceleration -> simple additive
		angularDrag -> simple additive
		maxAngular -> composite wide cap
		health -> odd anyway but likely just health of the composite. If you want internal algos to
				sum member health that will be tricky.
		touching -> composite - what about in member-wise hitbox case - is this determined by member overlaps ?
		wasTouching -> composite - same here
		allowCollisions -> composite - and here.
		collisionXDrag -> composite
		collisionYDrag -> composite
		debugBoundingBox* colors -> per object
		ignoreDrawDebug -> per object
		path -> composite

		overlaps() -> likely leave alone for now.
		overlapsAt() -> likely leave alone for now.
		overlapsPoint() ->  likely leave alone for now.
		inWorldBounds() ->  likely leave alone for now.
		getScreenPosition() ->  likely leave alone for now.
		getPosition() -> likely leave alone for now.
		getMidPoint() ->  likely leave alone for now.
		getHitbox() ->  likely leave alone for now.

		function reset(X:Float, Y:Float):Void; -> composite for sure - may need to reset all below
				this could be involved. Need to try it and see.

		isOnScreen() ->  likely leave alone for now.
		isPixelPerfectRender() -> likely leave for now.

		isTouching() -> inline - cannot override - may not be needed but we'll see
		justTouched() -> inline - cannot override - may not be needed but we'll see

		hurt() -> strictly don't care but likely leave alone for now.
		screencenter() -> likely leave alone for now.
		setPosition() ->  likely leave alone for now.
		setSize() ->  likely leave alone for now.

		drawDebug() -> override to trigger debug draws on members
		drawDebugOnCamera() ->  likely leave alone for now.

		getRotatedBounds() ->  likely leave alone for now.
		toString() -> FlxObject toString() does not use super.toString() so we cannot compose all data
			probably we want to call super.toString() and add to it but actually may have to just
			duplicate the content as it's not designed for additive content
	 */
	/*
	 * Setter override must set this sprite's position and delegate to the composite path.
	 * This is a kind of poor man's multiple inheritence.
	 * Note, if this sprite's own value is not updated the we cannot move because we do not
	 * remember the current value. This approach will be needed for all properties that
	 * are used like this.
	 */
	@:noCompletion
	override function set_x(value:Float):Float
	{
		if (_compositeObject == null)
		{
			return x = value;
		}
		return x = _compositeObject.x = value;
	}
	
	@:noCompletion
	override function set_y(value:Float):Float
	{
		if (_compositeObject == null)
		{
			return y = value;
		}
		return y = _compositeObject.y = value;
	}
	
	// ---- End of FlxObject overrides
	// ---- Overrides for the FlxSprite behaviours ----
	
	/*
		useFramePixels - no override
		antialiasing - no override - memberwise
		frameWidth - no override - memberwise
		frameHeight - no override - memberwise
		frames - no override - memberwise
		graphic - no override - memberwise
		bakedRotationAngle - no override - memberwise -> perhaps additive

		color -> probably pass on to members
		colorTransform -> likely memberwise - no override

		clipRect -> no override - memberwise clipping - might be hard to support though.
			are clipRects sizes/pos relative ?
		shader (not a property or function just a var) -> this probably only makes sense memberwise.
			But .... would it be drawn on
			before the members - I don't know when a shader be applied in the scheme of things.
			do we need to add a separate pass to get it to be applied after the draw of the members ?

		var alpha(default, set):Float; -> simple additive - could be multiplicative
		var facing(default, set):FlxDirectionFlags; -> yes must set facing on all members and reposition
		flipX  -> yes must set facing on all members and reposition
		flipY  -> yes must set facing on all members and reposition

		var origin(default, null):FlxPoint; override and set for all members
		var offset(default, null):FlxPoint; -> simple additive
		var scale(default, null):FlxPoint; -> simple multiplicative
		blendmode -> likely leave alone for now.


		initVars() -> it would be more consistent with current design to override this function and 
			initialize my stuff there. Technically this is a FlxObject override
		clone() -> not necessary - this is not a true copy constructor - it's just creating another sprite
			with the same graphic. It could be done but it would have to create and clone all sprites but
			I don't know how useful it would be if it didn't really clone positions and so on.

		There are questions about the sprite graphics and frames. Fundamentally yuo would expect the
		member sprites to be initialized fully before being added to the composite. And:
			1. should the composite if a CompositeSprite be allowed to load images and frames and run animations ?
			2. How do you handle the image size versus the aggregate bounding box of the members ? Scale, clip, do nothing ?

			loadGraphicFromSprite(), loadGraphic(), loadRotatedGraphic(), loadRotatedFrame() not necessary
				there is some copying done here - offset baking etc. called by clone()
				could be implemented but would require a lot of work.
			makeGraphic - no
			graphicLoaded - no
			resetSize - no
			resetFrameSize -no
			resetSizeFromFrame - no
			resetFrame - no
			setGraphicSize - no
			stamp() - no
			drawFrame() - no

		updateHitbox() -> currently based on framesize of the sprite. But here would likely have to consider
			the aggregate bounding box of the members
		resetHelpers() -> maybe if the composite introduces more - must call super if so.

		update() -> defo must be overridden but only to add function
			must call super()
		draw() -> defo override to draw members - members will not be added to the state
			directly. call super.draw() first so it is always behind the members.

		centerOffsets() -> this is likely a problem related to hitbox sizing. Need to be careful here.
		centerOrigin() -> no - inline so cannot be overridden but likely don't want to anyway

		replaceColor() ->  likely leave alone for now. But it's possible
		setColorTransform() -> likely leave alone for now. But it's possible
		updateColorTransform() -> likely leave alone for now. But it's possible
		pixelsOverlapPoint() -> likely leave alone for now. I don't know if there is a memberPixelsOverlapPoint() concept that's useful
		getPixelAt() -> Yes this might have to return the pixel of a member.
		getPixelAtScreen() -> Yes this might have to return the pixel of a member.
		transformWorldToPixels() -> Yes this might just be wrong on without modification.
		transformWorldToPixelsSimple() -> Yes this might just be wrong on without modification.
		transformScreenToPixels() -> Yes this might just be wrong on without modification.
		updateFramePixels() -> likely leave alone for now.
		getGraphicMidpoint() -> likely leave alone for now.
		isOnScreen() -> likely leave alone for now.
		isSimpleRender() -> likely leave alone for now.
		isSimpleRenderBlit() -> likely leave alone for now.
		getRotatedBounds() -> if width and height are properly set this should just work
		getScreenBounds() -> if width and height are properly set this should just work
		setFacingFlip() -> no should just work on composite though the value set will affect members
		setFrames() -> likely leave alone for now.

	 */
	@:noCompletion
	override function set_angle(Value:Float):Float
	{
		var ret = super.angle = Value;
		
		if (_compositeObject != null)
		{
			_compositeObject.angle = Value;
		}
		return ret;
	}
	
	// ---- End of FlxSprite overrides ----
	
	public function add(member:FlxBasic, ?name:String)
	{
		// Process the new member and store
		var md = _processNewMember(member);
		_memberData.push(md);
		
		_compositeObject.add(member, name);
	}
	
	function _processNewMember(member:FlxBasic):SpriteMemberData
	{
		if (member is FlxSprite)
		{
			var m = cast(member, FlxSprite);
			return {
				clazz: FlxSprite,
				relativeOrigin: new FlxPoint(m.width / 2.0, m.height / 2.0)
			};
		}
		return {
			clazz: FlxBasic,
			relativeOrigin: new FlxPoint(0, 0)
		};
	}
	
	public function remove(?member:FlxBasic, ?name:String) {}
}
