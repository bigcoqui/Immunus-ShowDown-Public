package;

import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class HealthIcon2 extends FlxSprite
{
	public var sprTracker:FlxSprite;
	private var isOldIcon:Bool = false;
	private var isPlayer:Bool = false;
	private var char:String = '';

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		isOldIcon = (char == 'bf-old');
		this.isPlayer = isPlayer;
		changeIcon(char);									//PlayState.
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}

	private var iconOffsets:Array<Float> = [0, 0];
	public function changeIcon(char:String) {
		if(this.char != char) {
					var file:FlxAtlasFrames = Paths.getSparrowAtlas('icons/icon-samey5');
					frames = file;
					
					animation.addByPrefix(char, 'Meltdown_HealthIcon_Neutral', 24, true);
					animation.play(char);
				}
			//}
		}
	}
