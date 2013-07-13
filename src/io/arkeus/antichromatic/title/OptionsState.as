package io.arkeus.antichromatic.title {
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.ouya.OuyaButton;
	import io.arkeus.antichromatic.ouya.OuyaButtonGroup;
	import io.arkeus.antichromatic.util.Analytics;
	import io.arkeus.antichromatic.util.Options;
	
	import org.axgl.Ax;
	import org.axgl.AxButton;
	import org.axgl.AxState;

	public class OptionsState extends AxState {
		private var music:AxButton;
		private var sound:AxButton;
		private var quality:AxButton;
		private var backButton:AxButton;
		private var buttons:OuyaButtonGroup;
		
		override public function create():void {
			noScroll();
			
			this.add(buttons = new OuyaButtonGroup);
			buttons.add(music = new OuyaButton(67, 168, Resource.BUTTON, 107, 24).text("Music On", null, 7, 3).onClick(toggleMusic));
			buttons.add(sound = new OuyaButton(186, 168, Resource.BUTTON, 107, 24).text("Sound On", null, 7, 3).onClick(toggleSound));
			//buttons.add(quality = new OuyaButton(127, 180, Resource.BUTTON, 107, 24).text("High Quality", null, 7, 3).onClick(toggleQuality));
			//buttons.add(backButton = new OuyaButton(186, 180, Resource.BUTTON, 107, 24).text("Controls", null, 7, 3).onClick(controls));
			buttons.add(backButton = new OuyaButton(127, 204, Resource.BUTTON, 107, 24).text("Back", null, 7, 3).onClick(back));
			
			Options.updateMusicButton(music);
			Options.updateSoundButton(sound);
			//Options.updateQualityButton(quality);
			
			Analytics.view("options");
			persistantDraw = false;
		}

		private function toggleMusic():void {
			Options.toggleMusic(music);
		}

		private function toggleSound():void {
			Options.toggleSound(sound);
		}

		private function toggleQuality():void {
			//Options.toggleQuality(quality);
		}
		
		private function controls():void {
			Ax.pushState(new ControlsState);
			Ax.keys.releaseAll();
			Ax.mouse.releaseAll();
		}

		private function back():void {
			Ax.popState();
			Ax.keys.releaseAll();
			Ax.mouse.releaseAll();
		}
	}
}
