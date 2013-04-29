package io.arkeus.antichromatic.title {
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.assets.Sound;
	import io.arkeus.antichromatic.game.GameState;
	import io.arkeus.antichromatic.util.Registry;
	
	import org.axgl.Ax;
	import org.axgl.AxSprite;
	import org.axgl.AxState;
	import org.axgl.input.AxKey;
	import org.axgl.text.AxText;

	public class TitleState extends AxState {
		private var background:AxSprite;
		private var press:AxSprite;
		private var complete:Boolean = false;
		
		public function TitleState() {
			Registry.playMusic(TitleMusic);
		}
		
		override public function create():void {
			this.add(background = new AxSprite(0, 0, Resource.TITLE));
			background.noScroll();
			
			this.add(press = new AxSprite(0, 0, Resource.TITLE_KEY));
			press.origin.x = press.width / 2;
			press.origin.y = 203;
			press.noScroll();
			
			pressGrow();
			pressFadeOut();
			
			var mute:AxText = new AxText(55, Ax.viewHeight - 59, null, "PRESS @[ffcccc]M@[] TO MUTE", 250, "left");
			mute.alpha = 0.5;
			this.add(mute);
			
			var quality:AxText = new AxText(61, Ax.viewHeight - 59, null, "PRESS @[ffcccc]L@[] FOR LOW QUALITY", 250, "right");
			quality.alpha = 0.5;
			this.add(quality);
			
			initialize();
		}
		
		override public function update():void {
			if ((Ax.keys.pressed(AxKey.ANY) && !(Ax.keys.pressed(AxKey.M) || Ax.keys.pressed(AxKey.L)))) {
				if (!complete) {
					Ax.camera.fadeOut(0.5, 0xff000000, function():void {
						Sound.play("start");
						Ax.switchState(new GameState);
						Ax.camera.fadeIn(0.5);
					});
					complete = true;
				}
			}
			GameState.handleCommonLogic();
			super.update();
		}
		
		private function pressGrow():void {
			press.grow(1, 1.1, 1.1, pressShrink);
		}
		
		private function pressShrink():void {
			press.grow(1, 0.9, 0.9, pressGrow);	
		}
		
		private function pressFadeOut():void {
			press.fadeOut(1.7, 0.5, pressFadeIn);
		}
		
		private function pressFadeIn():void {
			press.fadeIn(1.7, 1, pressFadeOut);
		}
		
		private function initialize():void {
			Registry.initialize();
			Sound.initialize();
		}
	}
}
