package io.arkeus.antichromatic.splash {
	import flash.events.MouseEvent;
	
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.title.TitleState;
	import io.arkeus.antichromatic.util.Registry;
	import io.arkeus.antichromatic.util.Release;
	
	import org.axgl.Ax;
	import org.axgl.AxSprite;
	import org.axgl.AxState;
	import org.axgl.AxU;
	import org.axgl.text.AxText;

	public class SplashState extends AxState {
		private static const DISPLAY_TIME:Number = 3;
		private static const FADE_TIME:Number = 1;
		private static const WAIT_TIME:Number = 0.5;
		
		private var background:AxSprite;
		private var delay:Number = 0;
		private var url:String = null;
		private var clicked:Boolean = false;
		
		public function SplashState() {
			Registry.playMusic(TitleMusic);
		}
		
		override public function create():void {
			noScroll();
			this.add(background = new AxSprite(0, 0, Resource.SPLASH_BACKGROUND));
			
			for each(var splash:Array in SPLASHES) {
				displaySplash(splash);
				if (Release.NAME == Release.ADDICTING_GAMES) {
					break;
				}
			}
			
			addTimer(delay, function():void {
				onComplete();
			});
			
			if (Ax.mode.toLowerCase().indexOf("software") != -1) {
				var back:AxSprite = new AxSprite(0, 240);
				back.create(Ax.viewWidth, 40, 0xaa000000);
				this.add(back);
				this.add(new AxText(0, 250, null, "@[ff0000]WARNING@[]: Your computer does not support hardware rendering, please lower quality in main menu if you experience slowness.@[]", Ax.viewWidth, "center"));
			}
			
			Ax.stage2D.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(event:MouseEvent):void {
			if (url != null && !clicked) {
				AxU.openURL(url);
				clicked = true;
			}
		}
		
		private function onComplete():void {
			Ax.stage2D.removeEventListener(MouseEvent.CLICK, onClick);
			Ax.switchState(new TitleState);
		}
		
		private function displaySplash(splash:Array):void {
			var self:SplashState = this;
			addTimer(delay, function():void {
				url = splash[1];
				clicked = false;
				var sprite:AxSprite = new AxSprite(0, 0, splash[2]);
				self.add(sprite);
				sprite.alpha = 0;
				sprite.fadeIn(FADE_TIME, 1, function():void {
					addTimer(DISPLAY_TIME, function():void {
						sprite.fadeOut(FADE_TIME, 0, function():void {
							url = null;
						});
					});
				});
			});
			delay += FADE_TIME * 2 + DISPLAY_TIME + WAIT_TIME;
		}
		
		private static const SPLASHES:Array = [
			["Blog", "http://arkeus.io", Resource.SPLASH_BLOG],
			["Axel", "http://axgl.org", Resource.SPLASH_AXEL],
		];
	}
}
