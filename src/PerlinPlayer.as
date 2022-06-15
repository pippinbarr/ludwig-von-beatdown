package
{
	import flash.display.BitmapData;
	
	import org.flixel.*;

	public class PerlinPlayer extends AIPlayer
	{
		
		private var perlinData:BitmapData;
		private var perlinXIndex:uint;
		private var perlinYIndex:uint;;
		
		public function PerlinPlayer(ID:uint,Name:String, X:Number, Y:Number)
		{
			super(ID,Name,X,Y);
			
			perlinData = new BitmapData(3000,1);
			perlinData.perlinNoise(100,1,3,int(Math.random() * 100),false,false,7,false);
			
			perlinXIndex = 0;
			perlinYIndex = perlinData.width / 2;
		}
		
		
		override public function update():void
		{
			super.update();
		}
		
		
		override protected function handleMovement():Boolean
		{
			if (!super.handleMovement())
			{
				return false;
			}
			
			var effect:Number = getPerlinEffect(perlinXIndex);
			perlinXIndex = (perlinXIndex + 1) % perlinData.width;
			trace(effect);
			
			if (effect > -0.33)
			{
				moveLeft();
			}
			else if (effect > -0.66)
			{
				moveRight();
			}
			else
			{
				idleX();
			}
			
			effect = getPerlinEffect(perlinYIndex);
			perlinYIndex = (perlinYIndex + 1) % perlinData.width;
			
			if (effect > -0.33)
			{
				moveUp();
			}
			else if (effect > -0.66)
			{
				moveDown();
			}
			else
			{
				idleY();
			}
			
			return true;
		}
		
		
		private function getPerlinEffect(Index:uint):Number
		{
			var pixel:uint = perlinData.getPixel(Index,0);
			
			var red:uint = pixel >> 16 & 0xFF;
			var green:uint = pixel >> 8 & 0xFF;
			var blue:uint = pixel & 0xFF;
			
			var effect:Number = (red - 127) / 128;

			return effect;
		}
		
		
		override protected function handleShoving():Boolean
		{
			if (!super.handleShoving())
			{
				return false;
			}
			
			smartShove();
			
			return true;
		}

	}
}