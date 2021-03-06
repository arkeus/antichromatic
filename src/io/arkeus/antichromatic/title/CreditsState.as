package io.arkeus.antichromatic.title {
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.util.Analytics;
	
	import org.axgl.Ax;
	import org.axgl.AxButton;
	import org.axgl.AxSprite;
	import org.axgl.AxState;
	
	public class CreditsState extends AxState {
		private var backButton:AxButton;
		private var credits:AxSprite;
		
		override public function create():void {
			noScroll();
			this.add(backButton = new AxButton(127, 216, Resource.BUTTON, 107, 24).text("Back", null, 7, 3).onClick(back));
			this.add(credits = new AxSprite(0, 0, Resource.CREDITS));
			
			Analytics.view("credits");
		}
		
		private function back():void {
			Ax.popState();
			Ax.keys.releaseAll();
			Ax.mouse.releaseAll();
		}
	}
}