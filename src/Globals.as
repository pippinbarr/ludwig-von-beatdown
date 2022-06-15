package
{
	import org.flixel.*;
	
	public class Globals
	{
		public static var NUM_PLAYERS:uint = 0;
		
		public static const ZOOM:uint = 2;
		
		public static const LOCATIONS:Array = new Array(Assets.CATHEDRAL_BG_PNG,Assets.DEATH_VALLEY_BG_PNG,Assets.ITU_BG_PNG);
		
		public static var PLAYER_COLOURS:Array = new Array(0xFF222222,0xFF333333,0xFF444444,0xFF555555,0xFF666666,0xFF777777,0xFF888888,0xFF999999);
		public static var PLAYER_COLOURS_INDEX:uint = 0;
		
		public static var LIGHT_COLOURS:Array = new Array(0xff66a9ff,0xFFf666ff,0xFFff8666,0xFF5fd34f);//,0xFF46e9a2,0xFF46c8e9,0xFF4684e9,0xFF8f46e9);
		public static var LIGHT_COLOURS_INDEX:uint = 0;
		
		public static const SLOW_TEMPO:uint = 0;
		public static const FAST_TEMPO:uint = 1;
		public static var TEMPO:uint = SLOW_TEMPO;
		
		public static const TEMPO_TIME_MIN:Number = 3;
		public static const TEMPO_TIME_RANGE:Number = 7;
		
		public static const PLAYER_WIDTH:uint = 44;
		public static const PLAYER_HEIGHT:uint = 60;

		public static const PLAYER_EXTENDED_NORMALSPEED:Number = 10;
		public static const PLAYER_RETRACTED_NORMALSPEED:Number = PLAYER_EXTENDED_NORMALSPEED * 4;
		public static const PLAYER_EXTENDED_HISPEED:Number = 20;
		public static const PLAYER_RETRACTED_HISPEED:Number = PLAYER_EXTENDED_HISPEED * 4;

		public static var PLAYER_EXTENDED_SPEED:Number = PLAYER_EXTENDED_NORMALSPEED;
		public static var PLAYER_RETRACTED_SPEED:Number = PLAYER_RETRACTED_NORMALSPEED;
		
		public static var SHOVE_DISTANCE:Number = 8;
		
		public static var PRE_FLICKER_TIME:Number = 1;
		public static var FLICKER_MAX_TIME:Number = 1;
		
		public static const MIN_PERSONALITY_TIME:Number = 2;
		public static const MAX_PERSONALITY_TIME:Number = 20;
		
		public static const MIN_REACTION_RANGE:Number = 50;
		public static const MAX_REACTION_RANGE:Number = 100;
		public static const MIN_DANGER_RANGE:Number = 10;
		public static const MAX_DANGER_RANGE:Number = 40;

		public static const PLAY_AREA_TOP:Number = 128;
		public static const PLAY_AREA_HEIGHT:Number = 240 - PLAY_AREA_TOP;
		
		public static var LIVING_PLAYERS:int = 0;
		
		public static var PLAYERS:Array = new Array();
		
		public function Globals()
		{
		}
	}
}