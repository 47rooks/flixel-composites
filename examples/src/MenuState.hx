package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.ui.FlxUIButton;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * MenuState provides a menu page for composite examples.
 */
class MenuState extends FlxState
{
	static final LEFT_X = 10;
	static final TOP_Y = 10;
	static final LINE_Y = 60;
	static final TITLE_Y = 80;
	static final DESC_X = 220;
	static final TEXT_LENGTH = 450;
	
	static final COL_1_X = DESC_X + TEXT_LENGTH + 20;
	
	public static final BASE_FONT_SIZE = 16;
	static final TITLE_FONT_SIZE = 48;
	static final SUBTITLE_FONT_SIZE = 36;
	
	var _column_y_value:Array<Int>;
	
	override public function create()
	{
		super.create();
		_column_y_value = new Array<Int>();
		
		// Set the font, rather globally
		FlxAssets.FONT_DEFAULT = "assets/fonts/OpenSans-Regular.ttf";
		
		// Add menu of demos
		_column_y_value[0] = TOP_Y;
		var title = new FlxText(LEFT_X, _column_y_value[0], "Composite Demos", 48);
		add(title);
		
		_column_y_value[0] += TITLE_Y;
		
		addMenuItem(0, "Simple movement", () ->
		{
			FlxG.switchState(PlayState.new);
		}, "WASD movement, SHIFT-A/D rotation, CTRL-UP/DOWN/1 scale");
		
		_column_y_value[0] += LINE_Y;
		
		addMenuItem(0, "Path following", () ->
		{
			FlxG.switchState(PathFollowingState.new);
		}, "Path following examples");
		
		#if desktop
		_column_y_value[0] += 2 * LINE_Y;
		
		add(new FlxText(LEFT_X, _column_y_value[0], "Hit <ESC> to exit the demo", BASE_FONT_SIZE));
		#end
	}
	
	/**
	 * Add an item consisting of one FlxUIButton and a FlxText description.
	 * 
	 * It will handle making them all consistent and centering the button in the description row.
	 * @param columnNum which column to add the elemnt to
	 * @param buttonLabel label for the button
	 * @param buttonCbk the callback to for the button click operation
	 * @param description the description of the demo that the button will launch
	 */
	private function addMenuItem(columnNum:Int, buttonLabel:String, buttonCbk:Void->Void, description:String)
	{
		var buttonX = if (columnNum == 0) LEFT_X else COL_1_X;
		var descX = if (columnNum == 0) DESC_X else COL_1_X + DESC_X - LEFT_X;
		
		var button = new FlxUIButton(buttonX, _column_y_value[columnNum], buttonLabel, buttonCbk);
		var desc = new FlxText(descX, _column_y_value[columnNum], TEXT_LENGTH, description, BASE_FONT_SIZE);
		button.resize(200, 40);
		button.y = _column_y_value[columnNum] + (desc.height - button.height) / 2;
		button.setLabelFormat(14, FlxColor.BLACK, FlxTextAlign.CENTER);
		add(button);
		add(desc);
	}
	
	#if desktop
	/**
	 * Override the DemoState update function to make the program exit if ESCAPE is hit.
	 * @param elapsed the elapsed time since the last update call.
	 */
	override public function update(elapsed:Float)
	{
		if (FlxG.keys.justReleased.ESCAPE)
		{
			Sys.exit(0);
		}
		
		super.update(elapsed);
	}
	#end
}