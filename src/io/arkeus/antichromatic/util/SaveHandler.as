package io.arkeus.antichromatic.util {
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	
	import io.arkeus.antichromatic.util.base64.Base64;
	
	import org.axgl.Ax;

	public class SaveHandler {
		private static const SO_NAME:String = "antichromatic";
		
		private var so:SharedObject;
		
		public function SaveHandler() {
			so = SharedObject.getLocal(SO_NAME);
		}
		
		public function hasSave():Boolean {
			return so.data.time > 0;
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
				so.data.localSaveFile = localChecksum;
				trace("SAVED LOCAL CHECKSUM", localChecksum);
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
				
				var loadedSaveFile:String = so.data.localSaveFile;
				if (loadedSaveFile != localChecksum) {
					Registry.reset();
					throw new Error("Invalid checksum");
				}
				
				trace("Successfully loaded");
			} catch (error:Error) {
				trace("Error loading", error);
			}
		}
		
		public function erase():void {
			Registry.reset();
			save();
		}

		public function saveGlobals(musicMuted:Boolean, soundMuted:Boolean, quality:uint, controls:uint):void {
			try {
				so.data.musicMuted = musicMuted;
				so.data.soundMuted = soundMuted;
				//so.data.quality = quality;
				//so.data.controls = controls;
				
				so.data.normalDeaths = Registry.normalDeaths;
				so.data.normalTime = Registry.normalTime;
				so.data.hardDeaths = Registry.hardDeaths;
				so.data.hardTime = Registry.hardTime;
				
				so.data.globalSaveFile = globalChecksum;
			} catch (error:Error) {
				trace("Error saving globals", error);
			}
		}
		
		public function loadGlobals():void {
			try {
				if (so.data.musicMuted != null) { Ax.musicMuted = so.data.musicMuted; }
				if (so.data.soundMuted != null) { Ax.soundMuted = so.data.soundMuted; }
				//if (so.data.quality != null) { Registry.quality = so.data.quality; }
				//if (so.data.controls != null) { Registry.controls = so.data.controls; }
				if (so.data.normalDeaths != null) { Registry.normalDeaths = so.data.normalDeaths; }
				if (so.data.normalTime != null) { Registry.normalTime = so.data.normalTime; }
				if (so.data.hardDeaths != null) { Registry.hardDeaths = so.data.hardDeaths; }
				if (so.data.hardTime != null) { Registry.hardTime = so.data.hardTime; }
				
				var loadedSaveFile:String = so.data.globalSaveFile;
				if (loadedSaveFile != globalChecksum) {
					Registry.resetGlobals();
					throw new Error("Invalid checksum");
				}
			} catch (error:Error) {
				trace("Error loading globals", error);
			}
		}
		
		private static const DELIMITER:String = "\n";
		private static const CHARSET:String = "iso-8859-1";
		
		public function get localChecksum():String {
			return checksum(Registry.deaths, Registry.time, Registry.difficulty, Registry.initialX, Registry.initialY);
		}
		
		public function get globalChecksum():String {
			return checksum(Registry.normalDeaths, Registry.normalTime, Registry.hardDeaths, Registry.hardTime);
		}
		
		public function checksum(...values):String {
			var cs:Vector.<String> = new <String>[];
			for each(var value:String in values) {
				cs.push(value);
			}
			var ba:ByteArray = new ByteArray;
			ba.writeMultiByte(cs.join(DELIMITER), CHARSET);
			return Base64.encode(ba);
		}
	}
}
