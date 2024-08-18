package states;

import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import states.editors.MasterEditorMenu;
import options.OptionsState;

class MainMenuState extends MusicBeatState
{
public static var psychEngineVersion:String = '0.7.3'; // This is also used for Discord RPC
public static var curSelected:Int = 0;

var menuItems:FlxTypedGroup<FlxSprite>;

var optionShit:Array<String> = [
'story_mode', //0
'freeplay', //1
#if MODS_ALLOWED 'mods', #end //2
#if ACHIEVEMENTS_ALLOWED 'awards', #end //3
'credits', //4
//#if !switch 'donate', #end
'options' //5
];

var magenta:FlxSprite;
var camFollow:FlxObject;

override function create()
{
#if MODS_ALLOWED
Mods.pushGlobalMods();
#end
Mods.loadTopMod();

#if DISCORD_ALLOWED
// Updating Discord Rich Presence
DiscordClient.changePresence("In the Menus", null);
#end

persistentUpdate = persistentDraw = true;

var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
bg.antialiasing = ClientPrefs.data.antialiasing;
bg.scrollFactor.set(0, yScroll);
bg.setGraphicSize(Std.int(bg.width * 1.175));
bg.updateHitbox();
bg.screenCenter();
add(bg);

camFollow = new FlxObject(0, 0, 1, 1);
add(camFollow);

magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
magenta.antialiasing = ClientPrefs.data.antialiasing;
magenta.scrollFactor.set(0, yScroll);
magenta.setGraphicSize(Std.int(magenta.width * 1.175));
magenta.updateHitbox();
magenta.screenCenter();
magenta.visible = false;
magenta.color = 0xFFfd719b;
add(magenta);

menuItems = new FlxTypedGroup<FlxSprite>();
add(menuItems);

for (i in 0...optionShit.length)
{
var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
var menuItem:FlxSprite = new FlxSprite(0, (i * 140) + offset);
menuItem.antialiasing = ClientPrefs.data.antialiasing;
menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_$name');
        menuItem.animation.addByPrefix('idle', '$name idle', 24, true);
        menuItem.animation.addByPrefix('selected', '$name selected', 24, true);
menuItem.animation.play('idle');
menuItems.add(menuItem);
var scr:Float = (optionShit.length - 4) * 0.135;
if (optionShit.length < 6)
scr = 0;
menuItem.scrollFactor.set(0, scr);
menuItem.updateHitbox();
menuItem.screenCenter(X);

	
switch(i)
{
   case 0:
       FlxTween.tween(menuItem, {x:16}, 2.2, {ease: FlxEase.expoInOut});


   case 1:
       FlxTween.tween(menuItem, {x:16}, 2.2, {ease: FlxEase.expoInOut});


   case 2:
	FlxTween.tween(menuItem, {x:16}, 2.2, {ease: FlxEase.expoInOut});

    }
}


var psychVer:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
psychVer.scrollFactor.set();
psychVer.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
add(psychVer);
var fnfVer:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
fnfVer.scrollFactor.set();
fnfVer.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
add(fnfVer);
changeItem();

#if ACHIEVEMENTS_ALLOWED
// Unlocks "Freaky on a Friday Night" achievement if it's a Friday and between 18:00 PM and 23:59 PM
var leDate = Date.now();
if (leDate.getDay() == 5 && leDate.getHours() >= 18)
