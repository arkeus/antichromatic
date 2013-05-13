package io.arkeus.antichromatic.title {
	import io.arkeus.antichromatic.assets.Particle;
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.assets.Sound;
	import io.arkeus.antichromatic.game.GameState;
	import io.arkeus.antichromatic.game.world.Tile;
	import io.arkeus.antichromatic.pause.PauseState;
	import io.arkeus.antichromatic.scene.IntroState;
	import io.arkeus.antichromatic.util.Registry;
	
	import org.axgl.Ax;
	import org.axgl.AxButton;
	import org.axgl.AxGroup;
	import org.axgl.AxSprite;
	import org.axgl.AxState;
	import org.axgl.AxU;
	import org.axgl.input.AxKey;
	import org.axgl.particle.AxParticleSystem;
	import org.axgl.render.AxBlendMode;
	import org.axgl.util.AxPauseState;

	public class TitleState extends AxState {
		private var background:AxSprite;
		private var foreground:AxSprite;
		private var logo:AxSprite;
		private var logoColor:AxSprite;
		private var buttons:AxGroup;
		
		public function TitleState() {
			Registry.playMusic(TitleMusic);
		}
		
		override public function create():void {
			noScroll();
			
			this.add(background = new AxSprite(0, 0, Resource.TITLE_BACKGROUND));
			this.add(Particle.initialize(), false, false);
			
			this.add(logoColor = new AxSprite(0, 0, Resource.TITLE_LOGO_COLOR));
			logoColor.blend = AxBlendMode.TRANSPARENT_TEXTURE;
			logoColor.origin.x = Ax.viewWidth / 2;
			logoColor.origin.y = 86;
			this.add(logo = new AxSprite(0, 0, Resource.TITLE_LOGO));
			//logoColor.visible = false;
			
			logoColorGrow();
			logoColorFadeOut();
			
			this.add(foreground = new AxSprite(0, 0, Resource.TITLE_FOREGROUND));
			
			var continueButton:AxButton;
			this.add(buttons = new AxGroup);
			buttons.add(new AxButton(67, 144, Resource.BUTTON, 107, 24).text("New Game", null, 7, 3).onClick(newGame));
			buttons.add(continueButton = new AxButton(186, 144, Resource.BUTTON, 107, 24).text("Continue", null, 7, 3).onClick(Registry.hasSave() ? continueGame : null));
			buttons.add(new AxButton(67, 180, Resource.BUTTON, 107, 24).text("Credits", null, 7, 3).onClick(credits));
			buttons.add(new AxButton(186, 180, Resource.BUTTON, 107, 24).text("Options", null, 7, 3).onClick(options));
			buttons.add(new AxButton(127, 216, Resource.BUTTON, 107, 24).text("Best Times", null, 7, 3).onClick(times));
			
			if (!Registry.hasSave()) {
				continueButton.color.hex = 0xffff0000;
			}
			
			addTimer(0.1, emitTile, 0);
			
			persistantUpdate = true;
			Registry.game = null;
			Ax.camera.reset();
		}
		
		override public function update():void {
			logoColor.alpha = Math.sin(Ax.now / 500) * 0.5;
			
			if (Ax.keys.pressed(AxKey.M)) {
				Ax.switchState(new IntroState);
			}
			
			super.update();
		}
		
		private function newGame():void {
			if (Registry.loading) {
				return;
			}
			// push state with difficulty selection
			Ax.pushState(new NewGameState);
			Ax.keys.releaseAll();
			Ax.mouse.releaseAll();
			//continueGame(false, true);
		}
		
		private function continueGame():void {
			if (Registry.loading) {
				return;
			}
			
			Ax.camera.fadeOut(0.5, 0xff000000, function():void {
				Registry.load();
				Sound.play("start");
				Ax.switchState(new GameState);
				Ax.camera.fadeIn(0.5, function():void { Registry.loading = false; });
				Ax.keys.releaseAll();
				Ax.mouse.releaseAll();
			});
			Registry.loading = true;
		}
		
		private function credits():void {
			if (Registry.loading) {
				return;
			}
			// push state with credits
			Ax.pushState(new CreditsState);
			Ax.keys.releaseAll();
			Ax.mouse.releaseAll();
		}
		
		private function options():void {
			if (Registry.loading) {
				return;
			}
			// push state with options
			Ax.pushState(new OptionsState);
			Ax.keys.releaseAll();
			Ax.mouse.releaseAll();
		}
		
		private function times():void {
			if (Registry.loading) {
				return;
			}
			// push state with options
			Ax.pushState(new TimesState);
			Ax.keys.releaseAll();
			Ax.mouse.releaseAll();
		}
		
		private function logoColorGrow():void {
			logoColor.grow(2, 1.05, 1.2, logoColorShrink);
		}
		
		private function logoColorShrink():void {
			logoColor.grow(2, 0.9, 0.8, logoColorGrow);	
		}
		
		private function logoColorFadeOut():void {
			logoColor.fadeOut(1.7, 0, logoColorFadeIn);
		}
		
		private function logoColorFadeIn():void {
			logoColor.fadeIn(1.7, 1, logoColorFadeOut);
		}
		
		private function emitTile():void {
			var tx:uint = AxU.rand(0, 29) * Tile.SIZE;
			var ty:uint = AxU.rand(0, 24) * Tile.SIZE;
			AxParticleSystem.emit(Particle.TILE, tx, ty);
		}
		
		override public function onPause(sourceState:Class):void {
			if (sourceState == AxPauseState) {
				return;
			}
			buttons.visible = buttons.active = buttons.exists = false;
		}
		
		override public function onResume(sourceState:Class):void {
			buttons.visible = buttons.active = buttons.exists = true;
			if (sourceState != PauseState) {
				Registry.loading = false;
			}
		}
	}
}
