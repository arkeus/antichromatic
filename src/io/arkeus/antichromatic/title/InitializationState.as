package io.arkeus.antichromatic.title {
	import io.arkeus.antichromatic.assets.Sound;
	import io.arkeus.antichromatic.game.GameState;
	import io.arkeus.antichromatic.util.Analytics;
	import io.arkeus.antichromatic.util.Config;
	import io.arkeus.antichromatic.util.Registry;
	
	import org.axgl.Ax;
	import org.axgl.AxState;

	public class InitializationState extends AxState {
		override public function create():void {
			Registry.initialize();
			Sound.initialize();
			Analytics.initialize();
			
			Ax.switchState(Config.TITLE_ENABLED ? new TitleState : new GameState);
		}
	}
}
