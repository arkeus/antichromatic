package io.arkeus.antichromatic.util {
	import org.axgl.Ax;
	import org.axgl.AxGroup;
	import org.axgl.AxSimpleSprite;
	import org.axgl.text.AxText;

	public class HUD extends AxGroup {
		private var time:AxText;
		private var timeFrame:AxSimpleSprite;
		private var deaths:AxText;
		private var deathFrame:AxSimpleSprite;
		
		public function HUD() {
			noScroll();
			
			time = new AxText(Ax.viewWidth - 54, Ax.viewHeight - 24, null, "00:00", 48, "center");
			time.alpha = 0.7;
			timeFrame = new AxSimpleSprite(time.x - 2, time.y - 2);
			timeFrame.create(44, time.height + 4, 0xaa000000);
			this.add(timeFrame);
			this.add(time);
			
			deaths = new AxText(14, time.y, null, "10 Deaths", 76, "center");
			deaths.alpha = 0.7;
			deathFrame = new AxSimpleSprite(deaths.x - 2, time.y - 2);
			deathFrame.create(76, deaths.height + 4, 0xaa000000);
			this.add(deathFrame);
			this.add(deaths);
		}
		
		override public function update():void {
			deaths.text = Registry.deaths + " Death" + (Registry.deaths == 1 ? "" : "s");
			time.text = Utils.formatTime(Registry.time);
			
			super.update();
		}
	}
}
