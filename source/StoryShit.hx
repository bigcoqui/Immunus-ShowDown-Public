package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.graphics.frames.FlxAtlasFrames;

class StoryShit extends FlxSprite
{
    private var idleAnim:String;

    public function new(?X:Float = 0, ?Y:Float = 0, ?image:String, ?animArray:Array<String> = null, ?loop:Bool = false)
	{
		super(X, Y);

		if (animArray != null) {
			frames = Paths.getSparrowAtlas(image);
			for (i in 0...animArray.length) {
				var anim:String = animArray[i];
				animation.addByPrefix(anim, anim, 24, loop);
				if(idleAnim == null) {
					idleAnim = anim;
					animation.play(anim);
				}
			}
		} else {
			if(image != null) {
				loadGraphic(Paths.image(image));
			}
			active = false;
        }
        antialiasing = ClientPrefs.globalAntialiasing;
    }
    
    public function dance(?forceplay:Bool = false) {
		if(idleAnim != null) {
			animation.play(idleAnim, forceplay);
		}
	}
}