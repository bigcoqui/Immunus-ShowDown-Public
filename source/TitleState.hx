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
import haxe.Json;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import options.GraphicsSettingsSubState;
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

using StringTools;
typedef TitleData =
{
	
	titlex:Float,
	titley:Float,
	startx:Float,
	starty:Float,
	gfx:Float,
	gfy:Float,
	backgroundSprite:String,
	bpm:Int
}
class TitleState extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	public static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;
	var iconthingy:Credicon = new Credicon();

	var curWacky:Array<String> = [];
	var curWacky2:Array<String> = [];

	var wackyImage:FlxSprite;
	var collabSpr:FlxSprite;
	var nahfr:FlxSprite;
	var womp:FlxSprite;
	var immortal:FlxSprite;
	var stupidFuckingLogo:FlxSprite;

	var easterEggEnabled:Bool = false; //Disable this to hide the easter egg
	var easterEggKeyCombination:Array<FlxKey> = [FlxKey.B, FlxKey.B]; //bb stands for bbpanzu cuz he wanted this lmao
	var lastKeysPressed:Array<FlxKey> = [];

	var mustUpdate:Bool = false;
	
	var titleJSON:TitleData;
	
	public static var updateVersion:String = '';
	override public function create():Void
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		#if MODS_ALLOWED
		// Just to load a mod on start up if ya got one. For mods that change the menu music and bg
		if (FileSystem.exists("modsList.txt")){
			
			var list:Array<String> = CoolUtil.listFromString(File.getContent("modsList.txt"));
			var foundTheTop = false;
			for (i in list){
				var dat = i.split("|");
				if (dat[1] == "1" && !foundTheTop){
					foundTheTop = true;
					Paths.currentModDirectory = dat[0];
				}
				
			}
		}
		#end
		
		#if (desktop && MODS_ALLOWED)
		var path = "mods/" + Paths.currentModDirectory + "/images/gfDanceTitle.json";
		//trace(path, FileSystem.exists(path));
		if (!FileSystem.exists(path)) {
			path = "mods/images/gfDanceTitle.json";
		}
		//trace(path, FileSystem.exists(path));
		if (!FileSystem.exists(path)) {
			path = "assets/images/gfDanceTitle.json";
		}
		//trace(path, FileSystem.exists(path));
		titleJSON = Json.parse(File.getContent(path));
		#else
		var path = Paths.getPreloadPath("images/gfDanceTitle.json");
		titleJSON = Json.parse(Assets.getText(path)); 
		#end
		
		#if (polymod && !html5)
		if (sys.FileSystem.exists('mods/')) {
			var folders:Array<String> = [];
			for (file in sys.FileSystem.readDirectory('mods/')) {
				var path = haxe.io.Path.join(['mods/', file]);
				if (sys.FileSystem.isDirectory(path)) {
					folders.push(file);
				}
			}
			if(folders.length > 0) {
				polymod.Polymod.init({modRoot: "mods", dirs: folders});
			}
		}
		#end
		
		#if CHECK_FOR_UPDATES
		if(!closedState) {
			trace('checking for update');
			var http = new haxe.Http("https://raw.githubusercontent.com/ShadowMario/FNF-PsychEngine/main/gitVersion.txt");
			
			http.onData = function (data:String)
			{
				updateVersion = data.split('\n')[0].trim();
				var curVersion:String = MainMenuState.psychEngineVersion.trim();
				trace('version online: ' + updateVersion + ', your version: ' + curVersion);
				if(updateVersion != curVersion) {
					trace('versions arent matching!');
					mustUpdate = true;
				}
			}
			
			http.onError = function (error) {
				trace('error: $error');
			}
			
			http.request();
		}
		#end

		FlxG.game.focusLostFramerate = 60;
		FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;
		FlxG.keys.preventDefaultKeys = [TAB];

		//PlayerSettings.init();

		curWacky = FlxG.random.getObject(getIntroTextShit());
		curWacky2 = FlxG.random.getObject(getIntroTextShit());

		// DEBUG BULLSHIT

		swagShader = new ColorSwap();
		super.create();

		//FlxG.save.bind('funkin', 'ninjamuffin99');

		if(!initialized && FlxG.save.data != null && FlxG.save.data.fullscreen)
		{
			FlxG.fullscreen = FlxG.save.data.fullscreen;
			//trace('LOADED FULLSCREEN SETTING!!');
		}
		
		//ClientPrefs.loadPrefs();
		
		//Highscore.load();

		if (FlxG.save.data.weekCompleted != null)
		{
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		}

		FlxG.mouse.visible = false;
		#if FREEPLAY
		MusicBeatState.switchState(new FreeplayState());
		#elseif CHARTING
		MusicBeatState.switchState(new ChartingState());
		#else
		if(!ClientPrefs.seenvid && !FlashingState.leftState) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new FlashingState());
		} else {
			#if desktop
			DiscordClient.initialize();
			Application.current.onExit.add (function (exitCode) {
				DiscordClient.shutdown();
			});
			#end
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				startIntro();
			});
		}
		#end
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;
	var bgBoyyssssss:FlxSprite;
	var bgBoyyssssss2:FlxSprite;
	var swagShader:ColorSwap = null;
	var bruh:FlxSprite;
	public function bruhevent(cum)
	{
		bruh = new FlxSprite();
		if (cum == 1)
		{
			bruh.loadGraphic(Paths.image('Credits Icons/JustJack'));
			new FlxTimer().start(1.25, function(tmr:FlxTimer)
			{
				addMoreText('"I Believe you man"');
			});
		}
		else if (cum == 2)
		{
			bruh.loadGraphic(Paths.image('Credits Icons/DusterBuster'));
			new FlxTimer().start(1.25, function(tmr:FlxTimer)
			{
				addMoreText('"Hot Monika"');
			});
		}
		else if (cum == 3)
		{
			bruh.loadGraphic(Paths.image('Credits Icons/PooterStapot'));
			new FlxTimer().start(1.25, function(tmr:FlxTimer)
			{
				addMoreText('"squak"');
			});
		}
		else if (cum == 4)
		{
			bruh.loadGraphic(Paths.image('Credits Icons/Wooked'));
			new FlxTimer().start(1.25, function(tmr:FlxTimer)
			{
				addMoreText('"Mario Bro"');
			});
		}
		else if (cum == 5)
		{
			bruh.loadGraphic(Paths.image('Credits Icons/Cammy'));
			new FlxTimer().start(1.25, function(tmr:FlxTimer)
			{
				addMoreText('"Cupid Gaming"');
			});
		}
		else if (cum == 6)
		{
			bruh.loadGraphic(Paths.image('Credits Icons/Ito'));
			new FlxTimer().start(1.25, function(tmr:FlxTimer)
			{
				addMoreText('“I want to date Sal“');
			});
		}
		else if (cum == 7)
		{
			bruh.loadGraphic(Paths.image('Credits Icons/ButterInAToast'));
			new FlxTimer().start(1.25, function(tmr:FlxTimer)
			{
				addMoreText('"I like melted cheese"');
			});
		}
		else if (cum == 8)
		{
			bruh.loadGraphic(Paths.image('Credits Icons/Teeth'));
			new FlxTimer().start(1.25, function(tmr:FlxTimer)
			{
				addMoreText('"samey deserves a hug"“"');
			});
		}
		else if (cum == 9)
		{
			bruh.loadGraphic(Paths.image('Credits Icons/Hexar'));
			new FlxTimer().start(1.25, function(tmr:FlxTimer)
			{
				addMoreText('"i hate white people"');
			});
		}
		else if (cum == 10)
		{
			bruh.loadGraphic(Paths.image('Credits Icons/Offbi'));
			new FlxTimer().start(1.25, function(tmr:FlxTimer)
			{
				addMoreText('"This is a certified samey moment"');
			});
		}
		else if (cum == 11)
		{
			bruh.loadGraphic(Paths.image('Credits Icons/XenoToast'));
			new FlxTimer().start(1.25, function(tmr:FlxTimer)
			{
				addMoreText('"toast on deez nuts"');
			});
		}
		else if (cum == 12)
		{
			bruh.loadGraphic(Paths.image('Credits Icons/Mathesu'));
			new FlxTimer().start(1.25, function(tmr:FlxTimer)
			{
				addMoreText('"Doin ur mom"');
			});
		}
		else if (cum == 13)
		{
			bruh.loadGraphic(Paths.image('Credits Icons/Addicted2Electronics'));
			new FlxTimer().start(1.25, function(tmr:FlxTimer)
			{
				addMoreText('"whos bright idea was');
				addMoreText('it to not include');
				addMoreText('glameow in platinum"');
			});
			bruh.y += 100;
		}
		else if (cum == 13)
		{
			bruh.loadGraphic(Paths.image('Credits Icons/NemoInABottle'));
			new FlxTimer().start(1.25, function(tmr:FlxTimer)
			{
				addMoreText('"i love lean!"');
			});
		}
		else if (cum == 14)
		{
			bruh.loadGraphic(Paths.image('Credits Icons/royal'));
			new FlxTimer().start(1.25, function(tmr:FlxTimer)
			{
				addMoreText('"my mother is racist"');
			});
		}
		else if (cum == 15)
		{
			bruh.loadGraphic(Paths.image('Credits Icons/BigBand'));
			new FlxTimer().start(1.25, function(tmr:FlxTimer)
			{
				addMoreText('"The fitness gram pacer test"');
			});
		}
		else if (cum == 16)
		{
			bruh.loadGraphic(Paths.image('Credits Icons/aMaze'));
			new FlxTimer().start(1.25, function(tmr:FlxTimer)
			{
				addMoreText('"A shit I forgot to remember"');
			});
		}
		else if (cum == 17)
		{
			bruh.loadGraphic(Paths.image('Credits Icons/FuegO'));
			new FlxTimer().start(1.25, function(tmr:FlxTimer)
			{
				addMoreText('"AMONGLER!!"');
			});
		}
		else if (cum == 18)
		{
			bruh.loadGraphic(Paths.image('Credits Icons/Smorsi'));
			new FlxTimer().start(1.25, function(tmr:FlxTimer)
			{
				addMoreText('"Uau"');
			});
		}
		else if (cum == 19)
		{
			bruh.loadGraphic(Paths.image('Credits Icons/Gibz'));
			new FlxTimer().start(1.25, function(tmr:FlxTimer)
			{
				addMoreText('"Slow Charter"');
			});
		}
		else if (cum == 20)
		{
			bruh.loadGraphic(Paths.image('Credits Icons/Pointy'));
			new FlxTimer().start(1.25, function(tmr:FlxTimer)
			{
				addMoreText('"bandage boy gang"');
			});
		}
		else if (cum == 21)
		{
			bruh.loadGraphic(Paths.image('Credits Icons/MaxOke'));
			new FlxTimer().start(1.25, function(tmr:FlxTimer)
			{
				addMoreText('"Givin me mad Persona 5 vibes."');
			});
		}
		else if (cum == 22)
		{
			bruh.loadGraphic(Paths.image('Credits Icons/Trezzy'));
			new FlxTimer().start(1.25, function(tmr:FlxTimer)
			{
				addMoreText('"Monkey!"');
			});
		}
		else if (cum == 23)
		{
			bruh.loadGraphic(Paths.image('Credits Icons/OhSoVanilla'));
			new FlxTimer().start(1.25, function(tmr:FlxTimer)
			{
				addMoreText('"Sarvente is my wife"');
			});
		}
		else if (cum == 23)
		{
			bruh.loadGraphic(Paths.image('Credits Icons/OhSoVanilla'));
			new FlxTimer().start(1.25, function(tmr:FlxTimer)
			{
				addMoreText('"Sarvente is my wife"');
			});
		}
		else if (cum == 24)
		{
			bruh.loadGraphic(Paths.image('Credits Icons/BrightFyre'));
			new FlxTimer().start(1.25, function(tmr:FlxTimer)
			{
				nahfr.visible = true;
			});
		} 
		else if (cum == 25)
		{
			bruh.loadGraphic(Paths.image('Credits Icons/Ash'));
			new FlxTimer().start(1.25, function(tmr:FlxTimer)
			{
				womp.visible = true;
			});
		} 
		else if (cum == 26)
		{
			bruh.loadGraphic(Paths.image('Credits Icons/Ellis'));
			new FlxTimer().start(1.25, function(tmr:FlxTimer)
			{
				addMoreText('"Shit urself"');
			});
		}
		else if (cum == 27)
		{
			bruh.loadGraphic(Paths.image('Credits Icons/Kayya'));
			new FlxTimer().start(1.25, function(tmr:FlxTimer)
			{
				addMoreText('"why is this interger called cum"');
			});
		}
		else if (cum == 28)
		{
			bruh.loadGraphic(Paths.image('Credits Icons/Shadowfi'));
			new FlxTimer().start(1.25, function(tmr:FlxTimer)
			{
				addMoreText('"Fucking kity"');
			});
		}
		else if (cum == 29)
		{
			bruh.loadGraphic(Paths.image('Credits Icons/Philiplol'));
			new FlxTimer().start(1.25, function(tmr:FlxTimer)
			{
				addMoreText('"CHANGE THE FUCKING SONG 3 NOTES SJSJSJSJSJAJAK"');
			});
		}
		bruh.scale.set(1.25, 1.25);
		bruh.screenCenter();
		add(bruh);
		new FlxTimer().start(2.5, function(tmr:FlxTimer)
		{
			deleteCoolText(); //should've done this first actually lol, thx royal
			nahfr.visible = false;
			womp.visible = false;
			bruh.destroy();
		});
		
	}

	function startIntro()
	{
		if (!initialized)
		{
			/*var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-300, -300, FlxG.width * 1.8, FlxG.height * 1.8));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-300, -300, FlxG.width * 1.8, FlxG.height * 1.8));
				
			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;*/

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			// var music:FlxSound = new FlxSound();
			// music.loadStream(Paths.music('freakyMenu'));
			// FlxG.sound.list.add(music);
			// music.play();

			if(FlxG.sound.music == null) {
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);

				FlxG.sound.music.fadeIn(4, 0, 0.7);
			}
		}

		Conductor.changeBPM(103);
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite();
		
		if (titleJSON.backgroundSprite != null && titleJSON.backgroundSprite.length > 0 && titleJSON.backgroundSprite != "none"){
			bg.loadGraphic(Paths.image(titleJSON.backgroundSprite));
		}else{
			bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		}
		
		// bg.antialiasing = ClientPrefs.globalAntialiasing;
		// bg.setGraphicSize(Std.int(bg.width * 0.6));
		// bg.updateHitbox();
		
		
		
		
		add(bg);

		bgBoyyssssss = new FlxSprite(-150, 30);
		bgBoyyssssss.frames = Paths.getSparrowAtlas('Menu Renders/Start_Screen_Immunus_Showdown_Group1');
		bgBoyyssssss.antialiasing = true;
		bgBoyyssssss.animation.addByPrefix('bump', "Group_Of_Immunus1 instance 1", 24);
		bgBoyyssssss.setGraphicSize(FlxG.width);
		bgBoyyssssss.scale.set(0.9, 0.9);
		bgBoyyssssss.updateHitbox();
		//bgBoyyssssss.screenCenter();
		add(bgBoyyssssss);

		bgBoyyssssss2 = new FlxSprite(830, 10);
		bgBoyyssssss2.frames = Paths.getSparrowAtlas('Menu Renders/Start_Screen_Immunus_Showdown_Group2');
		bgBoyyssssss2.antialiasing = true;
		bgBoyyssssss2.animation.addByPrefix('bump', "Group_Of_Immunus2 instance 1", 24);
		bgBoyyssssss2.setGraphicSize(FlxG.width);
		bgBoyyssssss2.scale.set(0.9, 0.9);
		bgBoyyssssss2.updateHitbox();
		//bgBoyyssssss.screenCenter();
		add(bgBoyyssssss2);

		logoBl = new FlxSprite(titleJSON.titlex, titleJSON.titley);
		
		
		#if (desktop && MODS_ALLOWED)
		var path = "mods/" + Paths.currentModDirectory + "/images/Immunus_Showdown_LogoBumpin.png";
		//trace(path, FileSystem.exists(path));
		if (!FileSystem.exists(path)){
			path = "mods/images/Immunus_Showdown_LogoBumpin.png";
		}
		//trace(path, FileSystem.exists(path));
		if (!FileSystem.exists(path)){
			path = "assets/images/Immunus_Showdown_LogoBumpin.png";
		}
		//trace(path, FileSystem.exists(path));
		logoBl.frames = FlxAtlasFrames.fromSparrow(BitmapData.fromFile(path),File.getContent(StringTools.replace(path,".png",".xml")));
		#else
		
		logoBl.frames = Paths.getSparrowAtlas('Immunus_Showdown_LogoBumpin');
		#end
		
		logoBl.antialiasing = ClientPrefs.globalAntialiasing;
		logoBl.animation.addByPrefix('bump', 'Logo_ImmunusShowdown instance 1', 24, false);
		//logoBl.setGraphicSize(Std.int(logoBl.width * 0.4));
		logoBl.updateHitbox();
		logoBl.screenCenter();
		// logoBl.color = FlxColor.BLACK;

		swagShader = new ColorSwap();
			gfDance = new FlxSprite(titleJSON.gfx, titleJSON.gfy);
		
		#if (desktop && MODS_ALLOWED)
		var path = "mods/" + Paths.currentModDirectory + "/images/gfDanceTitle.png";
		//trace(path, FileSystem.exists(path));
		if (!FileSystem.exists(path)){
			path = "mods/images/gfDanceTitle.png";
		//trace(path, FileSystem.exists(path));
		}
		if (!FileSystem.exists(path)){
			path = "assets/images/gfDanceTitle.png";
		//trace(path, FileSystem.exists(path));
		}
		gfDance.frames = FlxAtlasFrames.fromSparrow(BitmapData.fromFile(path),File.getContent(StringTools.replace(path,".png",".xml")));
		#else
		
		gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
		#end
			gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
			gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
	
		gfDance.antialiasing = ClientPrefs.globalAntialiasing;
		//add(gfDance);
		gfDance.shader = swagShader.shader;
		add(logoBl);
		//logoBl.shader = swagShader.shader;

		titleText = new FlxSprite(titleJSON.startx, titleJSON.starty);
		#if (desktop && MODS_ALLOWED)
		var path = "mods/" + Paths.currentModDirectory + "/images/titleEnter.png";
		//trace(path, FileSystem.exists(path));
		if (!FileSystem.exists(path)){
			path = "mods/images/titleEnter.png";
		}
		//trace(path, FileSystem.exists(path));
		if (!FileSystem.exists(path)){
			path = "assets/images/titleEnter.png";
		}
		//trace(path, FileSystem.exists(path));
		titleText.frames = FlxAtlasFrames.fromSparrow(BitmapData.fromFile(path),File.getContent(StringTools.replace(path,".png",".xml")));
		#else
		
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		#end
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = ClientPrefs.globalAntialiasing;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		// titleText.screenCenter(X);
		add(titleText);

		stupidFuckingLogo = new FlxSprite();
		stupidFuckingLogo.frames = Paths.getSparrowAtlas('Menu Renders/Immunus_Showdown_OG_Logo_Touch', 'preload');
		stupidFuckingLogo.animation.addByPrefix('play', 'Logo_Touch', 24, false);
		stupidFuckingLogo.antialiasing = true;
		stupidFuckingLogo.updateHitbox();
		stupidFuckingLogo.screenCenter();

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.screenCenter();
		logo.antialiasing = ClientPrefs.globalAntialiasing;
		// add(logo);

		// FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		// FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.45).loadGraphic(Paths.image('Lillbirb2'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = ClientPrefs.globalAntialiasing;

		collabSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('collab'));
		add(collabSpr);
		collabSpr.visible = false;
		collabSpr.setGraphicSize(Std.int(collabSpr.width * 0.8));
		collabSpr.updateHitbox();
		collabSpr.screenCenter(X);
		collabSpr.antialiasing = true;

		womp = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('Credits Icons/womp'));
		add(womp);
		womp.visible = false;
		womp.scale.set(0.2, 0.2);
		womp.updateHitbox();
		womp.screenCenter(X);
		womp.y += 80;
		womp.antialiasing = true;

		nahfr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('Credits Icons/nahfrr'));
		add(nahfr);
		nahfr.visible = false;
		nahfr.scale.set(0.2, 0.2);
		nahfr.updateHitbox();
		nahfr.screenCenter(X);
		nahfr.y += 80;
		nahfr.antialiasing = true;

		immortal = new FlxSprite(0, 450).loadGraphic(Paths.image('immortallogo'));
		add(immortal);
		immortal.visible = false;
		immortal.setGraphicSize(Std.int(immortal.width * 0.5));
		immortal.updateHitbox();
		immortal.screenCenter(X);
		immortal.antialiasing = true;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		if (initialized)
			skipIntro();
		else
			initialized = true;

		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
			
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || controls.ACCEPT;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		
		if (skippedIntro)
		{
			stupidFuckingLogo.alpha = 0;
			//handyhand.alpha = 0;
		}

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		// EASTER EGG

		if (!transitioning && skippedIntro)
		{
			if(pressedEnter)
			{
				if(titleText != null) titleText.animation.play('press');

				FlxG.camera.flash(FlxColor.WHITE, 1);
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

				transitioning = true;
				// FlxG.sound.music.stop();

				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					if (mustUpdate) {
						MusicBeatState.switchState(new OutdatedState());
					} else {
						MusicBeatState.switchState(new MainMenuState());
					}
					closedState = true;
				});
				// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
			}
			else if(easterEggEnabled)
			{
				var finalKey:FlxKey = FlxG.keys.firstJustPressed();
				if(finalKey != FlxKey.NONE) {
					lastKeysPressed.push(finalKey); //Convert int to FlxKey
					if(lastKeysPressed.length > easterEggKeyCombination.length)
					{
						lastKeysPressed.shift();
					}
					
					if(lastKeysPressed.length == easterEggKeyCombination.length)
					{
						var isDifferent:Bool = false;
						for (i in 0...lastKeysPressed.length) {
							if(lastKeysPressed[i] != easterEggKeyCombination[i]) {
								isDifferent = true;
								break;
							}
						}

						/*if(!isDifferent) {
							trace('Easter egg triggered!');
							FlxG.save.data.psykaEasterEgg = !FlxG.save.data.psykaEasterEgg;
							FlxG.sound.play(Paths.sound('secretSound'));

							var black:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
							black.alpha = 0;
							add(black);

							FlxTween.tween(black, {alpha: 1}, 1, {onComplete:
								function(twn:FlxTween) {
									FlxTransitionableState.skipNextTransIn = true;
									FlxTransitionableState.skipNextTransOut = true;
									MusicBeatState.switchState(new TitleState());
								}
							});
							lastKeysPressed = [];
							closedState = true;
							transitioning = true;
						}*/
					}
				}
			}
		}

		if (pressedEnter && !skippedIntro)
		{
			skipIntro();
		}

		if(swagShader != null)
		{
			if(controls.UI_LEFT) swagShader.hue -= elapsed * 0.1;
			if(controls.UI_RIGHT) swagShader.hue += elapsed * 0.1;
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>, ?offset:Float = 0)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200 + offset;
			if(credGroup != null && textGroup != null) {
				credGroup.add(money);
				textGroup.add(money);
			}
		}
	}

	function addMoreText(text:String, ?offset:Float = 0)
	{
		if(textGroup != null && credGroup != null) {
			var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
			coolText.screenCenter(X);
			coolText.y += (textGroup.length * 60) + 200 + offset;
			credGroup.add(coolText);
			textGroup.add(coolText);
		}
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	private var sickBeats:Int = 0; //Basically curBeat but won't be skipped if you hold the tab or resize the screen
	public static var closedState:Bool = false;
	override function beatHit()
	{
		super.beatHit();
		
		if(bgBoyyssssss != null)
			bgBoyyssssss.animation.play('bump');

		if(bgBoyyssssss2 != null)
			bgBoyyssssss2.animation.play('bump');
		//logoBl.animation.play('bump');

		if (!stopdointhatshit)
		{
			FlxTween.tween(FlxG.camera, {zoom:1.05}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
		}
	
		if(logoBl != null) 
			logoBl.animation.play('bump', true);
		
		if(gfDance != null) {
			danceLeft = !danceLeft;

			if (danceLeft)
				gfDance.animation.play('danceRight');
			else
				gfDance.animation.play('danceLeft');
		}

		if(!closedState) {
			sickBeats++;
			switch (sickBeats)
			{
				case 2:
					createCoolText(['pooterstapot']);
					ngSpr.visible = true;
				case 4:
					addMoreText('presents');
				case 6:
					ngSpr.visible = false;
					deleteCoolText();
					createCoolText(['An Fnf project']);
				case 7:
					addMoreText('based on a');
				case 8:
					addMoreText('Passion project');
				case 9:
					deleteCoolText();
				case 10:
					createCoolText(['In collaberation with']);
				case 11:
					addMoreText('A bunch of cool ass people');
				case 12:
					deleteCoolText();
				case 13:
					if(!skippedIntro)
					{
						bruhevent(FlxG.random.int(1, 29));
					}
				case 18:
					createCoolText(['In A world where the']);
				case 20: 
					addMoreText('elusive and destructive');
					addMoreText('Specimen');
				case 21:
					deleteCoolText();
					createCoolText(['Known as the']);
				case 22:
					addMoreText('"Immunus" Race');
				case 24:
					deleteCoolText();
					createCoolText(['Roam Freely']);
				case 26:
					stopdointhatshit = true;
					deleteCoolText();
					add(stupidFuckingLogo);
					stupidFuckingLogo.visible = false;
					stupidFuckingLogo.alpha = 0;

					
					handyhand = new FlxSprite();
					handyhand.frames = Paths.getSparrowAtlas('Menu Renders/Immunus_Showdown_Raymond_Hand', 'preload');
					handyhand.animation.addByPrefix('play', 'Raymond Hand', 24, false);
					handyhand.antialiasing = true;
					handyhand.updateHitbox();
					handyhand.screenCenter();
					handyhand.y += 200;
					new FlxTimer().start(0.4, function(tmr:FlxTimer)
					{
						if(!skippedIntro)
						{
							handyhand.animation.play('play', true);
							add(handyhand);
						} else remove(handyhand); //stupid bug fix
					});
				case 27:
					stupidFuckingLogo.animation.play('play', true);
					stupidFuckingLogo.visible = true;
					FlxTween.tween(stupidFuckingLogo, {alpha: 1}, 0.2);
				case 31:
					skipIntro();
			}
		}
	}

	var handyhand:FlxSprite;

	var skippedIntro:Bool = false;
	var stopdointhatshit:Bool = false;
	var showText:Bool = false;
	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);
			remove(collabSpr);
			remove(nahfr);
			remove(womp);
			remove(stupidFuckingLogo);
			remove(handyhand);
			remove(bruh);

			immortal.visible = false;
			stopdointhatshit = true;
			remove(immortal);

			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);
			skippedIntro = true;
				particleLoop();
			remove(ngSpr);
		}
	}

	function TweenParticles(go:FlxSprite, newx:Float,  amp:Float, newy:Float, newalpha:Float, tweenTime:Float, delayTime:Float, newEase:Float->Float):Void{
		var randomScale = 0.4 + Math.random();
		go.scale.set(randomScale, randomScale);
		FlxTween.tween(go, {y: newy, alpha: newalpha}, tweenTime, {
			ease: newEase,
			type: FlxTweenType.LOOPING,
			loopDelay:delayTime,
			onUpdate: function(twn:FlxTween){
					go.x = newx + Math.sin(8*twn.scale+ randomScale)*amp;
			}

		});

	}

	function particleLoop()
	{
		for (i in 0...30){
			var part:FlxSprite = new FlxSprite(-1200+150*i, 1000).loadGraphic(Paths.image('particle', 'preload'));
			part.antialiasing = true;
			part.scrollFactor.set(0.92, 0.92);
			part.active = false;
			part.color = FlxG.random.color(FlxColor.PURPLE, FlxColor.PINK);
			part.alpha = FlxG.random.float(0.1, 0.6);
			TweenParticles(part, part.x, 120, part.y-2000, 0, (Math.random()*5+3),0, FlxEase.quadInOut);

			add(part);
		}
		new FlxTimer().start(0.8, function(tmr:FlxTimer)
		{
			particleLoop();
		});
	}
}