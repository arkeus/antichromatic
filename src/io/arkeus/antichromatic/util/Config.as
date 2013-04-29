package io.arkeus.antichromatic.util {
	import io.arkeus.antichromatic.assets.Resource;

	public class Config {
		public static const INVINCIBLE:Boolean = true;
		public static const INFINITE_JUMPS:Boolean = true;
		public static const ALL_ITEMS:Boolean = true;
		public static const SOUND_ENABLED:Boolean = true;
		
		public static const MESSAGE_OPTIONS:Object = {
			background: Resource.MESSAGE_BOX,
			x: 55,
			y: 225,
			width: 250,
			height: 55,
			paddingLeft: 12,
			paddingRight: 12,
			paddingTop: 12,
			paddingBottom: 12,
			delay: 4,
			speedDelay: 2
		};
	}
}
