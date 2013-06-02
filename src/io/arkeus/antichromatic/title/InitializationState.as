package io.arkeus.antichromatic.title {
	import io.arkeus.antichromatic.api.KongAPI;
	import io.arkeus.antichromatic.api.NewgroundsAPI;
	import io.arkeus.antichromatic.assets.Sound;
	import io.arkeus.antichromatic.game.GameState;
	import io.arkeus.antichromatic.splash.SplashState;
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
			
			if (Config.RELEASE == Config.KONGREGATE) {
				Registry.api = new KongAPI;
			} else if (Config.RELEASE == Config.NEWGROUNDS) {
				Registry.api = new NewgroundsAPI;
			}
			
			Ax.switchState(Config.TITLE_ENABLED ? (Config.SPLASH_ENABLED ? new SplashState : new TitleState) : new GameState);
		}
	}
}
