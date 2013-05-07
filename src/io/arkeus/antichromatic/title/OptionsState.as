package io.arkeus.antichromatic.title {
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.util.Options;
	
	import org.axgl.Ax;
	import org.axgl.AxButton;
	import org.axgl.AxState;

	public class OptionsState extends AxState {
		private var music:AxButton;
		private var sound:AxButton;
		private var quality:AxButton;
		private var backButton:AxButton;
		
		override public function create():void {
			this.add(music = new AxButton(67, 156, Resource.BUTTON, 107, 24).text("Music On", null, 7, 3).onClick(toggleMusic));
			this.add(sound = new AxButton(186, 156, Resource.BUTTON, 107, 24).text("Sound On", null, 7, 3).onClick(toggleSound));
			this.add(quality = new AxButton(67, 192, Resource.BUTTON, 107, 24).text("High Quality", null, 7, 3).onClick(toggleQuality));
			this.add(backButton = new AxButton(186, 192, Resource.BUTTON, 107, 24).text("Back", null, 7, 3).onClick(back));
			
			Options.updateMusicButton(music);
			Options.updateSoundButton(sound);
			Options.updateQualityButton(quality);
		}

		private function toggleMusic():void {
			Options.toggleMusic(music);
		}

		private function toggleSound():void {
			Options.toggleSound(sound);
		}

		private function toggleQuality():void {
			Options.toggleQuality(quality);
		}

		private function back():void {
			Ax.popState();
			Ax.keys.releaseAll();
			Ax.mouse.releaseAll();
			trace("POPPED");
		}
	}
}
