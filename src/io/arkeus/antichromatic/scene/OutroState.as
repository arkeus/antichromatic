package io.arkeus.antichromatic.scene {
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.title.TitleState;
	import io.arkeus.antichromatic.util.Registry;
	
	import org.axgl.Ax;

	public class OutroState extends SceneState {
		private static const MESSAGES_STATE:uint = 0;
		private static const SCORE_STATE:uint = 1;
		
		private var state:uint = MESSAGES_STATE;
		
		public function OutroState() {
			super(20, MESSAGES, Resource.OUTRO, Resource.OUTRO_ROOMS);
		}
		
		override protected function onComplete():void {
			if (state == MESSAGES_STATE) {
				Ax.pushState(new ScoreState);
				state = SCORE_STATE;
			} else if (state == SCORE_STATE) {
				Ax.camera.fadeOut(2, 0xff000000, function():void {
					Ax.switchState(new TitleState);
					Ax.camera.fadeIn(0.5, function():void { Registry.loading = false; });
					Ax.keys.releaseAll();
					Ax.mouse.releaseAll();
				});
			}
		}
		
		private static const MESSAGES:Array = [
			"With the death of @[bfa747]The Source@[], the energy holding the dimensions apart began to fade.",
			"With time, objects that had been scattered across the worlds began to be @[bfa747]reunited@[].",
			"@[bfa747]Families and friends@[] that had been separated were finally able to see each other for the first time in a year.", 
			"@[bfa747]Chroma@[] continues to monitor the drifting of the dimensions, ready to intervene should the @[bfa747]threat@[] emerge once more."
		];
	}
}
