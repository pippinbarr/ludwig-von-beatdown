package
{
	import org.flixel.*;
	import flash.display.*;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.*;
	import flash.utils.getTimer;
	import flash.system.fscommand;


	[SWF(width = "640", height = "480", backgroundColor = "#000000")]
	//[Frame(factoryClass="LVBeatdownPreloader")]

	public class LudwigVonBeatdown extends FlxGame
	{
		public function LudwigVonBeatdown()
		{
			super(640 / Globals.ZOOM,480 / Globals.ZOOM,MenuState,Globals.ZOOM,30,30);
			
			this.useSoundHotKeys = false;
			FlxG.volume = 1.0;
			
			/////////////////////////////////
			
			FlxG.stage.showDefaultContextMenu = false;
			FlxG.stage.displayState = StageDisplayState.FULL_SCREEN;
			FlxG.stage.scaleMode = StageScaleMode.SHOW_ALL;
			
			FlxG.stage.align = StageAlign.TOP;
			
			//fscommand("trapallkeys","true");
			
			////////////////////////////////

		}
	}
}