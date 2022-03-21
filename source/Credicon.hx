package;

import flixel.FlxSprite;

class Credicon extends FlxSprite
{
	public var link:String;
	public var text:String;
	public var quote2:String;

	public function new(x:Float = 0, y:Float = 0, iconname:String = 'PooterStapot', ?linkname:String = 'https://twitter.com/Lillbirb', ?quote:String = 'balls')
	{
		super(x, y);
		scale.set(1.25,1.25);
		link = linkname;
		text = iconname;
		quote = quote2;
		loadGraphic(Paths.image('Credits Icons/' + iconname));
	}
}