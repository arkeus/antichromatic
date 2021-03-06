package io.arkeus.antichromatic.util {
	import org.axgl.Ax;
	import org.axgl.AxButton;

	public class Options {
		public static const GREEN:String = "9eff00";
		public static const RED:String = "ff0000";
		public static const YELLOW:String = "ffcc00";
		
		public static function toggleMusic(button:AxButton):void {
			if (Ax.musicMuted) {
				Ax.musicMuted = false;
				if (Registry.music != null) {
					Registry.music.volume = 0.7;
				}
			} else {
				Ax.musicMuted = true;
				if (Registry.music != null) {
					Registry.music.volume = 0;
				}
			}
			updateMusicButton(button);
			Registry.saveGlobals();
		}
		
		public static function toggleSound(button:AxButton):void {
			Ax.soundMuted = !Ax.soundMuted;
			updateSoundButton(button);
			Registry.saveGlobals();
		}
		
		public static function toggleQuality(button:AxButton):void {
			if (Registry.quality == Quality.HIGH) {
				Registry.quality = Quality.MID;
			} else if (Registry.quality == Quality.MID) {
				Registry.quality = Quality.LOW;
			} else {
				Registry.quality = Quality.HIGH;
			}
			updateQualityButton(button);
			Registry.saveGlobals();
		}
		
		public static function updateMusicButton(button:AxButton):void {
			button.text("Music " + (Ax.musicMuted ? redText("Off") : greenText("On")), null, 7, 3);
		}
		
		public static function updateSoundButton(button:AxButton):void {
			button.text("Sound " + (Ax.soundMuted ? redText("Off") : greenText("On")), null, 7, 3);
		}
		
		public static function updateQualityButton(button:AxButton):void {
			button.text((Registry.quality == Quality.LOW ? redText("Low") : (Registry.quality == Quality.MID ? yellowText("Medium") : greenText("High"))) + " Quality", null, 7, 3);
		}
		
		private static function greenText(text:String):String {
			return colorText(text, GREEN);
		}
		
		private static function redText(text:String):String {
			return colorText(text, RED);
		}
		
		private static function yellowText(text:String):String {
			return colorText(text, YELLOW);
		}
		
		private static function colorText(text:String, color:String):String {
			return "@[" + color + "]" + text + "@[]";
		}
	}
}
