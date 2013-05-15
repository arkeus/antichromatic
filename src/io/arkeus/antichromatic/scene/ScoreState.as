package io.arkeus.antichromatic.scene {
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.util.Analytics;
	import io.arkeus.antichromatic.util.Registry;
	import io.arkeus.antichromatic.util.Utils;
	
	import org.axgl.Ax;
	import org.axgl.AxButton;
	import org.axgl.AxSprite;
	import org.axgl.AxState;
	import org.axgl.input.AxKey;
	import org.axgl.text.AxText;

	public class ScoreState extends AxState {
		override public function create():void {
			noScroll();
			alpha = 0;
			
			this.add(new AxSprite(0, 0, Resource.SCORE_FRAME));
			
			this.add(new AxText(61, 147, null, "@[bbbbbb]Total Time@[]", 79, "center"));
			this.add(new AxText(61 + 79 * 1, 147, null, "@[bbbbbb]Deaths@[]", 79, "center"));
			this.add(new AxText(61 + 79 * 2, 147, null, "@[bbbbbb]Color Swaps@[]", 79, "center"));
			
			this.add(new AxText(61, 159, null, Utils.formatTime(Registry.time), 79, "center"));
			this.add(new AxText(61 + 79 * 1, 159, null, Registry.deaths.toString(), 79, "center"));
			this.add(new AxText(61 + 79 * 2, 159, null, Registry.swaps.toString(), 79, "center"));
			
			Ax.keys.releaseAll();
			Ax.mouse.releaseAll();
			this.add(new AxButton(Ax.viewWidth / 2 - 107 / 2, 181, Resource.BUTTON, 107, 24).text("Continue", null, 7, 3).onClick(back));
			update();
			
			Analytics.view("score");
		}
		
		private function back():void {
			Ax.popState();
		}
		
		override public function update():void {
			alpha += Ax.dt;
			
			super.update();
			
			if (Ax.keys.pressed(AxKey.ESCAPE)) {
				back();
			}
		}
	}
}
