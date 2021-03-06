package io.arkeus.antichromatic.scene {
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.game.GameState;
	import io.arkeus.antichromatic.util.Analytics;
	import io.arkeus.antichromatic.util.Registry;
	
	import org.axgl.Ax;

	public class IntroState extends SceneState {
		public function IntroState() {
			super(20, INTRO_MESSAGES, Resource.INTRO, Resource.INTRO_ROOMS);
			Analytics.view("intro");
		}
		
		override protected function onComplete():void {
			Ax.camera.fadeOut(2, 0xff000000, function():void {
				Ax.switchState(new GameState);
				Ax.camera.fadeIn(0.5, function():void { Registry.loading = false; });
				Ax.keys.releaseAll();
				Ax.mouse.releaseAll();
			});
		}
		
		override protected function onSkip():void {
			Analytics.view("skip-intro");
		}
		
		private static const INTRO_MESSAGES:Array = [
			"It's been nearly a year since our world was @[bfa747]fractured@[]. Split in two, we've been trying to restore it ever since.",
			"We're a small group known as @[bfa747]Chroma@[], and we're the last hope this world has.",
			"Until the @[bfa747]shattering@[], our world was like any other. But on that fateful day the world was fractured in two. Everything and everyone was split between @[bfa747]two dimensions@[].",
			"We've tracked down the @[bfa747]source@[] of the @[bfa747]shattering@[] to a single facility. We have no doubt we'll find the source of the event somewhere within.",
			"We've infiltrated the facility and obtained a single suit of @[bfa747]Chromatic Armor@[], allowing me to pass between the @[bfa747]two fractured dimensions@[] at will.",
			"If I can track down and @[bfa747]destroy the source@[], I believe we can restore the world to it's former glory."
		];
	}
}
