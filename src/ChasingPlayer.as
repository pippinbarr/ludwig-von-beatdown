package
{
	import flash.display.BitmapData;
	
	import org.flixel.*;
	
	public class ChasingPlayer extends AIPlayer
	{
		private var target:Player;
		
		public function ChasingPlayer(ID:uint,Name:String, X:Number, Y:Number)
		{
			super(ID,Name,X,Y);	
			
			var targetID:uint = Math.floor(Math.random() * Globals.PLAYERS.length);
			while (targetID == id)
			{
				targetID = Math.floor(Math.random() * Globals.PLAYERS.length);
			}
			
			target = Globals.PLAYERS[targetID];
		}
		
		
		override public function update():void
		{									
			super.update();
			
			chooseTarget();
		}
		
		
		private function chooseTarget():void
		{
			target = getNearestLivingPlayer();	
		}
		
		
		override protected function handleMovement():Boolean
		{
			if (!super.handleMovement())
			{
				return false;
			}
			
			if (target == null)
				return false;
			
			var distanceToTargetX:Number = ((this.x + this.width) - (target.x + target.width));
			var distanceToTargetY:Number = ((this.y + this.height) - (target.y + target.height));
			
			if (distanceToTargetX > 5)
			{
				moveLeft();
			}
			else if (distanceToTargetX < -5)
			{
				moveRight();
			}
			else
			{
				idleX();
			}
			
			if (distanceToTargetY > 5)
			{
				moveUp();
			}
			else if (distanceToTargetY < -5)
			{
				moveDown();
			}
			else
			{
				idleY();
			}
			
			return true;
		}
		
		
		override protected function handleShoving():Boolean
		{
			super.handleShoving();
			
			smartShove();
			
			return true;
		}
		
	}
}