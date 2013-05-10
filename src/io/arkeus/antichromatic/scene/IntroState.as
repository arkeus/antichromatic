package io.arkeus.antichromatic.scene {
	public class IntroState extends SceneState {
		public function IntroState() {
			super(20, INTRO_MESSAGES);
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
