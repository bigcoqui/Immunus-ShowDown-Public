package;

import flixel.input.gamepad.FlxGamepad;
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.addons.text.FlxTypeText;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
#if FEATURE_DISCORD
import Discord.DiscordClient;
#end

using StringTools;

class IntroThingy extends MusicBeatState
{

	static var dialogue:Array<String> = [
		"Dear Boyfriend.",
		"I've grown real tired of my parents pestering you for being together with me!",
		"It's gone over 7 whole weeks where monsters, goons and even my own game have tried to take us both down.",
		"So I propose that we could go somewhere off town!",
		"To a place where only you and I can spend some time together for once, without anyone interupting us.",

		"And I know just the place for that~",
		"Oh, and if you're wondering why exactly I'm writing you this letter is ",
		"because of my father...",

		"I realised that he's been using my phone to see our future plans together,",
		"and I really don't want him to interfere this time.",

		"Either way, I hope to see you there~",
		"Love, GF~"
	];

	var c1:FlxSprite;
	var c2:FlxSprite;
	var c3:FlxSprite;
	var box:FlxSprite;


	var dropdia:FlxText;
	var dia:FlxTypeText;
	var dialogueint:Int = 0;

	override function create()
	{

			FlxG.sound.playMusic(Paths.music('introduction_music'));

			c1 = new FlxSprite(-600, -300).loadGraphic(Paths.image('Cutscenes/CUT_1', 'shared'));
			c1.alpha = 0;
			c1.screenCenter();
			add(c1);

			c2 = new FlxSprite(-600, -300).loadGraphic(Paths.image('Cutscenes/CUT_2', 'shared'));
			c2.alpha = 0;
			c2.screenCenter();
			add(c2);

			c3 = new FlxSprite(-600, -300).loadGraphic(Paths.image('Cutscenes/CUT_3', 'shared'));
			c3.alpha = 0;
			c3.screenCenter();
			add(c3);

			box = new FlxSprite();
			box.frames = Paths.getSparrowAtlas('dialogueassets/week1/GF_Dialogue_Boxes', 'shared');
			box.animation.addByPrefix('normalOpen', 'GF_Box_1.png',24,false);
			box.animation.addByIndices('normal', 'GF_Box_1.png', [3], "", 24);
			box.alpha = 0;
			box.screenCenter();
			box.y += 100;
			box.x += 30;
			box.scale.set(2,1.8);
			box.antialiasing = true;
			add(box);

			FlxTween.tween(c1, {alpha: 1}, 2, {startDelay: 0.1,ease: FlxEase.linear});

			dia = new FlxTypeText(140, 500, Std.int(FlxG.width * 0.75), "", 32);
			dia.font = Paths.font("ccwild words roman.ttf");
			dia.color = 0xFF3F2021;
			dia.sounds = [FlxG.sound.load(Paths.sound('sound'), 0.7)];
			dia.height = dia.height + 0.5;
			add(dia);

			dropdia = new FlxText(142, 502, Std.int(FlxG.width * 0.75), "", 32);
			dropdia.font = Paths.font("ccwild words roman.ttf");
			dropdia.color = 0xFFD89494;
			dropdia.height = dia.height;
			add(dropdia);
		
				#if android
		addVirtualPad(NONE, A);
		#end

			super.create();
	}
	
	override function update(elapsed:Float)
	{
			dropdia.text = dia.text;

			if (controls.BACK)
			{
				FlxG.switchState(new StoryMenuState());
				StoryMenuState.camefromintro = true;
			}

			if (controls.ACCEPT)
			{
				//FlxG.sound.play(Paths.sound('clickText'), 0.8);
				if (dialogueint != 0)
					{
						dialogueint++;
						box.animation.play('normal');
					}
				else
					{
						box.animation.play('normalOpen');
						box.alpha = 0.9;
					}

				updatedia();
			}

		super.update(elapsed);
	}

	function updatedia() {
		dia.resetText(dialogue[dialogueint]);
		dia.start(0.04, true);

		if (dialogueint == 0)
			{
				dialogueint++;
			}

		switch (dialogueint)
		{
			case 5:
				FlxTween.tween(c1, {alpha: 0}, 2, {startDelay: 0.1,ease: FlxEase.linear});
				FlxTween.tween(c2, {alpha: 1}, 2, {startDelay: 0.1,ease: FlxEase.linear});
			case 8:
				FlxTween.tween(c2, {alpha: 0}, 2, {startDelay: 0.1,ease: FlxEase.linear});
				FlxTween.tween(c3, {alpha: 1}, 2, {startDelay: 0.1,ease: FlxEase.linear});
			case 10:
				FlxTween.tween(c3, {alpha: 0}, 1, {startDelay: 0.1,ease: FlxEase.linear});
			case 12:
				FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function()
					{
						//dia.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0)];
						FlxG.switchState(new StoryMenuState());
						StoryMenuState.camefromintro = true;
					});
				
		}
	}
	}
