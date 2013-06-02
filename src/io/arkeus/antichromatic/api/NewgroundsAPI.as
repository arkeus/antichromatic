package io.arkeus.antichromatic.api {
	import com.newgrounds.API;
	
	import io.arkeus.antichromatic.util.Difficulty;
	import io.arkeus.antichromatic.util.Registry;
	
	import org.axgl.Ax;

	public class NewgroundsAPI extends io.arkeus.antichromatic.api.API {
		override public function connect():void {
			com.newgrounds.API.connect(Ax.stage2D, "32437:EyAmtdfp", "zqeZ7bjQAhfvhJTrdRTMmUwwVCAqo9xD");
		}
		
		override public function sendAll():void {
			if (Registry.difficultyComplete(Difficulty.NORMAL)) {
				send("Semi Fracture");
				if (Registry.normalTime < 10 * 60) {
					send("Fracture");
				}
				if (Registry.normalDeaths == 0) {
					send("Immune Fracture");
				}
			}
			if (Registry.difficultyComplete(Difficulty.HARD)) {
				send("Full Fracture");
				if (Registry.hardTime < 40 * 60) {
					send("Quick Fracture");
				}
				if (Registry.hardTime < 20 * 60) {
					send("Perfect Fracture");
				}
			}
		}
		
		private function send(name:String):void {
			com.newgrounds.API.unlockMedal(name);
		}
	}
}
