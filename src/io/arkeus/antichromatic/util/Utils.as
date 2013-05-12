package io.arkeus.antichromatic.util {
	public class Utils {
		public static function formatTime(time:Number):String {
			var h:uint = Math.floor(time / 3600);
			time -= h * 3600;
			var m:uint = Math.floor(time / 60);
			var s:uint = Math.floor(time % 60);
			return (h == 0 ? "" : h + ":") + (m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s;
		}
	}
}
