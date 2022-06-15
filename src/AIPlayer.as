package
{
	import flash.display.BitmapData;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxCollision;
	
	public class AIPlayer extends Player
	{
		// Perlin //
		
		private var perlinData:BitmapData;
		private var perlinXIndex:uint;
		private var perlinYIndex:uint;;
		
		// Movement mode //
		
		private const RANDOM:uint = 0;
		private const PERLIN:uint = 1;
		private const CHASE:uint = 2;
		private const STATIC:uint = 3;
		private var movementMode:uint = RANDOM;
		
		private var movementModeTimer:FlxTimer = new FlxTimer();
		
		// Speed mode //
		
		private const FAST:uint = 0;
		private const SLOW:uint = 1;
		private var speedMode:uint = FAST;
		
		private var speedModeTimer:FlxTimer = new FlxTimer();
		
		// Reaction mode //
		
		private const PURSUE:uint = 0;
		private const NONE:uint = 1;
		private const FLEE:uint = 2;
		private const FEEL_OUT:uint = 3;
		private var reactionMode:uint = FEEL_OUT;
		private var reactionRange:Number = 50;
		
		private var reactionModeTimer:FlxTimer = new FlxTimer();
		
		// Danger mode //
		
		private const ATTACK:uint = 0;
		private const DODGE:uint = 1;
		private var dangerMode:uint = DODGE;
		private var dangerRange:Number = 30;
		
		private var dangerModeTimer:FlxTimer = new FlxTimer();
		
		// Personality //
		
		private var stability:Number;
		private var risk:Number;
		
		
		// Debug //
		
		
		public function AIPlayer(ID:uint, Name:String, Stability:Number, X:Number, Y:Number)
		{
			super(ID,Name,X,Y);		
			
			perlinData = new BitmapData(3000,1);
			perlinData.perlinNoise(100,1,3,int(Math.random() * 10000),false,false,7,false);
			
			perlinXIndex = Math.floor(Math.random() * perlinData.width);
			perlinYIndex = Math.floor(Math.random() * perlinData.width);
			
			stability = Stability;
			risk = Math.random() - 0.6;
			if (risk < 0) risk = 0;
			
			setPersonality();
						
//			FlxG.state.add(idText);
		}
		
		
		override public function update():void
		{			
			super.update();
			
			if (!alive)
				return;
			
			if (Globals.LIVING_PLAYERS == 1)
				return;
			
		}
		
		
		/////////////////
		// PERSONALITY //
		/////////////////
		
		
		private function setPersonality():void
		{
			//			trace(name + " had a personality switch!");
			setMovementMode(null);
			setSpeedMode(null);
			setReactionMode(null);
			setDangerMode(null);
		}
		
		
		private function setMovementMode(t:FlxTimer):void
		{
			var random:Number = Math.random();
			if (random < 0.33)
				movementMode = CHASE;
			else if (random < 0.66)
				movementMode = PERLIN;
			else
				movementMode = RANDOM;
			
			movementModeTimer.start(1,1,setMovementMode);
		}
		
		
		private function setSpeedMode(t:FlxTimer):void
		{
			var random:Number = Math.random();
			if (random < 0.6)
				speedMode = FAST;
			else
				speedMode = SLOW;
			
			speedModeTimer.start(1,1,setSpeedMode);
		}
		
		
		private function setReactionMode(t:FlxTimer):void
		{
			reactionMode = Math.floor(Math.random() * 3);
			reactionRange = Globals.MIN_REACTION_RANGE + Math.random() * Globals.MAX_REACTION_RANGE;
			
			reactionModeTimer.start(1,1,setReactionMode);
		}
		
		
		private function setDangerMode(t:FlxTimer):void
		{
			dangerMode = Math.floor(Math.random() * 2);			
			dangerRange = Globals.MIN_DANGER_RANGE + Math.random() * Globals.MAX_DANGER_RANGE;
			
			dangerModeTimer.start(1,1,setDangerMode);
		}
		
		
		//////////////
		// MOVEMENT //
		//////////////
		
		override protected function move():void
		{
			if (movementMode == RANDOM)
				randomMovement();
			else if (movementMode == PERLIN)
				perlinMovement();
			else if (movementMode == CHASE)
				chaseMovement();
			else if (movementMode == STATIC)
				staticMovement();
			
			if (speedMode == FAST)
				fastMovement();
			else if (speedMode == SLOW)
				slowMovement();
		}
		
		
		private function staticMovement():void
		{
			idle();
		}
		
		
		private function randomMovement():void
		{
//			trace(name + ": RANDOM MOVEMENT");
			
			var random:Number = Math.random();
			
			if (moving() && Math.random() < 0.9)
			{
				
			}
			else if (random < 0.33)
			{
				moveLeft();
			}
			else if (random < 0.66)
			{
				moveRight();
			}
			else
			{
				idleX();
			}
			
			random = Math.random();
			
			if (moving() && Math.random() < 0.9)
			{
				
			}
			else if (random < 0.33)
			{
				moveUp();
			}
			else if (random < 0.66)
			{
				moveDown();
			}
			else
			{
				idleY();
			}
		}
		
		
		private function perlinMovement():void
		{
//			trace(name + ": PERLIN MOVEMENT");
			
			var effect:Number = getPerlinEffect(perlinXIndex);
			perlinXIndex = (perlinXIndex + 1) % perlinData.width;
			
			if (effect < 0.33)
			{
				moveLeft();
			}
			else if (effect < 0.66)
			{
				moveRight();
			}
			else
			{
				idleX();
			}
			
			effect = getPerlinEffect(perlinYIndex);
			perlinYIndex = (perlinYIndex + 1) % perlinData.width;
			
			if (effect < 0.33)
			{
				moveUp();
			}
			else if (effect < 0.66)
			{
				moveDown();
			}
			else
			{
				idleY();
			}
		}
		
		
		private function getPerlinEffect(Index:uint):Number
		{
			var pixel:uint = perlinData.getPixel(Index,0);
			
			var red:uint = pixel >> 16 & 0xFF;
			var green:uint = pixel >> 8 & 0xFF;
			var blue:uint = pixel & 0xFF;
			
			var effect:Number = (red - 127) / 128;
			
			return -effect;
		}
		
		
		private function chaseMovement():void
		{
//			trace(name + ": CHASE MOVEMENT");
			
			var target:Player = getNearestLivingPlayer();
			
			if (target == null)
			{
				randomMovement();
				return;
			}
			
			var distanceToTargetX:Number = (this.x - target.x);
			var distanceToTargetY:Number = (this.y - target.y);
			
			//			trace("DISTANCE IS: " + distanceToTargetX + "," + distanceToTargetY);
			
			if (distanceToTargetX > 2 * this.width)
			{
				moveLeft();
			}
			else if (distanceToTargetX < -2 * this.width)
			{
				moveRight();
			}
			
			if (distanceToTargetY > 5)
			{
				moveUp();
			}
			else if (distanceToTargetY < 5)
			{
				moveDown();
			}
			else
			{
				idleY();
			}
		}
		
		
		private function fastMovement():void
		{
//			trace(name + "'s flickerTimer.timeLeft == " + flickerTimer.timeLeft);
			if (flickerTimer.timeLeft > 0.5 - (risk * Math.random()) || flickerTimer.timeLeft == 0)
			{
				retract();
			}
			else
			{
				extend();
			}
		}
		
		
		private function slowMovement():void
		{
			if (!extended())
			{
				extend();
			}
		}
		
		
		// REACTING //
		
		override protected function react():void
		{			
			var nearestPlayer:Player = getNearestLivingPlayer();
			
			if (inRange(nearestPlayer,this,dangerRange,dangerRange))
			{
				dangerReaction(nearestPlayer);
			}
			else if (inRange(nearestPlayer,this,reactionRange,reactionRange))
			{
				rangeReaction(nearestPlayer);
			}
		}
		
		
		private function dangerReaction(P:Player):void
		{
			switch (dangerMode)
			{
				case ATTACK:
					attack(P);
					break;
				case DODGE:
					attack(P);
					break;
			}
		}
		
		
		private function attack(P:Player):void
		{
			if (!flickering())
				retract();
			
			if (extended())
			{
				if (P.x > this.x)
				{
					moveRight();
				}
				else
				{
					moveLeft();
				}
				if (P.y > this.y)
				{
					moveDown();
				}
				else
				{
					moveUp();
				}
			}
			else
			{
				if (!P.extended())
					extend();
				else if (extended() && !flickering())
					retract();
				
				if (P.x > this.x + this.width)
				{
					moveRight();
				}
				else if (P.x < this.x)
				{
					moveLeft();
				}
				
				if (extended())
				{
					if (P.y > this.y)
					{
						moveDown();
					}
					else
					{
						moveUp();
					}
				}
				else
				{
					if (P.y > this.y + 6)
					{
						moveDown();
					}
					else if (P.y < this.y - 6)
					{
						moveUp();
					}
					else
					{
						idleY();
					}
				}
			}
		}
		
		
		private function dodge(P:Player):void
		{
			if (!flickering())
				retract();
			
			idleX();
			if (this.y + this.height > Globals.PLAY_AREA_TOP + 3*Globals.PLAY_AREA_HEIGHT/4)
				moveUp();
			else if (this.y < Globals.PLAY_AREA_TOP + Globals.PLAY_AREA_HEIGHT/4)
				moveDown();
			else if (this.vy < 0)
				moveUp();
			else
				moveDown();
		}
		
		
		private function rangeReaction(P:Player):void
		{
			handleXReaction(P);
			handleYReaction(P);
			
			switch (reactionMode)
			{
				case FLEE:
					fastMovement();
					break;
				case FEEL_OUT:
					slowMovement();
					break;
				case PURSUE:
					fastMovement();
					break;
			}
		}
		
		
		private function handleXReaction(P:Player):void
		{
			if (P.handX < this.x)
			{
				switch (reactionMode)
				{
					case PURSUE:
//						trace(name + ": PURSUIT adjusted to moveLeft()");
						moveLeft();
						break;
					case FEEL_OUT:
//						trace(name + ": PURSUIT adjusted to moveLeft()");
						moveLeft();
						break;
					case FLEE:
//						trace(name + ": AVOID adjusted to moveLeft()");
						moveRight();
						break;
				}
			}
			else if (P.handX > this.x + this.width)
			{
				switch (reactionMode)
				{
					case PURSUE:
//						trace(name + ": PURSUIT adjusted to moveRight()");
						moveRight();
						break;
					case FEEL_OUT:
//						trace(name + ": PURSUIT adjusted to moveLeft()");
						moveRight();
						break;
					case FLEE:
//						trace(name + ": AVOID adjusted to moveLeft()");
						moveLeft();
						break;
				}
			}
			else
			{
				switch (reactionMode)
				{
					case PURSUE:
						idleX();
						break;
					case FEEL_OUT:
//						trace(name + ": PURSUIT adjusted to moveLeft()");
						idleX();
						break;
				}
			}
			
			// Turn to face opponent if trapped on a wall //
			
			if (P.x < this.x && this.x >= FlxG.width - this.width - 10)
			{
				this.setAll("facing", FlxObject.LEFT);
			}
			else if (P.x > this.x && this.x <= 0 + this.width + 10)
			{
				this.setAll("facing", FlxObject.RIGHT);
			}
		}
		
		
		private function handleYReaction(P:Player):void
		{
			if (P.y + P.height/2 < this.y )
			{
				switch (reactionMode)
				{
					case PURSUE:
						moveUp();
						break;
					case FEEL_OUT:
//						trace(name + ": PURSUIT adjusted to moveLeft()");
						moveUp();
						break;
					case FLEE:
						moveDown();
						break;
				}
			}
			else if (P.y > this.y + this.height/2)
			{
				switch (reactionMode)
				{
					case PURSUE:
						moveDown();
						break;
					case FEEL_OUT:
//						trace(name + ": PURSUIT adjusted to moveLeft()");
						moveDown();
						break;
					case FLEE:
						moveUp();
						break;
				}
			}
		}
		
		
		override public function bodyCollision():void
		{
			super.bodyCollision();
			
			setPersonality();
		}
		
		
		
		// HELPERS //
		
		protected function getNearestLivingPlayer():Player
		{
			var nearestPlayer:Player = null;
			var nearestPlayerDistance:Number = 100000;
			
			// Search all players
			for (var i:uint = 0; i < Globals.PLAYERS.length; i++)
			{
				// Ignore yourself and dead players
				if (Globals.PLAYERS[i].id == this.id || !Globals.PLAYERS[i].alive)
					continue;
				
				if (distanceToPlayer(Globals.PLAYERS[i]) < nearestPlayerDistance)
				{
					nearestPlayer = Globals.PLAYERS[i];
					nearestPlayerDistance = distanceToPlayer(Globals.PLAYERS[i]);
				}
			}
			
			return nearestPlayer;
		}
		
		
		private function facing(P:Player):Boolean
		{
			if (P.x < this.x && sprite.facing == FlxObject.LEFT)
			{
				return true;
			}
			else if (P.x >= this.x && sprite.facing == FlxObject.RIGHT)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		
		private function distanceToPlayer(P:Player):Number
		{
			if (P == null)
			{
				return 0;
			}
			else
			{
				return Math.sqrt(Math.pow(this.x - P.x,2) + Math.pow(this.y - P.y,2));
			}
		}
		
		
		private function inRange(P1:Player, P2:Player, XR:Number, YR:Number):Boolean
		{			
			if (P1 != null && P2 != null)
			{
				return inXRange(P1,P2,XR) && inYRange(P1,P2,YR);
			}
			else
			{
				return false;
			}
		}
		
		
		private function inXRange(P1:Player,P2:Player,R:Number):Boolean
		{
			if (P1.x < P2.x)
			{
				if (Math.abs(P1.handX - P2.bodyX) < R)
				{
					return true;
				}
			}
			else
			{
				if (Math.abs(P1.handX - (P2.bodyX + P2.bodyWidth)) < R)
				{
					return true;
				}
			}
			
			return false;
		}
		
		
		private function inYRange(P1:Player,P2:Player,R:Number):Boolean
		{
			if (P1.handY + R >= P2.bodyY && P1.handY - R <= P2.bodyY + P2.bodyHeight)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		
		override public function destroy():void
		{
			super.destroy();
			
			speedModeTimer.destroy();
			reactionModeTimer.destroy();
			dangerModeTimer.destroy();
		}
		
	}
}