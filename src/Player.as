package
{
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.flixel.*;
	
	public class Player extends FlxGroup
	{	
				
		private const IDLE_FRAMES:Array = new Array(0,0);
		private const MOVING_FRAMES:Array = new Array(1,0);
		private const SHOVING_FRAMES:Array = new Array(2,3,4);
		private const UNSHOVING_FRAMES:Array = new Array(3,2,1);
		private const EXTENDED_FRAMES:Array = new Array(4,4);
		private const MOVING_EXTENDED_FRAMES:Array = new Array(4,5);
		private const DYING_FRAMES:Array = new Array(0,6);
		private const VICTORY_FRAME:uint = 7;
		
			
		public var id:uint;
		public var name:String;
		private var nameText:TextField;
		private var nameTextFormat:TextFormat = new TextFormat("COMMODORE",18,0x000000,null,null,null,null,null,"center");

		
		public var sprite:FlxSprite;
		public var light:FlxSprite;
		public var bodymap:FlxSprite;
		public var handmap:FlxSprite;
				
		private var hitTimer:FlxTimer = new FlxTimer();
		public var preFlickerTimer:FlxTimer = new FlxTimer();
		public var flickerTimer:FlxTimer = new FlxTimer();
		private var dieTimer:FlxTimer = new FlxTimer();
		private var switchTimer:FlxTimer = new FlxTimer();
		
		public var width:Number = Globals.PLAYER_WIDTH;
		public var height:Number = Globals.PLAYER_HEIGHT;
		
		public var bodyWidth:Number = Globals.PLAYER_WIDTH - 20;
		public var bodyHeight:Number = 20;
		
		private var pfacing:uint = FlxObject.RIGHT;
		private var switches:uint = 0;
		
		public var started:Boolean = false;
		
		
		public function Player(ID:uint, Name:String, X:Number, Y:Number)
		{
			super();
			
			id = ID;
			name = Name;
			nameText = Helpers.makeTextField(X - 10,Y - 9,Globals.PLAYER_WIDTH + 20,20,name,nameTextFormat);
			nameText.visible = false;
			
			FlxG.stage.addChild(nameText);
			
			sprite = newPlayerSprite(X, Y, Assets.PLAYER_SS_PNG, FlxObject.NONE);	
			sprite.replaceColor(0xFF433F46,Globals.PLAYER_COLOURS[Globals.PLAYER_COLOURS_INDEX]);
			Globals.PLAYER_COLOURS_INDEX++;
			
			bodymap = newPlayerSprite(X, Y, Assets.PLAYER_BM_PNG, FlxObject.ANY);					
			handmap = newPlayerSprite(X, Y, Assets.PLAYER_HM_PNG, FlxObject.ANY);					
						
			handmap.visible = false;
			bodymap.visible = false;
			
			light = new FlxSprite(X,Y);
			light.loadGraphic(Assets.PLAYER_LIGHT_PNG,true,true,Globals.PLAYER_WIDTH,Globals.PLAYER_HEIGHT,true);
			light.addAnimation("normal",[1,1],30,true);
			light.addAnimation("die",[3,4],30,true);
			light.addAnimation("flicker",[1,1,1,2,2,2],30,true);
			light.frame = 0;
			light.replaceColor(0xFF00DE23,Globals.LIGHT_COLOURS[Globals.LIGHT_COLOURS_INDEX]);
			Globals.LIGHT_COLOURS_INDEX++;

			add(sprite);
			add(bodymap);
			add(handmap);
			add(light);
			
			play("idle extended");				
		}
		
				
		private function newPlayerSprite(X:Number, Y:Number, SpriteSheet:Class, Collisions:uint):FlxSprite
		{
			var tempSprite:FlxSprite =  new FlxSprite(X,Y);
			tempSprite.loadGraphic(SpriteSheet,true,true,Globals.PLAYER_WIDTH,Globals.PLAYER_HEIGHT,true);
			tempSprite.addAnimation("idle",IDLE_FRAMES,30,true);
			tempSprite.addAnimation("moving normal",MOVING_FRAMES,15,true);
			tempSprite.addAnimation("moving hispeed",MOVING_FRAMES,30,true);
			tempSprite.addAnimation("extend",SHOVING_FRAMES,30,false);
			tempSprite.addAnimation("retract",UNSHOVING_FRAMES,30,false);			
			tempSprite.addAnimation("idle extended",EXTENDED_FRAMES,30,true);
			tempSprite.addAnimation("moving extended normal",MOVING_EXTENDED_FRAMES,7,true);
			tempSprite.addAnimation("moving extended hispeed",MOVING_EXTENDED_FRAMES,15,true);
			tempSprite.addAnimation("die",DYING_FRAMES,30,true);
			tempSprite.allowCollisions = Collisions;
						
			return tempSprite;
		}
		
		
		override public function update():void
		{
						
			//trace("MOVING=" + moving() + " / SHOVING=" + shoving() + " / EXTENDED=" + extended() + " / FRAME=" + sprite.frame);
						
			super.update();

			
			if (!started)
				return;
			
			if (!alive)
			{
				return;
			}
			else if (Globals.LIVING_PLAYERS == 1)
			{
				preFlickerTimer.stop();
				hitTimer.stop();
				flickerTimer.stop();
				switchTimer.stop();
				dieTimer.stop();
				
				sprite.frame = VICTORY_FRAME;
				light.play("normal");
				idle();
				active = false;
				return;
			}
			
			move();
			react();
			animate();
		}
		
		
		override public function postUpdate():void
		{
			pfacing = sprite.facing;
		}
		
		
		
		// MOVEMENT //
		
		protected function move():void
		{
			if (Globals.TEMPO == Globals.FAST_TEMPO)
			{
				flickerTimer.reset();
				light.play("normal");
			}
		}
		
		
		private function getSpeed():Number
		{
			if (extended())
				return Globals.PLAYER_EXTENDED_SPEED;
			else
				return Globals.PLAYER_RETRACTED_SPEED;
		}
		
		
		public function moveLeft():void
		{
			//trace(name + ": moveLeft()");
			setAll("facing", FlxObject.LEFT);
		
			vx = -getSpeed();			
		}
		
		
		public function moveRight():void
		{
			//trace(name + ": moveRight()");
			setAll("facing", FlxObject.RIGHT);
			
			vx = getSpeed();			
		}
		
		
		public function moveUp():void
		{
			//trace(name + ": moveUp()");
			
			vy = -getSpeed();
		}
		
		
		public function moveDown():void
		{
//			trace(name + ": moveDown()");

			vy = getSpeed();
		}
		
		
		public function idleX():void
		{
//			trace(name + ": idleX()");
			vx = 0;
		}
		
		
		public function idleY():void
		{
//			trace(name + ": idleY()");
			vy = 0;
		}
	
		
		public function idle():void
		{
			idleX();
			idleY();
		}
		
		
		protected function react():void
		{
			// Placeholder for extensions
		}
		
		
		
		///////////////
		// ANIMATION //
		///////////////
		
		protected function animate():void
		{
			if (moving())
			{
				if (extended())
				{
					if (Globals.PLAYER_EXTENDED_SPEED == Globals.PLAYER_EXTENDED_NORMALSPEED)
						play("moving extended normal");
					else
						play("moving extended hispeed");
				}
				else if (!shoving())
				{
					if (Globals.PLAYER_RETRACTED_SPEED == Globals.PLAYER_RETRACTED_NORMALSPEED)
						play("moving normal");
					else
						play("moving hispeed");
				}
			}
			else
			{
				if (extended())
				{
					play("idle extended");					
				}
				else if (!shoving())
				{
					play("idle");					
				}
			}
		}
		
		
		
		private function play(Animation:String):void
		{
			//trace(name + ": playing " + Animation);
			sprite.play(Animation);
			bodymap.play(Animation);
			handmap.play(Animation);
		}
		
		
		
		// SPEED //
		
		protected function handleSpeed():void
		{

		}
		
		
		public function extend():void
		{
			if (!extended() && !shoving())
			{
				preFlickerTimer.reset();
				play("extend");	
			}
		}
		
		
		private function flicker(t:FlxTimer):void
		{
			if (!flickering())
			{
				light.play("flicker");
				flickerTimer.start(Globals.FLICKER_MAX_TIME,1,flickerStop);
			}
			else
			{
				trace("DEATH BY CAUSING A FLICKER WHILE FLICKERING FOR " + name);
				die();
			}
		}
		
		
		private function flickerStop(t:FlxTimer):void
		{
			if (extended())
			{
				preFlickerTimer.reset();
				flickerTimer.reset();
				light.play("normal");
			}
			else
			{
				trace("DEATH BY FLICKERING FOR TOO LONG FOR " + name);
				die();
			}
		}
		
		
		private function flickerDeath():void
		{
			die();
		}
		
		
		// Notify the player they hit someone with a shove,
		// so stop the timer that would timeout
		
		public function hit():void
		{
			hitTimer.reset();	
		}
		
		
		public function retract():void
		{
			if (extended())
			{
				play("retract");				
				preFlickerTimer.start(Globals.PRE_FLICKER_TIME,1,flicker);
			}
		}
		
					
		public function bodyCollision():void
		{
			flicker(null);
		}
		
		
		public function die():void
		{
			if (!alive || !active)
				return;
			
			trace("DIE!");
			preFlickerTimer.stop();
			hitTimer.stop();
			flickerTimer.stop();
			
			
			this.alive = false;
			Globals.LIVING_PLAYERS--;
			idleX();
			idleY();
			play("die");
			light.play("die");
			dieTimer.start(1,1,endDie);
		}
		
		
		private function endDie(T:FlxTimer):void
		{
			sprite.frame = 0;
			this.active = false;
			this.visible = false;
		}
		
		
		
		/////////////
		// HELPERS //
		/////////////
		
		protected function moving():Boolean
		{
			return (vx != 0 || vy != 0);	
		}
		
		
		protected function flickering():Boolean
		{
			return (light.frame == 2 || light.frame == 3);
		}
		
		
		protected function shoving():Boolean
		{
			return (sprite.frame == 2 || sprite.frame == 3);
		}
		
		
		public function extended():Boolean
		{
			return (sprite.frame == 4 || sprite.frame == 5);
		}
		
				
		public function set vx(Velocity:Number):void
		{
			sprite.velocity.x = Velocity;
			light.velocity.x = Velocity;
			bodymap.velocity.x = Velocity;
			handmap.velocity.x = Velocity;
		}
		
		
		public function get vx():Number
		{
			return sprite.velocity.x;
		}
		
		
		public function set vy(Velocity:Number):void
		{
			sprite.velocity.y = Velocity;
			light.velocity.y = Velocity;
			bodymap.velocity.y = Velocity;
			handmap.velocity.y = Velocity;
		}
		
		
		public function get vy():Number
		{
			return sprite.velocity.y;
		}
		
		
		public function set x(X:Number):void
		{
			sprite.x = X;
			light.x = X;
			bodymap.x = X;
			handmap.x = X;
		}
		
		
		public function get x():Number
		{
			return sprite.x;
		}
		
		
		public function set y(Y:Number):void
		{
			sprite.y = Y;
			light.y = Y;
			bodymap.y = Y;
			handmap.y = Y;
		}
		
		
		public function get y():Number
		{
			return sprite.y;
		}
		
		
		public function get handX():Number
		{
			if (sprite.facing == FlxObject.LEFT)
			{
				return this.x;
			}
			else
			{
				return this.x + this.width;
			}
		}
		
		
		public function get handY():Number
		{
			if (extended())
			{
				return this.y + 20;
			}
			else
			{
				return this.y + 16;
			}
		}
		
		
		public function get bodyX():Number
		{
			if (sprite.facing == FlxObject.LEFT)
			{
				return this.x + 20;
			}
			else
			{
				return this.x;
			}
		}
		
		
		public function get bodyY():Number
		{
			return this.y + 16;
		}
		
		
		public function start():void
		{
			started = true;
		}
		
		
		public function showName():void
		{
			nameText.visible = true;
		}
		
		
		public function hideName():void
		{
			nameText.visible = false;
		}
		
		
		public function face(direction:uint):void
		{
			setAll("facing",direction);
		}
		
	
		override public function destroy():void
		{
			super.destroy();
						
			sprite.destroy();
			light.destroy();
			bodymap.destroy();
			handmap.destroy();
			
			hitTimer.destroy();
			flickerTimer.destroy();
			dieTimer.destroy();
			switchTimer.destroy();
			
			if (nameText != null && FlxG.stage.contains(nameText)) FlxG.stage.removeChild(this.nameText);
		}
	}
}