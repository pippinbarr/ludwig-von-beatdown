package
{
	import flash.events.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;
	
	import org.flixel.*;
	
	public class MenuState extends FlxState
	{	
		private var title:TextField;
		private var titleFormat:TextFormat = new TextFormat("COMMODORE",56,0x000000,null,null,null,null,null,"left");

		private var option0:TextField;
		private var option1:TextField;
		private var option2:TextField;
		private var optionsFormat:TextFormat = new TextFormat("COMMODORE",22,0x000000,null,null,null,null,null,"center");
		
		private var option0Remote:FlxSprite;
		private var option1Remote:FlxSprite;
		private var option2Remote:FlxSprite;

		private var keys:TextField;
		private var keysFormat:TextFormat = new TextFormat("COMMODORE",18,0x000000,null,null,null,null,null,"center");

		private var switchTimer:FlxTimer = new FlxTimer();

		private var selectionMade:Boolean = false;
		
		
		public function MenuState()
		{
			super();
		}
		
		
		public override function create():void
		{
			super.create();
			
			FlxG.bgColor = 0xFFEEFFEE;
			
			title = Helpers.makeTextField(105,0,FlxG.width,100,"LUDWIG\nVON\nBEATDOWN",titleFormat);
//			option0 = Helpers.makeTextField(80,100,320 - 110,100,"PRESS [0] TO PLAY\nA ZERO-PLAYER GAME",optionsFormat);
//			option1 = Helpers.makeTextField(80,150,320 - 110,100,"PRESS [1] TO PLAY\nA ONE-PLAYER GAME",optionsFormat);
//			option2 = Helpers.makeTextField(80,200,320-110,100,"PRESS [2] TO PLAY\nA TWO-PLAYER GAME",optionsFormat);
			option0 = Helpers.makeTextField(80,100,320 - 110,100,"PRESS BOTH [A] BUTTONS\nFOR ZERO-PLAYER GAME",optionsFormat);
			option1 = Helpers.makeTextField(80,150,320 - 110,100,"PRESS [ONE PLAYER]\nFOR ONE-PLAYER GAME",optionsFormat);
			option2 = Helpers.makeTextField(80,200,320-110,100,"PRESS [TWO PLAYER]\nFOR TWO-PLAYER GAME",optionsFormat);

			//0xff66a9ff,0xFFf666ff,0xFFf666ff,0xFF5fd34f

			option0Remote = new FlxSprite(0,100);
			option0Remote.loadGraphic(Assets.MENU_REMOTE_PNG,true,false,100,25,true);
			option0Remote.replaceColor(0xFF00DE23,0xff66a9ff);
			option1Remote = new FlxSprite(0,150);
			option1Remote.loadGraphic(Assets.MENU_REMOTE_PNG,true,false,100,25,true);
			option1Remote.replaceColor(0xFF00DE23,0xFFf666ff);
			option2Remote = new FlxSprite(0,200);
			option2Remote.loadGraphic(Assets.MENU_REMOTE_PNG,true,false,100,25,true);
			option2Remote.replaceColor(0xFF00DE23,0xFF5fd34f);

			add(option0Remote);
			add(option1Remote);
			add(option2Remote);
			
			FlxG.stage.addChild(title);
			FlxG.stage.addChild(option0);
			FlxG.stage.addChild(option1);
			FlxG.stage.addChild(option2);

			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		}
		
		
		public override function update():void
		{
			super.update();
			
			if (selectionMade)
				return;
			
			if (FlxG.keys.Z && FlxG.keys.N)
			{
				Globals.NUM_PLAYERS = 0;
				option0Remote.frame = 1;
				FlxG.play(Assets.ACTIVATION_MP3,0.5);
				switchTimer.start(2,1,startGame);	
				selectionMade = true;
			}
			else if (FlxG.keys.ONE)
			{
				Globals.NUM_PLAYERS = 1;
				option1Remote.frame = 1;
				FlxG.play(Assets.ACTIVATION_MP3,0.5);
				switchTimer.start(2,1,startGame);
				selectionMade = true;

			}
			else if (FlxG.keys.TWO)
			{
				Globals.NUM_PLAYERS = 2;
				option2Remote.frame = 1;
				FlxG.play(Assets.ACTIVATION_MP3,0.5);
				switchTimer.start(2,1,startGame);	
				selectionMade = true;

			}
		}
		
		
		private function onKeyDown(e:KeyboardEvent):void
		{
//			if (e.keyCode != Keyboard.NUMBER_0 &&
//				e.keyCode != Keyboard.NUMBER_1 &&
//				e.keyCode != Keyboard.NUMBER_2)
//				return;
//			if (e.keyCode != Keyboard.Z &&
//				e.keyCode != Keyboard.N &&
//				e.keyCode != Keyboard.NUMBER_1 &&
//				e.keyCode != Keyboard.NUMBER_2)
//				return;
//
//			
////			if (e.keyCode == Keyboard.NUMBER_0)
//			if (FlxG.keys.Z &&
//				FlxG.keys.N)
//			{
//				trace("Here.");
//				Globals.NUM_PLAYERS = 0;
//				option0Remote.frame = 1;
//			}
//			else if (e.keyCode == Keyboard.NUMBER_1)
//			{
//				Globals.NUM_PLAYERS = 1;
//				option1Remote.frame = 1;
//			}
//			else if (e.keyCode == Keyboard.NUMBER_2)
//			{
//				Globals.NUM_PLAYERS = 2;
//				option2Remote.frame = 1;
//			}
//			
//			FlxG.play(Assets.ACTIVATION_MP3,0.5);
//			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
//			switchTimer.start(2,1,startGame);			
		}
		
		
		private function startGame(t:FlxTimer):void
		{
			FlxG.switchState(new PrototypeState);
		}

		
		public override function destroy():void
		{
			super.destroy();
			

			FlxG.stage.removeChild(title);
			FlxG.stage.removeChild(option0);
			FlxG.stage.removeChild(option1);
			FlxG.stage.removeChild(option2);
			
			option0Remote.destroy();
			option1Remote.destroy();
			option2Remote.destroy();
			
			switchTimer.destroy();

//			title.destroy();
//			options.destroy();
//			keys.destroy();
		}
	}
}