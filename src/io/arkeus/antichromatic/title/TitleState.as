package io.arkeus.antichromatic.title {
	import io.arkeus.antichromatic.assets.Particle;
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.assets.Sound;
	import io.arkeus.antichromatic.game.GameState;
	import io.arkeus.antichromatic.game.world.Tile;
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

	public class TitleState extends AxState {
		private var background:AxSprite;
		private var foreground:AxSprite;
		private var logo:AxSprite;
		private var logoColor:AxSprite;
		private var complete:Boolean = false;
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
			
			this.add(buttons = new AxGroup);
			buttons.add(new AxButton(67, 156, Resource.BUTTON, 107, 24).text("New Game", null, 7, 3).onClick(newGame));
			buttons.add(new AxButton(186, 156, Resource.BUTTON, 107, 24).text("Continue", null, 7, 3).onClick(continueGame));
			buttons.add(new AxButton(67, 192, Resource.BUTTON, 107, 24).text("Credits", null, 7, 3).onClick(credits));
			buttons.add(new AxButton(186, 192, Resource.BUTTON, 107, 24).text("Options", null, 7, 3).onClick(options));
			
			addTimer(0.1, emitTile, 0);
			
			persistantUpdate = true;
			Registry.game = null;
		}
		
		override public function update():void {
			GameState.handleCommonLogic();
			
			logoColor.alpha = Math.sin(Ax.now / 500) * 0.5;
			
			super.update();
		}
		
		private function newGame():void {
			if (complete) {
				return;
			}
			// push state with difficulty selection
			continueGame(false, true);
			complete = true;
		}
		
		private function continueGame(loadGame:Boolean = true, eraseGame:Boolean = false):void {
			if (complete) {
				return;
			}
			
			Ax.camera.fadeOut(0.5, 0xff000000, function():void {
				if (eraseGame) {
					Registry.erase();
				}
				if (loadGame) {
					Registry.load();
				}
				Sound.play("start");
				Ax.switchState(new GameState);
				Ax.camera.fadeIn(0.5);
			});
			complete = true;
		}
		
		private function credits():void {
			if (complete) {
				return;
			}
			// push state with credits
			complete = true;
		}
		
		private function options():void {
			if (complete) {
				return;
			}
			// push state with options
			complete = true;
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
			buttons.visible = false;
		}
		
		override public function onResume(sourceState:Class):void {
			buttons.visible = true;
		}
	}
}
