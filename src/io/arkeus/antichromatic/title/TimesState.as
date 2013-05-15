package io.arkeus.antichromatic.title {
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.util.Analytics;
	import io.arkeus.antichromatic.util.Difficulty;
	import io.arkeus.antichromatic.util.Registry;
	import io.arkeus.antichromatic.util.Utils;
	
	import org.axgl.Ax;
	import org.axgl.AxButton;
	import org.axgl.AxState;
	import org.axgl.text.AxText;
	
	public class TimesState extends AxState {
		private static const INCOMPLETE_STRING:String = "Incomplete";
		
		private var backButton:AxButton;
		
		override public function create():void {
			noScroll();
			this.add(backButton = new AxButton(127, 216, Resource.BUTTON, 107, 24).text("Back", null, 7, 3).onClick(back));
			
			this.add(new AxText(63, 145, null, "Best @[d9ff9a]Hard Mode@[] Time"));
			this.add(new AxText(63, 145, null, "@[d9ff9a]" + normalTime + "@[]", 240, "right"));
			
			this.add(new AxText(63, 157, null, "Fewest @[d9ff9a]Hard Mode@[] Deaths"));
			this.add(new AxText(63, 157, null, "@[d9ff9a]" + normalDeaths + "@[]", 240, "right"));
			
			this.add(new AxText(63, 181, null, "Best @[ff9a9a]Very Hard Mode@[] Time"));
			this.add(new AxText(63, 181, null, "@[ff9a9a]" + hardTime + "@[]", 240, "right"));
			
			this.add(new AxText(63, 193, null, "Fewest @[ff9a9a]Very Hard Mode@[] Deaths"));
			this.add(new AxText(63, 193, null, "@[ff9a9a]" + hardDeaths + "@[]", 240, "right"));
			
			Analytics.view("times");
		}
		
		private function get normalTime():String {
			if (Registry.difficultyComplete(Difficulty.NORMAL)) {
				return Utils.formatTime(Registry.normalTime);
			}
			return INCOMPLETE_STRING;
		}
		
		private function get normalDeaths():String {
			if (Registry.difficultyComplete(Difficulty.NORMAL)) {
				return Registry.normalDeaths.toString();
			}
			return INCOMPLETE_STRING;
		}
		
		private function get hardTime():String {
			if (Registry.difficultyComplete(Difficulty.HARD)) {
				return Utils.formatTime(Registry.hardTime);
			}
			return INCOMPLETE_STRING;
		}
		
		private function get hardDeaths():String {
			if (Registry.difficultyComplete(Difficulty.HARD)) {
				return Registry.hardDeaths.toString();
			}
			return INCOMPLETE_STRING;
		}
		
		private function back():void {
			Ax.popState();
			Ax.keys.releaseAll();
			Ax.mouse.releaseAll();
		}
	}
}

