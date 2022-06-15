package
{
	public class Assets
	{
		// FONTS //
		
		[Embed(source="assets/ttf/Commodore Pixelized v1.2.ttf", fontName="Commodore", fontWeight="Regular", embedAsCFF="false")]
		public static const COMMODORE_FONT:Class;
		
		// MUSIC //
		
		[Embed(source="assets/mp3/fur_elise_8bit_fast.mp3")]
		public static const FAST_FUR_ELISE_MP3:Class;
		
		[Embed(source="assets/mp3/fur_elise_8bit_slow.mp3")]
		public static const SLOW_FUR_ELISE_MP3:Class;

		// SFX //
		
		[Embed(source="assets/mp3/activation.mp3")]
		public static const ACTIVATION_MP3:Class;
		
		[Embed(source="assets/mp3/hit.mp3")]
		public static const HIT_MP3:Class;
		
		// MENU //
		
		[Embed(source="assets/png/menu_remote.png")]
		public static const MENU_REMOTE_PNG:Class;
		
		// BGS //
		
		[Embed(source="assets/png/death_valley_bg.png")]
		public static const DEATH_VALLEY_BG_PNG:Class;

		[Embed(source="assets/png/itu_bg.png")]
		public static const ITU_BG_PNG:Class;

		[Embed(source="assets/png/cathedral_bg.png")]
		public static const CATHEDRAL_BG_PNG:Class;

		
		// PLAYER IMAGES AND MAPS //
		
		[Embed(source="assets/png/prototype_player_ss.png")]
		public static const PLAYER_SS_PNG:Class;
		
		[Embed(source="assets/png/prototype_player_light.png")]
		public static const PLAYER_LIGHT_PNG:Class;
		
		[Embed(source="assets/png/prototype_player_bodymap.png")]
		public static const PLAYER_BM_PNG:Class;
		
		[Embed(source="assets/png/prototype_player_handmap.png")]
		public static const PLAYER_HM_PNG:Class;

		
		public function Assets()
		{
		}
	}
}