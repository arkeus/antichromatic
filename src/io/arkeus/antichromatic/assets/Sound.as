package io.arkeus.antichromatic.assets {
	import io.arkeus.antichromatic.util.Config;
	
	import org.axgl.Ax;

	public class Sound {
		private static var sounds:Object = {};
		private static var initialized:Boolean = false;
		
		public static function initialize():void {
			if (initialized) {
				return;
			}
			
			create("jump", "0,,0.1907,,0.1199,0.28,,0.2107,,,,,,0.0972,,,,,1,,,,,0.5");
			create("double-jump", "0,,0.1907,,0.1199,0.39,,0.2107,,,,,,0.0972,,,,,1,,,,,0.5");
			create("shoot", "1,,0.0853,,0.2995,0.7216,,-0.6425,,,,,,,,,,,1,,,0.1824,,0.3");
			create("shoot-wall", "1,,0.0853,,0.23,0.4,,-0.02,,,,,,,,,,,1,,,0.1824,,0.2");
			create("crate", "3,,0.1359,0.6454,0.34,0.16,,-0.3295,,,,,,,,,,,1,,,,,0.5");
			create("player-die", "3,,0.35,0.405,0.51,0.23,,-0.4399,0.34,,,,,,,,0.2411,-0.0778,1,,,,,0.5");
			create("hit-enemy", "0,0.06,0.27,0.52,0.08,0.2,,-0.28,,,,,,0.28,,,,,1,,,0.24,,0.5");
			create("enemy-die", "3,,0.29,0.3742,0.26,0.09,,-0.18,,,,-0.1586,0.6996,,,0.6378,,,1,,,,,0.5");
			create("ding-high", "0,,0.0579,0.4992,0.2297,0.56,,,,,,,,,,,,,1,,,,,0.2");
			create("ding-low", "0,,0.0579,0.4992,0.2297,0.44,,,,,,,,,,,,,1,,,,,0.2");
			create("collect", "1,,0.393,,0.413,0.35,,0.1999,0.52,,,,,,,0.451,,,1,,,,,0.5");
			create("start", "1,,0.31,,0.85,0.22,,0.2199,0.1999,0.2895,0.1215,,,,,,,,1,,,,,0.5");
			create("black", "0,,0.0102,0.5856,0.3765,0.5022,,0.04,-0.2199,,,0.5395,0.6412,,,,,,1,,,,,0.5");
			create("white", "0,,0.0102,0.5856,0.3765,0.5022,,0.04,0.1799,,,0.5395,0.6412,,,,,,1,,,,,0.5");
			create("teleport", "0,,0.42,,0.37,0.2,,0.257,,,,,,0.4966,,0.603,,,1,,,,,0.5");
			create("hover", "3,,0.06,,0.12,0.39,,0.04,,,,,,,,,,,1,,,0.1912,,0.3");
			create("select", "2,,0.0317,0.5561,0.3762,0.09,,-0.36,0.58,,,,,,,,,,1,,,,,0.5");
			
			initialized = true;
		}
		
		public static function create(soundName:String, sfxrParameters:String):void {
			if (!Config.SOUND_ENABLED) {
				return;
			}
			var sound:SfxrSynth = new SfxrSynth;
			sound.params.setSettingsString(sfxrParameters);
			sound.cacheSound();
			sounds[soundName] = sound;
		}
		
		public static function play(soundName:String):void {
			if (sounds[soundName] == null || Ax.soundMuted) {
				return;
			}
			(sounds[soundName] as SfxrSynth).play();
		}
	}
}
