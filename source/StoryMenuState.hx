package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.FlxSprite;
import haxe.Json;
import openfl.system.System;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import flixel.graphics.FlxGraphic;
import WeekData;
import openfl.Assets;
using StringTools;

class StoryMenuState extends MusicBeatState
{
	// Wether you have to beat the previous week for playing this one
	// Not recommended, as people usually download your mod for, you know,
	// playing just the modded week then delete it.
	// defaults to True
	public static var weekCompleted:Map<String, Bool> = new Map<String, Bool>();

	var scoreText:FlxText;

	var specialAnim:Bool = false;

	private static var lastDifficultyName:String = '';
	public static var ADDSHIT:String =  '';
	var curDifficulty:Int = 1;

	var txtWeekTitle:FlxText;
	var bgSprite:FlxSprite;

	private static var curWeek:Int = 0;

	public static var camefromintro:Bool = false;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var confirmTimer:Float;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	var lock:FlxSprite;

	var thingie = false;

	
	//probably better to make a class for this lol
	var chapters:Array<String> = [
		'Introduction',
		'Tutorial',
		'Chapter1',
		'Chapter2'
	];
	var storyCharacter:Array<String> = [
		'',
		'penter',
		'samey',
		'none'
	];

	var playerCharacter:Array<String> = [
		'',
		'bf',
		'bf',
		'bf'
	];

	var showScore:Array<Bool> = [
		false,
		true,
		true,
		true
	];

	var chapterTitles:Array<String> = [
		'',
		'',
		'RACING THOUGHT ANXIETY',
		'INHUMAN RIVALRY'
	];

	var trackName:Array<String> = [
		'',
		'Penter_Intro_Tracknames',
		'Samey_Chapter1_Tracknames',
		'Rambi_Chapter2_Tracknames'
	];

	var tracksText:FlxSprite;
	var grpTracksText:FlxTypedGroup<FlxSprite>;
	var grpChapters:FlxTypedGroup<FlxSprite>;
	var grpChapterText:FlxTypedGroup<FlxSprite>;
	var grpStoryCharacters:FlxTypedGroup<FlxSprite>;
	var grpPlayerCharacters:FlxTypedGroup<FlxSprite>;
	var grpDifficulties:FlxTypedGroup<FlxSprite>;
	var selectArrow:FlxSprite;
	var titleText:FlxText;

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		PlayState.isStoryMode = true;
		WeekData.reloadWeekFiles(true);
		if(curWeek >= WeekData.weeksList.length) curWeek = 0;
		persistentUpdate = persistentDraw = true;

		

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("vcr.ttf"), 32);
		//rankText.size = scoreText.size;
		rankText.screenCenter(X);

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		var bgYellow:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 386, 0xFFF9CF51);
		bgSprite = new FlxSprite(0, 56);
		bgSprite.antialiasing = ClientPrefs.globalAntialiasing;

		grpWeekText = new FlxTypedGroup<MenuItem>();
		//add(grpWeekText);

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		//add(blackBarThingie);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		grpLocks = new FlxTypedGroup<FlxSprite>();
		//add(grpLocks);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		for (i in 0...WeekData.weeksList.length)
		{
			WeekData.setDirectoryFromWeek(WeekData.weeksLoaded.get(WeekData.weeksList[i]));
			var weekThing:MenuItem = new MenuItem(0, bgSprite.y + 396, WeekData.weeksList[i]);
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);

			weekThing.screenCenter(X);
			weekThing.antialiasing = ClientPrefs.globalAntialiasing;
			// weekThing.updateHitbox();

			// Needs an offset thingie
			if (weekIsLocked(i))
			{
				var lock:FlxSprite = new FlxSprite(0, 50);
				lock.frames = Paths.getSparrowAtlas('Week Selection Assets/immunus_showdown_campaign_menu_UI_assets_yes');
				lock.animation.addByPrefix('lock', 'Lock instance 1');
				lock.animation.play('lock');
				lock.screenCenter(X);
				lock.ID = i;
				lock.antialiasing = ClientPrefs.globalAntialiasing;
				//grpLocks.add(lock);
			}
		}

		WeekData.setDirectoryFromWeek(WeekData.weeksLoaded.get(WeekData.weeksList[0]));
		var charArray:Array<String> = WeekData.weeksLoaded.get(WeekData.weeksList[0]).weekCharacters;
		for (char in 0...3)
		{
			var weekCharacterThing:MenuCharacter = new MenuCharacter((FlxG.width * 0.25) * (1 + char) - 150, charArray[char]);
			weekCharacterThing.y += 70;
			grpWeekCharacters.add(weekCharacterThing);
		}

		difficultySelectors = new FlxGroup();
		//add(difficultySelectors);

		

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		if(lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));
	
		

		//add(bgYellow);
		//add(bgSprite);
		//add(grpWeekCharacters);

		var tracksSprite:FlxSprite = new FlxSprite(FlxG.width * 0.07, bgSprite.y + 425).loadGraphic(Paths.image('Menu_Tracks'));
		tracksSprite.antialiasing = ClientPrefs.globalAntialiasing;
		//add(tracksSprite);

		
		// add(rankText);
		//add(scoreText);
		//add(txtWeekTitle);

		

		super.create();

		grpChapters = new FlxTypedGroup<FlxSprite>();
		add(grpChapters);

		grpChapterText = new FlxTypedGroup<FlxSprite>();
		add(grpChapterText);

		grpStoryCharacters = new FlxTypedGroup<FlxSprite>();
		add(grpStoryCharacters);

		grpPlayerCharacters = new FlxTypedGroup<FlxSprite>();
		add(grpPlayerCharacters);

		grpDifficulties = new FlxTypedGroup<FlxSprite>();
		add(grpDifficulties);

		grpTracksText = new FlxTypedGroup<FlxSprite>();
		add(grpTracksText);

		for (i in storyCharacter) {
			var char:FlxSprite = new FlxSprite();
			char.frames = Paths.getSparrowAtlas('Week Selection Assets/Menu_Week_Selection_Assets');
			switch (i) {
				case '':
					char = new FlxSprite();
					char.visible = false;
				case 'samey':
					char.setPosition(0, 60);
					char.animation.addByPrefix('idle', 'Samey_Silhouette instance 10', 24, true);
					char.animation.addByPrefix('enter', 'Samey_Silhouette instance 20', 24, false);
				case 'penter':
					char.setPosition(-90, 120);
					
					char.animation.addByPrefix('idle', 'PenterBounce instance 1', 24, true);
				case 'none':
					char.setPosition(25, 220);
					char.animation.addByPrefix('idle', 'Unknown opponent instance 1', 24, true);
			}
			if(i == '')
				char.animation.play('idle');
			grpStoryCharacters.add(char);
		}

		for (i in playerCharacter) {
			var char:FlxSprite = new FlxSprite();
			char.frames = Paths.getSparrowAtlas('Week Selection Assets/Menu_Week_Selection_Assets');
			switch (i) {
				case '':
					char = new FlxSprite();
					char.visible = false;
				case 'bf':
					char.setPosition(995, 120);
					char.animation.addByPrefix('idle', 'BF_Silhouette instance 1', 24, true);
			}
			char.animation.play('idle');
			grpPlayerCharacters.add(char);
		}

		for (i in trackName) {
			var txt:FlxSprite = new FlxSprite();
			txt.loadGraphic(Paths.image('Week Selection Assets/' + i));
			switch (i) {
				case '':
					txt = new FlxSprite();
					txt.visible = false;
				case 'Samey_Chapter1_Tracknames':
					txt.setPosition(15, 571);
				case 'Penter_Intro_Tracknames':
					txt.setPosition(7, 571);
				case 'Rambi_Chapter2_Tracknames':
					txt.setPosition(7, 576);
			}
			grpTracksText.add(txt);
		}

		for (i in chapters) {
			var chapter:FlxSprite = new FlxSprite().loadGraphic(Paths.image('Week Selection Assets/Week_Selection_' + i));
			grpChapters.add(chapter);

			var text:FlxSprite = new FlxSprite(467, 104);
			text.frames = Paths.getSparrowAtlas('Week Selection Assets/immunus_showdown_campaign_menu_UI_assets_yes');
			switch (i) {
				case 'Chapter1':
					text.animation.addByPrefix('idle', 'Chapter_1 instance 1', 24, true);
					text.animation.addByPrefix('selected', 'Chapter_1_Selected instance 1', 24, true);
				case 'Chapter2':
					text.y -= 1;
					text.animation.addByPrefix('idle', 'Chapter_2 instance 1', 24, true);
					text.animation.addByPrefix('selected', 'Chapter_2_Selected instance 1', 24, true);
				case 'Tutorial':
					text.setPosition(464, 104);
					text.animation.addByPrefix('idle', 'Chapter_Tutorial instance 1', 24, true);
					text.animation.addByPrefix('selected', 'Chapter_Tutorial_Selected instance 1', 24, true);
				case 'Introduction':
					text.setPosition(525, 104);
					text.animation.addByPrefix('idle', 'Chapter_Intro instance 1', 24, true);
					text.animation.addByPrefix('selected', 'Chapter_Intro_Selected instance 1', 24, true);
			}
			text.animation.play('idle');
			grpChapterText.add(text);
			//text.screenCenter(X);
		}
		
		var path = SUtil.getPath() + Paths.getPreloadPath("images/gfDanceTitle.json");
		var titleJSON = Json.parse(Assets.getText(SUtil.getPath() + path));
		Conductor.changeBPM(103);

		for (i in 0...3) {
			var diff:FlxSprite = new FlxSprite(1036, 493);
			diff.frames = Paths.getSparrowAtlas('Week Selection Assets/immunus_showdown_campaign_menu_UI_assets_yes');
			switch (i) {
				case 0:
					diff.setPosition(1036, 493);
					diff.animation.addByPrefix('idle', 'Normal_Sorrow instance 1', 0, false);
				case 1:
					diff.setPosition(1058, 498);
					
					diff.animation.addByPrefix('idle', 'Hard_Fury instance 1', 0, false);
				case 2:
					diff.setPosition(1034, 502);
					diff.animation.addByPrefix('idle', 'Medley_Hollow instance 1', 0, false);
			}
			diff.animation.play('idle');
			grpDifficulties.add(diff);
		} 

		leftArrow = new FlxSprite(1036, 642);
		leftArrow.frames = Paths.getSparrowAtlas('Week Selection Assets/immunus_showdown_campaign_menu_UI_assets_yes');
		leftArrow.animation.addByPrefix('idle', 'Select_Arrow_Left instance 1');
		leftArrow.animation.addByPrefix('selected', 'Select_Arrow_Clicked_Left instance 1');
		leftArrow.antialiasing = ClientPrefs.globalAntialiasing;
		add(leftArrow);

		rightArrow = new FlxSprite(1203, 642);
		rightArrow.frames = Paths.getSparrowAtlas('Week Selection Assets/immunus_showdown_campaign_menu_UI_assets_yes');
		rightArrow.animation.addByPrefix('idle', 'Select_Arrow_Right instance 1');
		rightArrow.animation.addByPrefix('selected', 'Select_Arrow_Clicked_Right instance 1');
		rightArrow.antialiasing = ClientPrefs.globalAntialiasing;
		add(rightArrow);

		lock = new FlxSprite(0, 200);
		lock.frames = Paths.getSparrowAtlas('Week Selection Assets/immunus_showdown_campaign_menu_UI_assets_yes');
		lock.animation.addByPrefix('lock', 'Lock instance 1');
		lock.animation.play('lock');
		lock.screenCenter(X);
		lock.alpha = 0;
		lock.antialiasing = ClientPrefs.globalAntialiasing;
		add(lock);

		txtTracklist = new FlxText(140, 500, 0, "", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = Paths.font("CCWildWordsRoman.tff");
		txtTracklist.color = 0xFFA64DC0;
		//add(txtTracklist);

		titleText = new FlxText(0, 23, 0, "", 32);
		titleText.setFormat(Paths.font("pain.ttf"), 40, 0xFFFFFFFF, CENTER);
		add(titleText);

		scoreText = new FlxText(30, 27, 0, "", 20);
		scoreText.setFormat(Paths.font("pain.ttf"), 28, 0xFFFFFFFF, CENTER);
		add(scoreText);

		var selectArrowframes = Paths.getSparrowAtlas('Week Selection Assets/Campaign_Arrow_Assets');
		selectArrow = new FlxSprite();
		selectArrow.frames = selectArrowframes;
		selectArrow.animation.addByPrefix('idle', 'Arrow_1_anim');
		selectArrow.animation.addByPrefix('pressed', "Arrow_2_Anim", 24, false);
		selectArrow.animation.play('idle');
		selectArrow.scale.set(0.7,0.7);
		selectArrow.antialiasing = ClientPrefs.globalAntialiasing;
		add(selectArrow);

		tracksText = new FlxSprite(64, 507).loadGraphic(Paths.image('Week Selection Assets/Tracks'));
		add(tracksText);

		grpChapterText.forEach(function(chap:FlxSprite)
		{
			chap.alpha = 1;

			if(chap.ID != curWeek)
				chap.alpha = 0.8;
		});

		
		changeWeek();
		changeDifficulty();
		
		#if android
		addVirtualPad(FULL, A_B)
		#end
	}

	override function closeSubState() {
		persistentUpdate = true;
		changeWeek();
		super.closeSubState();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// scoreText.setFormat('VCR OSD Mono', 32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 30, 0, 1)));
		if(Math.abs(intendedScore - lerpScore) < 10) lerpScore = intendedScore;

		scoreText.text = "CHAPTER SCORE:" + lerpScore;

		// FlxG.watch.addQuick('font', scoreText.font);

		//difficultySelectors.visible = !weekIsLocked(curWeek);

		if (!movedBack && !selectedWeek)
		{
			var upP = controls.UI_UP_P;
			var downP = controls.UI_DOWN_P;
			if (upP && curWeek != 0)
			{
				changeWeek(-1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}

			if (downP && curWeek != chapters.length - 1)
			{
				changeWeek(1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}

			if (controls.UI_LEFT)
				leftArrow.animation.play('selected');
			else 
				leftArrow.animation.play('idle');

			if (controls.UI_RIGHT)
				rightArrow.animation.play('selected');
			else 
				rightArrow.animation.play('idle');
			
			if (controls.UI_RIGHT_P && curDifficulty != CoolUtil.difficulties.length - 1)
				changeDifficulty(1);
			else if (controls.UI_LEFT_P && curDifficulty != 0)
				changeDifficulty(-1);
			else if (upP || downP)
				changeDifficulty();
			else if(controls.RESET)
			{
				persistentUpdate = false;
				openSubState(new ResetScoreSubState('', curDifficulty, '', curWeek));
				//FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			else if (controls.ACCEPT)
			{
				thingie = true;
				if (!weekIsLocked(curWeek))
				{
					selectArrow.animation.play('pressed');
					selectArrow.x -= 20;
					selectArrow.y -= 15;
				}
				selectWeek();
			}
		}

		if (camefromintro)
		{
			new FlxTimer().start(0.8, function(tmr:FlxTimer)
				{
					changeWeek(1);
				});
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			Conductor.changeBPM(103);
			camefromintro = false;
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			MusicBeatState.switchState(new MainMenuState());
		}
		for (i in grpChapterText)
			i.color = FlxColor.interpolate(i.color, FlxColor.WHITE, 0.23);
		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (curWeek == 0)
		{
			new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					FlxG.switchState(new IntroThingy());
				});
			if (stopspamming == false)
				{
					FlxG.sound.play(Paths.sound('confirmMenu'));
	
					grpStoryCharacters.members[curWeek].animation.play('enter');
					grpChapterText.members[curWeek].animation.play('selected');
					FlxFlicker.flicker(grpChapterText.members[curWeek], 3, 0.15, false);

					if(ClientPrefs.flashing) grpWeekText.members[curWeek].startFlashing();
					//grpWeekCharacters.members[0].animation.play('samey-stare');
					stopspamming = true;
				}
		} else
		{
			if (curDifficulty == 2 && !weekIsLocked(curWeek))
			{	
					//grpWeekCharacters.members[0].x += 5;
					if (stopspamming == false)
						{
							FlxG.sound.play(Paths.sound('confirmMenu'));
			
							grpStoryCharacters.members[curWeek].animation.play('enter');
							grpChapterText.members[curWeek].animation.play('selected');
							FlxFlicker.flicker(grpChapterText.members[curWeek], 1.1, 0.15, false);
		
							if(ClientPrefs.flashing) grpWeekText.members[curWeek].startFlashing();
							stopspamming = true;
							idkpootertoldmetodothis();
						}
				}
				
			else if (!weekIsLocked(curWeek))
				{
					if (stopspamming == false)
					{
						FlxG.sound.play(Paths.sound('confirmMenu'));
		
						grpChapterText.members[curWeek].animation.play('selected');
						FlxFlicker.flicker(grpChapterText.members[curWeek], 1.1, 0.15, false);
		
						if(ClientPrefs.flashing) grpWeekText.members[curWeek].startFlashing();
						grpStoryCharacters.members[curWeek].animation.play('enter', true);
						//specialAnim = true;
						stopspamming = true;
					}
		
					// We can't use Dynamic Array .copy() because that crashes HTML5, here's a workaround.
					var songArray:Array<String> = [];
					var leWeek:Array<Dynamic> = WeekData.weeksLoaded.get(WeekData.weeksList[curWeek]).songs;
					for (i in 0...leWeek.length) {
						songArray.push(leWeek[i][0]);
					}
		
					// Nevermind that's stupid lmao
					PlayState.storyPlaylist = songArray;
					PlayState.isStoryMode = true;
					selectedWeek = true;
		
					var diffic = CoolUtil.getDifficultyFilePath(curDifficulty);
					if(diffic == null) diffic = '';
		
					PlayState.storyDifficulty = curDifficulty;
		
					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
					PlayState.campaignScore = 0;
					PlayState.campaignMisses = 0;
					new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						LoadingState.loadAndSwitchState(new PlayState(), true);
						FreeplayState.destroyFreeplayVocals();
					});
				} else {
					FlxG.sound.play(Paths.sound('cancelMenu'));
				}
		}
	}

	function idkpootertoldmetodothis() {
	var black:FlxSprite = new FlxSprite().makeGraphic(1280 * 2, 1280 * 2, FlxColor.BLACK);
	black.scrollFactor.set();
	black.screenCenter();
	black.alpha = 0;
	add(black);
	FlxTween.tween(black,{alpha: 1},4 ,{ease: FlxEase.expoInOut});

	var thing:FlxSprite;
	thing = new FlxSprite().loadGraphic(Paths.image('poot_la_creatura'));
	thing.alpha = 0;
	thing.updateHitbox();
	thing.screenCenter();
	thing.antialiasing = true;
	add(thing);

	FlxG.sound.music.fadeOut(5.5,0);

	new FlxTimer().start(5.5, function(tmr:FlxTimer)
		{
			thing.alpha = 1;
			FlxG.sound.play(Paths.sound('vineboom'));
			new FlxTimer().start(0.25, function(tmr:FlxTimer)
				{
					thing.alpha = 0;
					new FlxTimer().start(0.1, function(tmr:FlxTimer)
						{
							System.exit(0);
						});
				});
		});
	}

	var tweenDifficulty:FlxTween;
	var lastImagePath:String;
	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficulties.length-1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 0;

		for (i in 0...grpDifficulties.length) {
			grpDifficulties.members[i].alpha = 0;
			grpDifficulties.members[i].offset.y = 0;
			FlxTween.cancelTweensOf(grpDifficulties.members[i]);
			if (i == curDifficulty) {
				//grpDifficulties.members[i].alpha = 1;
				//grpDifficulties.members[i].color = FlxColor.fromString("#787878");
				FlxTween.cancelTweensOf(grpChapterText.members[i]);
				if (change != 0) {
				grpDifficulties.members[i].offset.y = 15;
				FlxTween.tween(grpDifficulties.members[i].offset, {y: 0}, 0.3, {ease: FlxEase.quadOut});
				FlxTween.tween(grpDifficulties.members[i], {alpha: 1}, 0.3, {ease: FlxEase.quadOut});
				} else 
					grpDifficulties.members[i].alpha = 1;
			}
			
		}

		lastDifficultyName = CoolUtil.difficulties[curDifficulty];

		#if !switch
		intendedScore = Highscore.getWeekScore(WeekData.weeksList[curWeek], curDifficulty);
		#end
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	override function beatHit()
	{
		super.beatHit();

		for(i in grpPlayerCharacters)
			i.animation.play('idle', true);
		for(i in grpStoryCharacters)
			i.animation.play('idle', true);
	}

	function changeWeek(change:Int = 0):Void
	{
		var oldChange = curWeek;
		curWeek += change;

		if (showScore[curWeek])
			scoreText.visible = true;
		else
			scoreText.visible = false;

		if (trackName[curWeek] == '')
			tracksText.visible = false;
		else
			tracksText.visible = true;
		if (curWeek >= chapters.length)
			curWeek = chapters.length - 1;
		if (curWeek < 0)
			curWeek = 0;

		for (i in 0...grpChapters.length) {
			grpChapters.members[i].alpha = 0;
			
			if (i == curWeek) {
				grpChapters.members[i].alpha = 1;
				
			}
		}
		for (i in 0...grpStoryCharacters.length) {
			grpStoryCharacters.members[i].alpha = 0;
			if (i == curWeek) {
				grpStoryCharacters.members[i].alpha = 1;
			}
		}
		for (i in 0...grpTracksText.length) {
			grpTracksText.members[i].alpha = 0;
			if (i == curWeek) {
				grpTracksText.members[i].alpha = 1;
			}
		}
		for (i in 0...grpPlayerCharacters.length) {
			grpPlayerCharacters.members[i].alpha = 0;
			if (i == curWeek) {
				grpPlayerCharacters.members[i].alpha = 1;
			}
		}
		for (i in 0...grpChapterText.length) {
			grpChapterText.members[i].alpha = 0;
			grpChapterText.members[i].offset.y = 0;
			FlxTween.cancelTweensOf(grpChapterText.members[i]);
			if (i == curWeek) {
				if(weekIsLocked(curWeek))
					grpChapterText.members[i].alpha = 0.6;
				else
					grpChapterText.members[i].alpha = 1;
				if (change != 0) {
					grpChapterText.members[i].color = FlxColor.fromString("#787878");
					FlxTween.cancelTweensOf(grpChapterText.members[i]);
					grpChapterText.members[i].offset.y = 100;
					FlxTween.tween(grpChapterText.members[i].offset, {y: 0}, 0.3, {ease: FlxEase.quadOut});
				}
			}
		}
		if(weekIsLocked(curWeek))
		{
			FlxTween.cancelTweensOf(lock);
			lock.alpha = 1;
			if (change != 0) {
				FlxTween.cancelTweensOf(lock);
				lock.offset.y = 100;
				FlxTween.tween(lock.offset, {y: 0}, 0.3, {ease: FlxEase.quadOut});
			}
		}
		
		titleText.text = chapterTitles[curWeek];
		titleText.screenCenter(X);
		switch (curWeek) {
			case 0:
				selectArrow.alpha = 0;
			case 1:
				selectArrow.alpha = 1;
				selectArrow.setPosition(433, 534);
			case 2:
				selectArrow.alpha = 1;
				selectArrow.setPosition(610, 419);
			case 3:
				selectArrow.alpha = 1;
				selectArrow.setPosition(811, 391);
		}
		if(weekIsLocked(curWeek))
		{
			grpTracksText.members[curWeek].alpha = 0.8;
			lock.alpha = 1;
		} else
		{
			grpTracksText.members[curWeek].alpha = 1;
			lock.alpha = 0;
		}
		PlayState.storyWeek = curWeek;
		updateText();
	}

	function weekIsLocked(weekNum:Int) {
		var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[weekNum]);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!weekCompleted.exists(leWeek.weekBefore) || !weekCompleted.get(leWeek.weekBefore)));
	}

	function updateText()
	{
		#if !switch
		intendedScore = Highscore.getWeekScore(WeekData.weeksList[curWeek], curDifficulty);
		#end
		txtTracklist.text = 'TRACKS\n\n';
		switch (curWeek) {
			case 0:
				txtTracklist.text = '';
			case 1:
				txtTracklist.text += 'WEALTHY GUIDANCE';
			case 2:
				txtTracklist.text += 'SIGH LENCED\nALERTED\nMELTDOWN';
			case 3:
				txtTracklist.text += 'EN GUARDE\nMYTHICAL TRAGEDY\nH20VERDRIVE';
		}
		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		/*var weekArray:Array<String> = WeekData.weeksLoaded.get(WeekData.weeksList[curWeek]).weekCharacters;
		for (i in 0...grpWeekCharacters.length) {
			grpWeekCharacters.members[i].changeCharacter(weekArray[i]);
		}

		var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[curWeek]);
		var stringThing:Array<String> = [];
		for (i in 0...leWeek.songs.length) {
			stringThing.push(leWeek.songs[i][0]);
		}

		txtTracklist.text = '';
		for (i in 0...stringThing.length)
		{
			txtTracklist.text += stringThing[i] + '\n';
		}

		txtTracklist.text = txtTracklist.text.toUpperCase();

		

		*/
	}
}
