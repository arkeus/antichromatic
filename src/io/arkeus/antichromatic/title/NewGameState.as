package io.arkeus.antichromatic.title {
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.assets.Sound;
	import io.arkeus.antichromatic.game.GameState;
	import io.arkeus.antichromatic.scene.IntroState;
	import io.arkeus.antichromatic.util.Analytics;
	import io.arkeus.antichromatic.util.Difficulty;
	import io.arkeus.antichromatic.util.Registry;
	
	import org.axgl.Ax;
	import org.axgl.AxButton;
	import org.axgl.AxState;
	import org.axgl.text.AxText;

	public class NewGameState extends AxState {
		private var veryHard:AxButton;
		
		override public function create():void {
			this.add(new AxText(4, 146, null, "Choose A Difficulty", Ax.viewWidth, "center"));
			this.add(new AxButton(67, 168, Resource.BUTTON, 107, 24).text("Hard", null, 7, 3).onClick(normal));
			this.add(veryHard = new AxButton(186, 168, Resource.BUTTON, 107, 24).text("Very Hard", null, 7, 3).onClick(hard));
			this.add(new AxButton(127, 204, Resource.BUTTON, 107, 24).text("Cancel", null, 7, 3).onClick(back));
			
			if (!Registry.difficultyComplete(Difficulty.NORMAL)) {
				veryHard.color.hex = 0xffff0000;
			}
			
			Analytics.view("new-game");
		}
		
		override public function update():void {
			if (!Registry.difficultyComplete(Difficulty.NORMAL) && veryHard.hover()) {
				veryHard.text("@[ff0000]LOCKED@[]", null, 7, 3);
			} else {
				veryHard.text("Very Hard", null, 7, 3);
			}
			
			super.update();
		}
		
		private function normal():void {
			start(Difficulty.NORMAL);
		}
		
		private function hard():void {
			if (!Registry.difficultyComplete(Difficulty.NORMAL)) {
				return;
			}
			start(Difficulty.HARD);
		}
			
		private function start(difficulty:uint):void {
			Analytics.view("new-game-start");
			Ax.camera.fadeOut(0.5, 0xff000000, function():void {
				Registry.erase();
				Registry.difficulty = difficulty;
				Ax.popState();
				Ax.switchState(difficulty == Difficulty.NORMAL ? new IntroState : new GameState);
				Sound.play("start");
				Ax.camera.fadeIn(0.5);
				Ax.keys.releaseAll();
				Ax.mouse.releaseAll();
			});
		}
		
		private function back():void {
			Ax.popState();
			Ax.keys.releaseAll();
			Ax.mouse.releaseAll();
		}
	}
}
