package io.arkeus.antichromatic.sponsor.armorgames {
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundMixer;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import io.arkeus.antichromatic.title.TitleState;
	
	import org.axgl.Ax;
	import org.axgl.AxState;
	import org.axgl.AxU;

	// AG logo is 700x400
	public class ArmorGamesSplashState extends AxState {
		[Embed(source = "/sponsor/ag_intro_2011.swf", mimeType = "application/octet-stream")] private static var AG:Class;

		private var len:Number = 220;
		private var zoomFactor:int = 1;
		private var movie:Loader;

		override public function create():void {
			movie = new Loader();
			var lc:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			movie.loadBytes(new AG(), lc);
			movie.contentLoaderInfo.addEventListener(Event.COMPLETE, contentsRetrieve);
		}

		private function contentsRetrieve(e:Event):void {
			movie.scaleX = 1.0 / zoomFactor;
			movie.scaleY = 1.0 / zoomFactor;
			movie.x = 15;
			movie.y = 100;
			Ax.stage2D.addChildAt(movie, 0);
			movie.addEventListener(Event.EXIT_FRAME, next);
			Ax.stage2D.addEventListener(MouseEvent.CLICK, click);
		}

		private function next(e:Event):void {
			len--;
			if (len <= 0) {
				Ax.stage2D.removeChildAt(0);
				SoundMixer.stopAll();
				movie.removeEventListener(Event.EXIT_FRAME, next);
				Ax.stage2D.removeEventListener(MouseEvent.CLICK, click);
				movie.unloadAndStop(true);
				Ax.switchState(new TitleState);
			}
		}

		private function click(e:*):void {
			AxU.openURL("http://armor.ag/MoreGames");
		}
	}
}
