package;

import flixel.FlxState;
import flixel.FlxG;

class Warning extends MusicBeatState
{
    override public function create():Void
    {
        /*public function balls(name:String):Void { //dumbest mother fucker in the west B) -- Just Jack
			#if VIDEOS_ALLOWED
			var foundFile:Bool = false;
			var fileName:String = #if MODS_ALLOWED Paths.modFolders('videos/' + name + '.' + Paths.VIDEO_EXT); #else ''; #end
			#if sys
			if(FileSystem.exists(fileName)) {
				foundFile = true;
			}
            }
			#end

			if(!foundFile) {
				fileName = Paths.video(name);
				#if sys
				if(FileSystem.exists(fileName)) {
				#else
				if(OpenFlAssets.exists(fileName)) {
				#end
					foundFile = true;
				}
			}

			if(foundFile) {
				inCutscene = true;
				var bg = new FlxSprite(-FlxG.width, -FlxG.height).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
				bg.scrollFactor.set();
				bg.cameras = [camHUD];
				add(bg);

				(new FlxVideo(fileName)).finishCallback = function() {
					remove(bg);
					MusicBeatState.switchState(new TitleState());
				}
				return;
			} else {
				FlxG.log.warn('Couldnt find video file: ' + fileName);
			}
			#end
			MusicBeatState.switchState(new TitleState());
		}

        balls('PSA_Test_1')();
        super.create();*/
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }
}