package io.arkeus.antichromatic.util {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.game.GameState;
	import io.arkeus.antichromatic.game.entity.Player;
	import io.arkeus.antichromatic.game.world.World;
	
	import org.axgl.Ax;
	import org.axgl.sound.AxSound;

	public class Registry {
		public static var game:GameState;
		public static var player:Player;
		public static var map:BitmapData;
		
		public static var difficulty:uint = Difficulty.NORMAL;
		
		public static var items:Vector.<uint>;
		public static var flags:Vector.<uint>;
		
		public static var deaths:uint = 0;
		public static var time:Number = 0;
		public static var swaps:uint = 0;
		
		public static var initialX:Number = -1;
		public static var initialY:Number = -1;
		public static var roomOffsetX:int = 0;
		public static var roomOffsetY:int = 0;
		public static var transitionProperties:TransitionProperties;
		
		public static var mapData:Object;
		
		private static var saveHandler:SaveHandler;
		
		public static var loading:Boolean = false;
		
		public static function reset():void {
			deaths = time = swaps = 0;
			items = Config.ALL_ITEMS ? new <uint>[1, 1, 1, 1, 1, 1, 1, 1] : new <uint>[0, 0, 0, 0, 0, 0, 0, 0];
			flags = new Vector.<uint>(Flag.NUM_FLAGS);
			map = (new Resource.MAP as Bitmap).bitmapData;
			
			initialX = -1;
			initialY = -1;
			roomOffsetX = 0;
			roomOffsetY = 0;
			transitionProperties = null;
			mapData = {};
		}
		
		public static function hasItem(item:uint):Boolean {
			return items[item] == 1;
		}

		public static function obtainItem(itemId:uint):void {
			items[itemId] = 1;
		}
		
		public static function initialize():void {
			reset();
			saveHandler = new SaveHandler;
			saveHandler.loadGlobals();
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
		
		public static function save():void {
			saveHandler.save();
		}
		
		public static function load():void {
			saveHandler.load();
		}
		
		public static function erase():void {
			saveHandler.erase();
		}
		
		public static function saveGlobals():void {
			saveHandler.saveGlobals(Ax.musicMuted, Ax.soundMuted, quality);
		}
		
		public static function loadMap(mapData:Object):void {
			Registry.mapData = mapData;
			map = (new Resource.MAP as Bitmap).bitmapData;
			
			for (var key:String in mapData) {
				var mData:Array = key.split("_");
				var mx:uint = parseInt(mData[0]);
				var my:uint = parseInt(mData[1]);
				var mw:uint = mapData[key][0];
				var mh:uint = mapData[key][1];
				for (var x:uint = mx; x < mx + mw; x++) {
					for (var y:uint = my; y < my + mh; y++) {
						Registry.map.setPixel(x, y, World.MAP_KNOWN_COLOR);
					}
				}
			}
		}
	}
}
