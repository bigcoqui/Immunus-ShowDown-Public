package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;
	public var nextDialogueThing:Void->Void = null;
	public var skipDialogueThing:Void->Void = null;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	var boxgf:FlxSprite;
	var boxbf:FlxSprite;
	var boxdad:FlxSprite;
	var playedbfbox:Bool = false;
	var playeddadbox:Bool = false;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = true;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear instance 1', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH instance 1', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn instance 1', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		portraitLeft = new FlxSprite();
		portraitLeft.frames = Paths.getSparrowAtlas('dialogue/samey/Samey_Portrait');
		portraitLeft.animation.addByPrefix('sad', 'Port1', 24, false);
		portraitLeft.animation.addByPrefix('normal', 'Port2', 24, false);
		portraitLeft.animation.addByPrefix('worry', 'Port3', 24, false);
		portraitLeft.animation.addByPrefix('snapped', 'Port4', 24, true);
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite();
		portraitRight.frames = Paths.getSparrowAtlas('dialogue/Immunus_Showdown_Boyfriend_Portraits');
		portraitRight.animation.addByPrefix('normal', 'BF_Portrait1 instance 1', 24, false);
		portraitRight.animation.addByPrefix('huh', 'BF_Portrait2 instance 1', 24, false);
		portraitRight.animation.addByPrefix('corrupt', 'BF_Portrait3 instance 1', 24, false);
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
		
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();

		box.screenCenter(X);
		portraitLeft.screenCenter(X);

		boxbf = new FlxSprite();
		boxbf.frames = Paths.getSparrowAtlas('dialogue/BF_Dialogue_Boxes');
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'sighlenced':
				boxbf.animation.addByPrefix('normalOpen', 'BF_Box_SighLenced_1', 24, false);
				boxbf.animation.addByIndices('normal', 'BF_Box_SighLenced_1', [3], "", 24);
			case 'alerted':
				boxbf.animation.addByPrefix('normalOpen', 'BF_Box_Alerted_1', 24, false);
				boxbf.animation.addByIndices('normal', 'BF_Box_Alerted_1', [3], "", 24);
			case 'meltdown':
				boxbf.animation.addByPrefix('normalOpen', 'BF_Box_Meltdown_1', 24, false);
				boxbf.animation.addByIndices('normal', 'BF_Box_Meltdown_1', [3], "", 24);
		}
		boxbf.alpha = 0;
		boxbf.screenCenter();
		boxbf.scale.set(1.8, 1.8);
		boxbf.antialiasing = true;
		add(boxbf);

		boxdad = new FlxSprite();
		boxdad.frames = Paths.getSparrowAtlas('dialogue/samey/Samey_Dialogue_Boxes');
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'sighlenced':
				boxdad.animation.addByPrefix('normalOpen', 'SighLenced_Box_1.png', 24, false);
				boxdad.animation.addByIndices('normal', 'SighLenced_Box_1.png', [3], "", 24);
			case 'alerted':
				boxdad.animation.addByPrefix('normalOpen', 'Alerted_Box_1.png', 24, false);
				boxdad.animation.addByIndices('normal', 'Alerted_Box_1.png', [3], "", 24);
			case 'meltdown':
				boxdad.animation.addByPrefix('normalOpen', 'Meltdown_Box_1.png', 24, false);
				boxdad.animation.addByIndices('normal', 'Meltdown_Box_1.png', [3], "", 24);
		}
		boxdad.alpha = 0;
		boxdad.screenCenter();
		boxdad.scale.set(1.8,1.8);
		boxdad.antialiasing = true;
		add(boxdad);
		boxdad.y += 100;
		boxbf.y += 100;
		boxdad.x += 25;
		boxbf.x += 25;

		boxdad.animation.play('normalOpen');
		boxbf.animation.play('normal');

		portraitLeft.screenCenter(X);
		portraitRight.screenCenter(X);
		portraitLeft.x -= 250;
		portraitLeft.y += 230;
		portraitRight.x += 230;
		portraitRight.y += 220;

		handSelect = new FlxSprite(1042, 590).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		handSelect.setGraphicSize(Std.int(handSelect.width * PlayState.daPixelZoom * 0.9));
		handSelect.updateHitbox();
		handSelect.visible = false;


		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = Paths.font("ccwild words roman.ttf");
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = Paths.font("ccwild words roman.ttf");
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dialogue'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;
	var dialogueEnded:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.visible = false;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (boxbf.animation.curAnim != null)
		{
			if (boxbf.animation.curAnim.name == 'normalOpen' && boxbf.animation.curAnim.finished)
			{
				boxbf.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (boxdad.animation.curAnim != null)
		{
			if (boxdad.animation.curAnim.name == 'normalOpen' && boxdad.animation.curAnim.finished)
			{
				boxdad.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}
		
		#if android
                var justTouched:Bool = false;

		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				justTouched = true;
			}
		}
		#end

		if(PlayerSettings.player1.controls.ACCEPT #if android || justTouched #end)
		{
			if (dialogueEnded)
			{
				remove(dialogue);
				if (dialogueList[1] == null && dialogueList[0] != null)
				{
					if (!isEnding)
					{
						isEnding = true;
						FlxG.sound.play(Paths.sound('dialogueClose'), 0.8);	

						if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
							FlxG.sound.music.fadeOut(1.5, 0);

						new FlxTimer().start(0.2, function(tmr:FlxTimer)
						{
							box.alpha -= 1 / 5;
							boxdad.alpha -= 1 / 5;
							boxbf.alpha -= 1 / 5;
							bgFade.alpha -= 1 / 5 * 0.7;
							portraitLeft.visible = false;
							portraitRight.visible = false;
							swagDialogue.alpha -= 1 / 5;
							handSelect.alpha -= 1 / 5;
							dropText.alpha = swagDialogue.alpha;
						}, 5);

						new FlxTimer().start(1.5, function(tmr:FlxTimer)
						{
							finishThing();
							kill();
						});
					}
				}
				else
				{
					dialogueList.remove(dialogueList[0]);
					startDialogue();
					FlxG.sound.play(Paths.sound('dialogueClose'), 0.8);
				}
			}
			else if (dialogueStarted)
			{
				FlxG.sound.play(Paths.sound('dialogueClose'), 0.8);
				swagDialogue.skip();
				
				if(skipDialogueThing != null) {
					skipDialogueThing();
				}
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);
		swagDialogue.completeCallback = function() {
			handSelect.visible = true;
			dialogueEnded = true;
		};

		handSelect.visible = false;
		dialogueEnded = false;
		switch (curCharacter)
		{
			case 'samey':
				portraitLeft.offset.y = 20;
				portraitRight.visible = false;
				portraitLeft.visible = true;
				portraitLeft.animation.play('normal');
				boxdad.alpha = 1;
				boxbf.alpha =0;
				if (!playeddadbox)
					{
						boxdad.animation.play('normalOpen');
						playeddadbox = true;
					}
					else
					{
						boxdad.animation.play('normal');
					}
			case 'samey-sad':
				portraitLeft.offset.y = -3;
				portraitRight.visible = false;
				portraitLeft.visible = true;
				portraitLeft.animation.play('sad');
				boxdad.alpha = 1;
				boxbf.alpha =0;
				if (!playeddadbox)
					{
						boxdad.animation.play('normalOpen');
						playeddadbox = true;
					}
					else
					{
						boxdad.animation.play('normal');
					}
			case 'samey-worry':
				portraitLeft.offset.y = 10;
				portraitRight.visible = false;
				portraitLeft.visible = true;
				portraitLeft.animation.play('worry');
				boxdad.alpha = 1;
				boxbf.alpha =0;
				if (!playeddadbox)
					{
						boxdad.animation.play('normalOpen');
						playeddadbox = true;
					}
					else
					{
						boxdad.animation.play('normal');
					}
			case 'samey-snapped':
				portraitLeft.offset.y = 125;
				portraitRight.visible = false;
				portraitLeft.visible = true;
				portraitLeft.animation.play('snapped');
				boxdad.alpha = 1;
				boxbf.alpha =0;
				if (!playeddadbox)
					{
						boxdad.animation.play('normalOpen');
						playeddadbox = true;
					}
					else
					{
						boxdad.animation.play('normal');
					}
			case 'bf':
				portraitLeft.visible = false;
				portraitRight.visible = true;
				portraitRight.animation.play('normal');
				boxdad.alpha = 0;
				boxbf.alpha =1;
				if (!playedbfbox)
					{
						boxbf.animation.play('normalOpen');
						playedbfbox = true;
					}
					else
					{
						boxbf.animation.play('normal');
					}
			case 'bf-huh':
				portraitLeft.visible = false;
				portraitRight.visible = true;
				portraitRight.animation.play('huh');
				boxdad.alpha = 0;
				boxbf.alpha =1;
				if (!playedbfbox)
					{
						boxbf.animation.play('normalOpen');
						playedbfbox = true;
					}
					else
					{
						boxbf.animation.play('normal');
					}
			case 'bf-corrupt':
				portraitLeft.visible = false;
				portraitRight.visible = true;
				portraitRight.animation.play('corrupt');
				boxdad.alpha = 0;
				boxbf.alpha =1;
				if (!playedbfbox)
					{
						boxbf.animation.play('normalOpen');
						playedbfbox = true;
					}
					else
					{
						boxbf.animation.play('normal');
					}
		}
		if(nextDialogueThing != null) {
			nextDialogueThing();
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
