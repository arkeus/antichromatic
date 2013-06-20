package io.arkeus.antichromatic.sponsor.addictinggames {
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundMixer;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import io.arkeus.antichromatic.splash.SplashState;
	import io.arkeus.antichromatic.title.TitleState;
	
	import org.axgl.Ax;
	import org.axgl.AxState;
	import org.axgl.AxU;

	// AG logo is 700x400
	public class AddictingGamesSplashState extends AxState {
		[Embed(source = "/sponsor/AddictingGamesStinger.swf", mimeType = "application/octet-stream")] private static var AG:Class;

		private var len:Number = 133;
		private var zoomFactor:int = 1;
		private var movie:Loader;
		private var clicked:Boolean = false;

		override public function create():void {
			movie = new Loader();
			var lc:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			movie.loadBytes(new AG(), lc);
			movie.contentLoaderInfo.addEventListener(Event.COMPLETE, contentsRetrieve);
		}

		private function contentsRetrieve(e:Event):void {
			Ax.requestedFramerate = Ax.unfocusedFramerate = Ax.stage2D.frameRate = 24;
			movie.scaleX = 0.5;
			movie.scaleY = 0.68;
			movie.x = 0;
			movie.y = 0;
			Ax.stage2D.addChildAt(movie, 0);
			movie.addEventListener(Event.EXIT_FRAME, next);
			Ax.stage2D.addEventListener(MouseEvent.CLICK, click);
		}

		private function next(e:Event):void {
			len--;
			if (len <= 0) {
				Ax.requestedFramerate = Ax.unfocusedFramerate = Ax.stage2D.frameRate = 60;
				Ax.stage2D.removeChildAt(0);
				SoundMixer.stopAll();
				var mc:MovieClip = movie.content as MovieClip;
				if (mc != null) {
					mc.stop();
				}
				movie.removeEventListener(Event.EXIT_FRAME, next);
				Ax.stage2D.removeEventListener(MouseEvent.CLICK, click);
				movie.unloadAndStop(true);
				Ax.switchState(new SplashState);
			}
		}

		private function click(e:*):void {
			if (clicked) {
				return;
			}
			
			clicked = true;
			AxU.openURL("http://www.addictinggames.com/");
		}
	}
}

