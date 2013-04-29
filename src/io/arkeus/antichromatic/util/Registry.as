package io.arkeus.antichromatic.util {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.game.GameState;
	import io.arkeus.antichromatic.game.entity.Player;
	
	import org.axgl.Ax;
	import org.axgl.sound.AxSound;

	public class Registry {
		public static var game:GameState;
		public static var player:Player;
		public static var map:BitmapData;
		
		public static var items:Vector.<uint> = Config.ALL_ITEMS ? new <uint>[1, 1, 1, 1, 1, 1, 1, 1] : new <uint>[0, 0, 0, 0, 0, 0, 0, 0];
		public static var flags:Vector.<uint> = new Vector.<uint>(Flag.NUM_FLAGS);
		
		public static var deaths:uint = 0;
		public static var time:Number = 0;
		public static var swaps:uint = 0;
		
		public static function hasItem(item:uint):Boolean {
			return items[item] == 1;
		}

		public static function obtainItem(itemId:uint):void {
			items[itemId] = 1;
		}
		
		public static function initialize():void {
			if (map == null) {
				map = (new Resource.MAP as Bitmap).bitmapData;
			}
			deaths = 0;
			time = 0;
			swaps = 0;
		}
		
		public static var music:AxSound;
		public static var musicClass:Class;
		public static var quality:uint = 1;
		
		public static function playMusic(m:Class):void {
			if (m == musicClass || !Config.SOUND_ENABLED) {
				return;
			}
			if (music != null) {
				music.destroy();
				music.dispose();
			}
			musicClass = m;
			music = Ax.music(m, 0.7);
			music.volume = Ax.musicMuted ? 0 : 0.7;
		}
	}
}
