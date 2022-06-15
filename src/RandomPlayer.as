package
{
	import flash.display.BitmapData;
	
	import org.flixel.*;
	
	public class RandomPlayer extends AIPlayer
	{
		
		public function RandomPlayer(ID:uint, Name:String, X:Number, Y:Number)
		{
			super(ID,Name,X,Y);			
		}
		
		
		override public function update():void
		{			
			super.update();			
		}
		
		
		override protected function handleMovement():Boolean
		{
			if (!super.handleMovement())
				return false;
			
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
			
			return true;
		}
		
		
		override protected function handleShoving():Boolean
		{
			if (!super.handleShoving())
				return false;
			
			smartShove();
			
			return true;
		}
		
		
		
		
	}
}