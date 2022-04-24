package;

import Controls.KeyboardScheme;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.utils.Assets;

class CreditsImmunus extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	var bgSamey:FlxSprite;
	var bgRambi:FlxSprite;
	var bgLurks:FlxSprite;
	var bgSal:FlxSprite;

	var desiredBG:Int = 0;

	var sectionname:Alphabet2;
	var name:Alphabet2;

	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	var box:FlxSprite;

	var credits:FlxTypedGroup<Credicon>;

	override function create()
	{
		FlxG.mouse.visible = true;
		bgSamey = new FlxSprite().loadGraphic(Paths.image('menuBG/menuBG'));
		bgSamey.alpha = 1;
		bgSamey.updateHitbox();
		bgSamey.screenCenter();
		bgSamey.antialiasing = ClientPrefs.globalAntialiasing;
		add(bgSamey);

		bgRambi = new FlxSprite().loadGraphic(Paths.image('menuBG/menuBGBlue'));
		bgRambi.alpha = 0;
		bgRambi.updateHitbox();
		bgRambi.screenCenter();
		bgRambi.antialiasing = ClientPrefs.globalAntialiasing;
		add(bgRambi);

		bgLurks = new FlxSprite().loadGraphic(Paths.image('menuBG/menuBGPink'));
		bgLurks.alpha = 0;
		bgLurks.updateHitbox();
		bgLurks.screenCenter();
		bgLurks.antialiasing = ClientPrefs.globalAntialiasing;
		add(bgLurks);

		sectionname = new Alphabet2(0, 0, 'Director', true);
		add(sectionname);
		sectionname.issection = true;

		name = new Alphabet2(0, 0, 'haha ur gay', true, false, 0.7,0.7);
		add(name);
		name.isname = true;

		var tex = Paths.getSparrowAtlas('Credits_Assets');

		leftArrow = new FlxSprite(300, 50);
		leftArrow.frames = tex;
		leftArrow.animation.addByPrefix('idle', "CreditSelect_Left1 instance 1");
		leftArrow.animation.addByPrefix('press', "CreditSelect_Left2 instance 1");
		leftArrow.animation.play('idle');
		leftArrow.antialiasing = ClientPrefs.globalAntialiasing;
		add(leftArrow);

		rightArrow = new FlxSprite(leftArrow.x + 575, leftArrow.y);
		rightArrow.frames = tex;
		rightArrow.animation.addByPrefix('idle', 'CreditSelect_Right1 instance 1');
		rightArrow.animation.addByPrefix('press', "CreditSelect_Right2 instance 1", 24, false);
		rightArrow.animation.play('idle');
		rightArrow.antialiasing = ClientPrefs.globalAntialiasing;
		add(rightArrow);

		credits = new FlxTypedGroup<Credicon>();
		add(credits);

		for (i in 0...42) {
			var iconthingy:Credicon = new Credicon();
			switch (i) {
				//director
				case 0:
					iconthingy = new Credicon(640, 375, 'PooterStapot', 'https://twitter.com/Lillbirb');
					iconthingy.screenCenter(X);
				//artist
				case 1:
					iconthingy = new Credicon(170, 375, 'OhSoVanilla', 'https://twitter.com/OhSoVanilla64');
				case 2:
					iconthingy = new Credicon(170 * 2, 375, 'Oni', 'https://twitter.com/OneilR_NG');
				case 3:
					iconthingy = new Credicon(170 * 3, 375, 'Offbi', 'https://twitter.com/Officiallythat2');
				case 4:
					iconthingy = new Credicon(170 * 4, 375, 'ButterInAToast', 'https://twitter.com/DMrbutter');
				case 5:
					iconthingy = new Credicon(170 * 5, 375, 'NemoInABottle', 'https://twitter.com/NemoInABottle');
				case 6:
					iconthingy = new Credicon(170 * 6, 375, 'Smorsi', 'https://twitter.com/SmorsiPan');
				case 7:
					iconthingy = new Credicon(170 * 2, 545, 'Teeth', 'https://twitter.com/teethlust');
				case 8:
					iconthingy = new Credicon(170 * 3, 545, 'PooterStapot', 'https://twitter.com/Lillbirb');
				case 9:
					iconthingy = new Credicon(170 * 4, 545, 'Wooked', 'https://twitter.com/the_wooked');
				case 10:
					iconthingy = new Credicon(170 * 5, 545, 'XenoToast', 'https://twitter.com/xeno_toast');
				//music
				case 11:
					iconthingy = new Credicon(170 * 2, 375, 'Addicted2Electronics', 'https://twitter.com/Addicted2Electr');
				case 12:
					iconthingy = new Credicon(170 * 3, 375, 'FuegO', 'https://twitter.com/Fueg0OnTop');
				case 13:
					iconthingy = new Credicon(170 * 4, 375, 'Kalpy', 'https://twitter.com/Kalpy19');
				case 14:
					iconthingy = new Credicon(170 * 5, 375, 'Saruky', 'https://twitter.com/Saruky__');
				case 15:
					iconthingy = new Credicon(595, 545, 'Galxe', 'https://twitter.com/atheri0nstudios');
				//coders
				case 16:
					iconthingy = new Credicon(170 * 2, 375, 'Shadowfi', 'https://twitter.com/Shadowfi1385');
				case 17:
					iconthingy = new Credicon(170 * 3, 375, 'BrightFyre', 'https://twitter.com/fyre_bright');
				case 18:
					iconthingy = new Credicon(170 * 4, 375, 'Ash', 'https://twitter.com/ash__i_guess_');
				case 19:
					iconthingy = new Credicon(170 * 5, 375, 'JustJack',  'https://twitter.com/Just_Jack6');
				case 20:
					iconthingy = new Credicon(170 * 3, 500005, '', '');
				case 21:
					iconthingy = new Credicon(200 * 2, 545, 'royal', 'https://twitter.com/CoderRoyal');
				case 22:
					iconthingy = new Credicon(200 * 3, 545, 'Hexar', 'https://twitter.com/hexpex4');
				case 23:
					iconthingy = new Credicon(200 * 4, 545, 'Kayya', 'https://twitter.com/Telethia_');
				//charters
				case 24:
					iconthingy = new Credicon(170 * 3, 500005, '', '');
				case 25:
					iconthingy = new Credicon(140 * 3, 375, 'Gibz', 'https://twitter.com/gibz679');
				case 26:
					iconthingy = new Credicon(150 * 4, 375, 'Pointy', 'https://twitter.com/PointyyESM');
				case 27:
					iconthingy = new Credicon(160 * 5, 375, 'Mathesu', 'https://twitter.com/MattPogg');
				//tester
				case 28:
					iconthingy = new Credicon(150 * 3, 500005, '', '');
				case 29:
					iconthingy = new Credicon(150 * 2, 375, 'aMaze', 'https://twitter.com/AmazeinG666');
				case 30:
					iconthingy = new Credicon(150 * 3, 375, 'Cammy', 'https://twitter.com/AnInternetsEcho');
				case 31:
					iconthingy = new Credicon(150 * 4, 375, 'Ellis', 'https://twitter.com/EllisBros');
				case 32:
					iconthingy = new Credicon(150 * 5, 375, 'MaxOke', 'https://twitter.com/Max0KE');
				case 33:
					iconthingy = new Credicon(150 * 6, 375, 'Philiplol', 'https://twitter.com/Philiplolz');
				case 34:
					iconthingy = new Credicon(170 * 2, 545, 'Trezzy', 'https://twitter.com/trezzyishere');
				case 35:
					iconthingy = new Credicon(170 * 3, 545, 'BigBand', 'https://twitter.com/VaChildish');
				case 36:
					iconthingy = new Credicon(170 * 4, 545, 'Ito', 'https://twitter.com/ItoSaihara_');
				case 37:
					iconthingy = new Credicon(170 * 5, 545, 'DusterBuster', 'https://twitter.com/SirDusterBuster');
				case 38:
					iconthingy = new Credicon(170 * 3, 500005, '', '');
				case 39:
					iconthingy = new Credicon(195 * 2, 375, 'shadowmario', 'https://twitter.com/Shadow_Mario_');
				case 40:
					iconthingy = new Credicon(195 * 3, 375, 'river', 'https://twitter.com/RiverOaken');
				case 41:
					iconthingy = new Credicon(195 * 4, 375, 'BBpanzu', 'https://twitter.com/bbsub3');	
			}
			iconthingy.antialiasing = ClientPrefs.globalAntialiasing;
			credits.add(iconthingy);
		}

		box = new FlxSprite(credits.members[0].x - 30, credits.members[0].y -25);
		box.frames = tex;
		box.animation.addByPrefix('idle', 'Selection_Box instance 1');
		box.animation.play('idle');
		box.antialiasing = ClientPrefs.globalAntialiasing;
		box.scale.set(1.1,1.1);
		add(box);

		bgFade();
		changeSelection(0);
		
				#if android
		addVirtualPad(LEFT_RIGHT, A_B);
		#end
			
		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.mouse.justPressed)
			{
				if (FlxG.mouse.overlaps(leftArrow))
				{
					changeSelection(-1);
				}
				if (FlxG.mouse.overlaps(rightArrow))
				{
					changeSelection(1);
				}
			}

		if (controls.UI_LEFT_P)
			{
				changeSelection(-1);
			}

			if (controls.UI_RIGHT_P)
			{
				changeSelection(1);
			}

			if (controls.BACK)
			{
				MusicBeatState.switchState(new MainMenuState());
				FlxG.mouse.visible = false;
			}
				
	

			switch (desiredBG)
			{
				case 1:
					bgSamey.alpha -= 0.005;
					bgRambi.alpha += 0.005;
				case 2:
					bgRambi.alpha -= 0.005;
					bgLurks.alpha += 0.005;
				case 3:
					bgLurks.alpha -= 0.005;
					bgSamey.alpha += 0.005;
			}

			if (controls.ACCEPT)
			{
			}

			for (i in credits) {
				if (FlxG.mouse.overlaps(i)) {
					if (i.alpha == 1)
						{
							box.x = i.x - 30;
							box.y = i.y - 25;
							name.reType(i.text,0.7,0.7);
							if (FlxG.mouse.justPressed) {
								#if linux
								Sys.command('/usr/bin/xdg-open', [i.link, "&"]);
								#else
								FlxG.openURL(i.link);
								#end
							}
						}
				}
			}
	}

	function changeSelection(change:Int = 0)
	{
		if (change == -1)
			{
				leftArrow.offset.y -= 20;
				leftArrow.animation.play('press');
				new FlxTimer().start(0.12, function(tmr:FlxTimer)
					{
						leftArrow.animation.play('idle');
						leftArrow.offset.y += 20;
					});
			}
		else
			{
				rightArrow.animation.play('press');
				rightArrow.offset.y -= 20;
				new FlxTimer().start(0.12, function(tmr:FlxTimer)
					{
						rightArrow.animation.play('idle');
						rightArrow.offset.y += 20;
					});
			}
			
		
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected == 7)
			curSelected = 0;
		if (curSelected == -1)
			curSelected = 6;

		switch (curSelected)
		{
			case 0:
				sectionname.reType('Director',1,1);
				name.reType(credits.members[0].text,0.7,0.7);
				for (i in 1...42) {
					credits.members[i].alpha = 0;
					}
				credits.members[0].alpha = 1;
				box.x = credits.members[0].x - 30;
				box.y = credits.members[0].y - 25;
			case 1:
				sectionname.reType('artists',1,1);
				name.reType(credits.members[1].text,0.7,0.7);
				for (i in 11...42) {
					credits.members[i].alpha = 0;
					}
				for (i in 1...11) {
					credits.members[i].alpha = 1;
					}
				credits.members[0].alpha = 0;
				box.x = credits.members[1].x - 30;
				box.y = credits.members[1].y - 25;
			case 2:
				sectionname.reType('Musicians',1,1);
				for (i in 16...42) {
					credits.members[i].alpha = 0;
					}
				for (i in 11...16) {
					credits.members[i].alpha = 1;
					}
				for (i in 1...11) {
					credits.members[i].alpha = 0;
					}
				credits.members[0].alpha = 0;
				box.x = credits.members[11].x - 30;
				box.y = credits.members[11].y - 25;
				name.reType(credits.members[11].text,0.7,0.7);
			case 3:
				sectionname.reType('coders',1,1);
				for (i in 25...42) {
					credits.members[i].alpha = 0;
					}
				for (i in 16...24) {
					credits.members[i].alpha = 1;
					}
				for (i in 1...16) {
					credits.members[i].alpha = 0;
					}
				credits.members[0].alpha = 0;
				box.x = credits.members[16].x - 30;
				box.y = credits.members[16].y - 25;
				name.reType(credits.members[16].text,0.7,0.7);
			case 4:
				sectionname.reType('charters',1,1);
				for (i in 29...42) {
					credits.members[i].alpha = 0;
					}
				for (i in 25...28) {
					credits.members[i].alpha = 1;
					}
				for (i in 1...24) {
					credits.members[i].alpha = 0;
					}
				credits.members[0].alpha = 0;
				box.x = credits.members[25].x - 30;
				box.y = credits.members[25].y - 25;
				name.reType(credits.members[25].text,0.7,0.7);
			case 5:
				sectionname.reType('testers',1,1);
				for (i in 0...28) {
					credits.members[i].alpha = 0;
					}
				for (i in 39...42) {
					credits.members[i].alpha = 0;
					}
				for (i in 29...38) {
					credits.members[i].alpha = 1;
					}
				credits.members[0].alpha = 0;
				box.x = credits.members[29].x - 30;
				box.y = credits.members[29].y - 25;
				name.reType(credits.members[29].text,0.7,0.7);
			case 6:
				sectionname.reType('psych',1,1);
				for (i in 0...38) {
					credits.members[i].alpha = 0;
					}
				for (i in 39...42) {
					credits.members[i].alpha = 1;
					}
				credits.members[0].alpha = 0;
				box.x = credits.members[38].x - 30;
				box.y = credits.members[38].y - 25;
				name.reType(credits.members[38].text,0.7,0.7);
			
		}

	}

	function bgFade()
	{
		new FlxTimer().start(8, function(tmr:FlxTimer)
		{
			desiredBG += 1;
			if (desiredBG >= 4)
				desiredBG = 1;
			trace(desiredBG);
			bgFade();
		});
	}
}
