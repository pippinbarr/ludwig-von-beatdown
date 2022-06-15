package
{
	import org.flixel.*;
	
	import flash.ui.Keyboard;
	
	public class HumanPlayer extends Player
	{
		private const LEFT_KEY:uint = 0;
		private const RIGHT_KEY:uint = 1;
		private const UP_KEY:uint = 2;
		private const DOWN_KEY:uint = 3;
		private const SPEED_KEY:uint = 4;

		private var keys:Array;
		
		public function HumanPlayer(ID:uint, Name:String, X:Number, Y:Number, Keys:Array)
		{
			super(ID,Name,X,Y);
			
			keys = Keys;
		}
		
		
		override public function update():void
		{			
			super.update();	
		}
		
		
		override protected function move():void
		{			
			if (FlxG.keys.pressed(keys[LEFT_KEY]))
			{
				moveLeft();
			}
			else if (FlxG.keys.pressed(keys[RIGHT_KEY]))
			{
				moveRight();
			}
			else
			{
				idleX();
			}
			
			if (FlxG.keys.pressed(keys[UP_KEY]))
			{
				moveUp();
			}
			else if (FlxG.keys.pressed(keys[DOWN_KEY]))
			{
				moveDown();
			}
			else
			{
				idleY();
			}
			
			if (FlxG.keys.pressed(keys[SPEED_KEY]))
			{
				retract();
			}
			else
			{
				extend();
			}
		}		
	}
}