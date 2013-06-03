package io.arkeus.antichromatic.api {
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	import io.arkeus.antichromatic.util.Difficulty;
	import io.arkeus.antichromatic.util.Registry;
	
	import org.axgl.Ax;

	public class KongAPI extends API {
		// Kongregate API reference
		private static var kongregate:*;
		private static var loaded:Boolean = false;
		
		override public function connect():void {
			var root:Stage = Ax.stage2D;
			
			// Pull the API path from the FlashVars
			var paramObj:Object = LoaderInfo(root.loaderInfo).parameters;
			
			// The API path. The "shadow" API will load if testing locally. 
			var apiPath:String = paramObj.kongregate_api_path || "http://www.kongregate.com/flash/API_AS3_Local.swf";
			
			// Allow the API access to this SWF
			Security.allowDomain(apiPath);
			
			// Load the API
			var request:URLRequest = new URLRequest(apiPath);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			loader.load(request);
			root.addChild(loader);
		}
		
		override public function sendAll():void {
			if (Registry.difficultyComplete(Difficulty.NORMAL)) {
				send("HardModeCompleted", 1);
				send("HardModeDeaths", Registry.normalDeaths);
				send("HardModeTime", Math.floor(Registry.normalTime * 1000));
			}
			if (Registry.difficultyComplete(Difficulty.HARD)) {
				send("VeryHardModeCompleted", 1);
				send("VeryHardModeDeaths", Registry.hardDeaths);
				send("VeryHardModeTime", Math.floor(Registry.hardTime * 1000));
			}
		}
		
		private function loadComplete(event:Event):void {
			// Save Kongregate API reference
			kongregate = event.target.content;
			
			// Connect to the back-end
			kongregate.services.connect();
			
			// Set loaded
			loaded = true;
		}
		
		private function send(name:String, value:Number):void
		{
			if (!loaded) {
				trace("Kong API not loaded, not submitting stat", name);
				return;
			}
			
			trace("[KONG] " + name + " (" + value + ")");
			kongregate.stats.submit(name, value);
		}
	}
}
