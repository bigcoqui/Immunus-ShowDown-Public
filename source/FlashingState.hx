package;

#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
//import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Assets;
import flixel.FlxCamera;
import openfl.utils.Assets as OpenFlAssets;

#if sys
import sys.FileSystem;
#end

using StringTools;

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;
	public var camHUD:FlxCamera;
	public var inCutscene:Bool = false;

	var daVideo:FlxVideo;
	var canAccept = false;

	override public function create():Void
	{
		FlxG.mouse.visible = false;

		var bg = new FlxSprite(-FlxG.width, -FlxG.height).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
		add(bg);

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		FlxG.cameras.add(camHUD);
		PlayerSettings.init();
		FlxG.save.bind('funkin', 'ninjamuffin99');
		ClientPrefs.loadPrefs();
		Highscore.load();

		startVideo('PSA_Test_1');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (inCutscene && controls.ACCEPT && ClientPrefs.seenvid)
		{
			startAndEnd();
		}
	}

	public function startVideo(name:String):Void {
		#if VIDEOS_ALLOWED
		var foundFile:Bool = false;
		var fileName:String = #if MODS_ALLOWED Paths.modFolders(SUtil.getPath() + 'videos/' + name + '.' + Paths.VIDEO_EXT); #else ''; #end
		#if sys
		if(FileSystem.exists(fileName)) {
			foundFile = true;
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

		new FlxTimer().start(1.5, function(tmr:FlxTimer)
		{
			canAccept = true;
		});

		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			if(foundFile) {
				inCutscene = true;
				var bg = new FlxSprite(-FlxG.width, -FlxG.height).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
				bg.scrollFactor.set();
				bg.cameras = [camHUD];
				add(bg);
	
				(daVideo = new FlxVideo(fileName)).finishCallback = function() {
					remove(bg);
					startAndEnd();
				}
				return;
			}
			else
			{
				FlxG.log.warn('Couldnt find video file: ' + fileName);
				startAndEnd();
			}
			#end
			startAndEnd();
		});
	}
}

	function startAndEnd()
	{
		inCutscene = false;
		daVideo.muted = true;
		daVideo.finishCallback = null;
		if(!ClientPrefs.seenvid)
			ClientPrefs.seenvid = true;
		ClientPrefs.saveSettings();
		MusicBeatState.switchState(new TitleState());
		leftState = true;
	}
}
package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width,
			"Hey, watch out!\n
			This Mod contains some flashing lights!\n
			Press ENTER to disable them now or go to Options Menu.\n
			Press ESCAPE to ignore this message.\n
			You've been warned!",
			32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);

                #if android
		addVirtualPad(NONE, A_B);
		#end
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			var back:Bool = controls.BACK;
			if (controls.ACCEPT || back) {
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				if(!back) {
					ClientPrefs.flashing = false;
					ClientPrefs.saveSettings();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxFlicker.flicker(warnText, 1, 0.1, false, true, function(flk:FlxFlicker) {
						new FlxTimer().start(0.5, function (tmr:FlxTimer) {
							MusicBeatState.switchState(new TitleState());
						});
					});
				} else {
					FlxG.sound.play(Paths.sound('cancelMenu'));
					FlxTween.tween(warnText, {alpha: 0}, 1, {
						onComplete: function (twn:FlxTween) {
							MusicBeatState.switchState(new TitleState());
						}
					});
				}
			}
		}
		super.update(elapsed);
	}
}
