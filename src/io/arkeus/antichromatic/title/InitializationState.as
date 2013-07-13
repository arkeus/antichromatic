package io.arkeus.antichromatic.title {
	import io.arkeus.antichromatic.api.KongAPI;
	import io.arkeus.antichromatic.api.NewgroundsAPI;
	import io.arkeus.antichromatic.assets.Sound;
	import io.arkeus.antichromatic.game.GameState;
	import io.arkeus.antichromatic.splash.SplashState;
	import io.arkeus.antichromatic.sponsor.addictinggames.AddictingGamesSplashState;
	import io.arkeus.antichromatic.sponsor.armorgames.ArmorGamesSplashState;
	import io.arkeus.antichromatic.util.Analytics;
	import io.arkeus.antichromatic.util.Config;
	import io.arkeus.antichromatic.util.Registry;
	import io.arkeus.antichromatic.util.Release;
	
	import org.axgl.Ax;
	import org.axgl.AxState;

	public class InitializationState extends AxState {
		override public function create():void {
			Registry.initialize();
			Sound.initialize();
			
			if (Release.NAME != Release.ADDICTING_GAMES && Release.NAME != Release.ARMOR_GAMES && Release.NAME != Release.LOCAL) {
				Analytics.initialize();
			}
			
			if (Release.NAME == Release.KONGREGATE) {
				Registry.api = new KongAPI;
			} else if (Release.NAME == Release.NEWGROUNDS) {
				Registry.api = new NewgroundsAPI;
			}
			
			if (Release.NAME == Release.ADDICTING_GAMES) {
				Ax.switchState(new AddictingGamesSplashState);
			} else if (Release.NAME == Release.ARMOR_GAMES) {
				Ax.switchState(new ArmorGamesSplashState);				
			} else {
				Ax.switchState(Config.TITLE_ENABLED ? (Config.SPLASH_ENABLED && Release.NAME != Release.LOCAL ? new SplashState : new TitleState) : new GameState);
			}
		}
	}
}
