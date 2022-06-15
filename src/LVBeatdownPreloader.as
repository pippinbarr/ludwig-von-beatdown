package
{
	import flash.display.*;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.*;
	import flash.utils.getTimer;
	import flash.system.fscommand;
	
	import org.flixel.FlxG;
	import org.flixel.system.FlxPreloader;
	
	
	[SWF(width = "640", height = "480", backgroundColor = "#FFFFFF")]
	
	
	public class LVBeatdownPreloader extends FlxPreloader {
		
		[Embed(source="assets/ttf/Commodore Pixelized v1.2.ttf", fontName="COMMODORE", fontWeight="Regular", embedAsCFF="false")]
		private var COMMODORE_FONT:Class;
		
		private var _loadingText:TextField;
		private var _loadingTextFormat:TextFormat;
		
		private var _bg:Bitmap;
		private var _loadingBar:Bitmap;
		private var _loadingBarBGBlack:Bitmap;
		private var _loadingBarBGWhite:Bitmap;
		
		private var _moveBase1:Bitmap;
		private var _moveTop1:Bitmap;
		private var _moveTop1Active:Bitmap;

		private var _moveBase2:Bitmap;
		private var _moveTop2:Bitmap;
		private var _moveTop2Active:Bitmap;

		private var _moveBase3:Bitmap;
		private var _moveTop3:Bitmap;
		private var _moveTop3Active:Bitmap;

		private var _moveBase4:Bitmap;
		private var _moveTop4:Bitmap;
		private var _moveTop4Active:Bitmap;

		private var _playButton:TextField;
		private var _playButtonFormat:TextFormat;
		
		private var _timer:uint = 0;
		
		public function LVBeatdownPreloader() {			
			className = "LudwigVonBeatdown";
			super();
			
			
		}
		
		override protected function create():void {
			
			
			
			Font.registerFont(COMMODORE_FONT);
			
			// Set minimum running time of the preload
			_min = 8000000;
			
			// Create a buffer Sprite
			_buffer = new Sprite();
			addChild(_buffer);	
			
			// Textfield to display boarding messages
			_loadingTextFormat = new TextFormat("COMMODORE",50,0x000000,null,null,false,null,null,"center",null,null,null,null);
			_loadingText = new TextField();
			_loadingText.width = stage.stageWidth;
			_loadingText.x = stage.x;
			_loadingText.y = stage.stageHeight/2 - 100;
			_loadingText.embedFonts = true;
			_loadingText.selectable = false;
			_loadingText.defaultTextFormat = _loadingTextFormat;
			_loadingText.text = "LOADING";
			
			_playButton = new TextField();
			_playButtonFormat = new TextFormat("COMMODORE",30,0x000000,null,null,false,null,null,"center",null,null,null,null);
			_playButton.width = stage.stageWidth;
			_playButton.x = stage.x;
			_playButton.y = stage.stageHeight/2 - 50;
			_playButton.embedFonts = true;
			_playButton.selectable = false;
			_playButton.defaultTextFormat = _playButtonFormat;
			_playButton.text = "CLICK TO PLAY!";
						
			_moveBase1 = new Bitmap(new BitmapData(50,150,false,0x111111));
			_moveBase1.x = 150 - 50/2; _moveBase1.y = 480 - 150;
			_moveTop1 = new Bitmap(new BitmapData(50,50,false,0xDDDDDD));
			_moveTop1.x = 150 - 50/2; _moveTop1.y = 480 - 150 - 50; 
			_moveTop1Active = new Bitmap(new BitmapData(50,50,false,0x66a9ff));
			_moveTop1Active.x = 150 + (0 * 440/4) - 50/2; _moveTop1Active.y = 480 - 150 - 50; 
			_moveTop1Active.visible = false;

			_moveBase2 = new Bitmap(new BitmapData(50,150,false,0x111111));
			_moveBase2.x = 150 + (1 * 440/4) - 50/2; _moveBase2.y = 480 - 150;
			_moveTop2 = new Bitmap(new BitmapData(50,50,false,0xDDDDDD));
			_moveTop2.x = 150 + (1 * 440/4) - 50/2; _moveTop2.y = 480 - 150 - 50; 
			_moveTop2Active = new Bitmap(new BitmapData(50,50,false,0xf666ff));
			_moveTop2Active.x = 150 + (1 * 440/4) - 50/2; _moveTop2Active.y = 480 - 150 - 50; 
			_moveTop2Active.visible = false;

			_moveBase3 = new Bitmap(new BitmapData(50,150,false,0x111111));
			_moveBase3.x = 150 + (2 * 440/4) - 50/2; _moveBase3.y = 480 - 150;
			_moveTop3 = new Bitmap(new BitmapData(50,50,false,0xDDDDDD));
			_moveTop3.x = 150 + (2 * 440/4) - 50/2; _moveTop3.y = 480 - 150 - 50; 
			_moveTop3Active = new Bitmap(new BitmapData(50,50,false,0xFFff8666));
			_moveTop3Active.x = 150 + (2 * 440/4) - 50/2; _moveTop3Active.y = 480 - 150 - 50; 
			_moveTop3Active.visible = false;

			_moveBase4 = new Bitmap(new BitmapData(50,150,false,0x111111));
			_moveBase4.x = 150 + (3 * 440/4) - 50/2; _moveBase4.y = 480 - 150;
			_moveTop4 = new Bitmap(new BitmapData(50,50,false,0xDDDDDD));
			_moveTop4.x = 150 + (3 * 440/4) - 50/2; _moveTop4.y = 480 - 150 - 50; 
			_moveTop4Active = new Bitmap(new BitmapData(50,50,false,0x5fd34f));
			_moveTop4Active.x = 150 + (3 * 440/4) - 50/2; _moveTop4Active.y = 480 - 150 - 50; 
			_moveTop4Active.visible = false;

			//_bg = new ZORBA_BEACH();
			_bg = new Bitmap(new BitmapData(640,480,false,0xFFEEEE));
			_bg.x = 0;
			_bg.y = 0;
			
			_buffer.addChild(_bg);
			
			_buffer.addChild(_moveBase1);
			_buffer.addChild(_moveTop1);
			_buffer.addChild(_moveTop1Active);
			
			_buffer.addChild(_moveBase2);
			_buffer.addChild(_moveTop2);
			_buffer.addChild(_moveTop2Active);

			_buffer.addChild(_moveBase3);
			_buffer.addChild(_moveTop3);
			_buffer.addChild(_moveTop3Active);

			_buffer.addChild(_moveBase4);
			_buffer.addChild(_moveTop4);
			_buffer.addChild(_moveTop4Active);

			_buffer.addChild(_loadingText);	
			
			
		}
		
		override protected function update(Percent:Number):void {
			
			var ActualPercent:Number = root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal;
			//_loadingBar.scaleX = ActualPercent * 296;
			
			if (ActualPercent > 0.25)
				_moveTop1Active.visible = true;
			if (ActualPercent > 0.5)
				_moveTop2Active.visible = true;
			if (ActualPercent > 0.75)
				_moveTop3Active.visible = true;
			if (ActualPercent >= 0.99)
				_moveTop4Active.visible = true;

			if (root.loaderInfo.bytesLoaded < root.loaderInfo.bytesTotal && getTimer() < _min) {
				_timer++;
			}
			else {
				_loadingText.text = "LOADED";
				_buffer.addChild(_playButton);
				stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			}
			
		}
		
		private function mouseDown(e:MouseEvent):void {
			_min = 3000;
			stage.focus = null;
		}
		
	}
}