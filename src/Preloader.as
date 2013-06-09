package {
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getDefinitionByName;
	
	import io.arkeus.antichromatic.util.Release;
	
	[SWF(width = "720", height = "600", backgroundColor = "#ffffff")]

	public class Preloader extends MovieClip {
		[Embed(source="/misc/loading.png")] protected var LOADING:Class;
		
		private var siteLocked:Boolean = false;
		private var allowedURLs:Array = [
			"Users/Lee",
			"axgl.org",
			"projects.iarke.us",
			"kongregate.com",
			"newgrounds.com",
			"flashgamelicense.com",
			"fgl.com",
			"notdoppler.com",
			"ungrounded.net",
			"itch.io",
			"googleapis.com/itchio",
			"vigil.io",
			"vigil-paste",
		];
		
		public function Preloader() {
			stop();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			setSiteLock();
			
			var allowed:Boolean = false;
			for each(var url:String in allowedURLs) {
				if (root.loaderInfo.url.indexOf(url) >= 0) {
					allowed = true;
				}
			}
			
			if (!allowed && siteLocked) {
				navigateToURL(new URLRequest("http://arkeus.io"), "_self");
				throw new Error("Invalid");
			}
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function setSiteLock():void {
			if (Release.NAME == Release.ADDICTING_GAMES) {
				if (!addictingGamesSiteLock()) {
					//throw new Error("Invalid");
				}
			} else if (Release.NAME == Release.ARMOR_GAMES) {
				siteLocked = true;
				allowedURLs = ["armorgames.com", "vigil-paste", "axgl.org", "Users/Lee"];
			}
		}

		private function addictingGamesSiteLock():Boolean {
			var siteLock:RegExp = /^(http|https):\/\/([-a-zA-Z0-9\.])+\.(shockwave|addictinggames|mtvi)\.com(\/|$)/;
			return (siteLock.test(root.loaderInfo.url));
		}
		
		private var loading:Bitmap, percent:TextField;
		private function create():void {
			loading = new LOADING;
			loading.x = root.loaderInfo.width / 2 - 25;
			loading.y = root.loaderInfo.height / 2 - 11;
			addChild(loading);
			
			var tf:TextFormat = new TextFormat;
			tf.size = 16;
			tf.align = TextFormatAlign.CENTER;
			tf.color = 0x990000;
			
			percent = new TextField;
			percent.x = root.loaderInfo.width / 2 - 5;
			percent.y = root.loaderInfo.height / 2 - 11;
			percent.width = 46;
			percent.defaultTextFormat = tf;
			addChild(percent);
		}
		
		private var created:Boolean = false;
		private function onEnterFrame(event:Event):void {
			if (!created) {
				create();
				created = true;
			} else {
				percent.text = Math.floor((loaderInfo.bytesLoaded / loaderInfo.bytesTotal) * 100) + "%"; 
				if (framesLoaded >= totalFrames) {
					removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					removeChild(loading);
					removeChild(percent);
					nextFrame();
					addChild(new (getDefinitionByName("Antichromatic") as Class));
				}
			}
		}
	}
}
