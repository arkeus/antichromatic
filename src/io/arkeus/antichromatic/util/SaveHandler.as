package io.arkeus.antichromatic.util {
	import flash.net.SharedObject;
	
	import org.axgl.Ax;

	public class SaveHandler {
		private static const SO_NAME:String = "antichromatic";
		
		private var so:SharedObject;
		
		public function SaveHandler() {
			so = SharedObject.getLocal(SO_NAME);
		}
		
		public function save():void {
			try {
				so.data.deaths = Registry.deaths;
				so.data.time = Registry.time;
				so.data.swaps = Registry.swaps;
				so.data.items = Registry.items;
				so.data.flags = Registry.flags;
				so.data.difficulty = Registry.difficulty;
				
				so.data.initialX = Registry.initialX;
				so.data.initialY = Registry.initialY;
				so.data.roomOffsetX = Registry.roomOffsetX;
				so.data.roomOffsetY = Registry.roomOffsetY;
				so.data.transitionProperties = Registry.transitionProperties == null ? null : Registry.transitionProperties.serialize();
				
				so.data.mapData = Registry.mapData;
				
				so.flush();
				trace("Successfully saved");
			} catch (error:Error) {
				trace("Error saving", error);
			}
		}
		
		public function load():void {
			try {
				Registry.deaths = so.data.deaths;
				Registry.time = so.data.time;
				Registry.swaps = so.data.swaps;
				Registry.items = so.data.items;
				Registry.flags = so.data.flags;
				Registry.difficulty = so.data.difficulty;
				
				if (so.data.initialX != null) { Registry.initialX = so.data.initialX; }
				if (so.data.initialY != null) { Registry.initialY = so.data.initialY; }
				if (so.data.roomOffsetX != null) { Registry.roomOffsetX = so.data.roomOffsetX; }
				if (so.data.roomOffsetY != null) { Registry.roomOffsetY = so.data.roomOffsetY; }
				if (so.data.transitionProperties != null) { Registry.transitionProperties = TransitionProperties.deserialize(so.data.transitionProperties as Array); }
				
				if (so.data.mapData != null) { Registry.loadMap(so.data.mapData); }
				
				trace("Successfully loaded");
			} catch (error:Error) {
				trace("Error loading", error);
			}
		}
		
		public function erase():void {
			Registry.reset();
			save();
		}

		public function saveGlobals(musicMuted:Boolean, soundMuted:Boolean, quality:uint):void {
			try {
				so.data.musicMuted = musicMuted;
				so.data.soundMuted = soundMuted;
				so.data.quality = quality;
			} catch (error:Error) {
				trace("Error saving globals", error);
			}
		}
		
		public function loadGlobals():void {
			try {
				if (so.data.musicMuted != null) { Ax.musicMuted = so.data.musicMuted; }
				if (so.data.soundMuted != null) { Ax.soundMuted = so.data.soundMuted; }
				if (so.data.quality != null) { Registry.quality = so.data.quality; }
			} catch (error:Error) {
				trace("Error loading globals", error);
			}
		}
	}
}
