package io.arkeus.antichromatic.game.entity.enemy {
	import io.arkeus.antichromatic.assets.Particle;
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.assets.Sound;
	import io.arkeus.antichromatic.game.entity.Player;
	import io.arkeus.antichromatic.title.TitleState;
	import io.arkeus.antichromatic.util.Config;
	import io.arkeus.antichromatic.util.Registry;
	
	import org.axgl.Ax;
	import org.axgl.particle.AxParticleSystem;
	import org.axgl.plus.message.AxMessage;
	import org.axgl.render.AxBlendMode;

	public class Boss extends HueEnemy {
		private static const BASE_HP:uint = 50;
		private static const SPEED:uint = 70;
		private static const RECHARGE_DELAY:Number = 1.2;
		
		public var recharge:Number = RECHARGE_DELAY;
		public var phase:uint = 0;
		public var crystalsRemaining:int = 3;
		
		public function Boss(x:uint, y:uint) {
			super(COLOR, x, y - 5, Resource.BOSS, Player.FRAME_WIDTH, Player.FRAME_HEIGHT);
			resize();
			
			killable = true;
			harmful = true;
			hp = BASE_HP;
			deathSound = "enemy-die";
			
			velocity.x = SPEED;
			
			addAnimation("stand", [0, 1], 4);
			addAnimation("walk", [5, 6, 7, 8], 12);
			animate("walk");
		}
		
		override public function update():void {
			if (shielded) {
				if (touching & RIGHT) {
					velocity.x = -SPEED;
				} else if (touching & LEFT || velocity.x == 0) {
					velocity.x = SPEED;
				}
			} else {
				if (center.x < Registry.player.center.x) {
					velocity.x = SPEED;
				} else {
					velocity.x = -SPEED;
				}
				
				if (Math.abs(center.x - Registry.player.center.x) < 100) {
					velocity.x *= 0.5;
				}
				
				recharge -= Ax.dt;
				if (recharge < RECHARGE_DELAY) {
					recharge += RECHARGE_DELAY;
					var dx:Number = facing == LEFT ? -1.5 : 1.5, dy:Number = 0;
					Sound.play("shoot");
					Registry.game.objects.add(new Ring(Registry.player.hue, x, y, dx, dy));
				}
			}
			
			facing = velocity.x >= 0 ? RIGHT : LEFT;
			
			alpha = shielded ? 0.4 : 1;
			killable = harmful = !shielded;
			blend = shielded ? AxBlendMode.BLEND : AxBlendMode.TRANSPARENT_TEXTURE;
			
			if (phase < livePhase) {
				phase = livePhase;
				phaseChange(phase);
			}
			
			super.update();
		}
		
		private function get shielded():Boolean {
			return crystalsRemaining > 0;
		}
		
		private function spawnCrystal(hue:uint, x:uint, y:uint):void {
			Registry.game.objects.add(new Crystal(hue, x, y, this));
		}
		
		private function phaseChange(phase:uint):void {
			if (phase == 1) {
				spawnCrystal(BLACK, 9 * 12, 28 * 12);
				spawnCrystal(WHITE, 52 * 12, 28 * 12);
				spawnCrystal(COLOR, 43 * 12, 14 * 12);
			}
		}
		
		private function resize():void {
			width = 10;
			offset.x = 5;
			height = 17;
			offset.y = 8;
			origin.x = frameWidth / 2;
			origin.y = frameHeight / 2;
		}
		
		public function get livePhase():uint {
			if (hp > BASE_HP * 0.8) {
				return 1;
			} else if (hp > BASE_HP * 0.6) {
				return 2;
			} else if (hp > BASE_HP * 0.4) {
				return 3;
			} else {
				return 4;
			} 
		}
		
		override public function destroy():void {
			Registry.player.invincible = true;
			AxParticleSystem.emit(Particle.RAINBOW, center.x, center.y);
			
			var m:uint = Math.floor(Registry.time / 60);
			var s:uint = Math.floor(Registry.time % 60);
			var text:String = (m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s;
			Registry.game.addTimer(4, function():void {
				AxMessage.show("Antichromatic Complete.\nTotal Time: @[bfa747]" + text + "@[]\nTotal Deaths: @[bfa747]" + Registry.deaths + "@[]\nTotal Color Swaps: @[bfa747]" + Registry.swaps + "@[]\n\nTo be continued...", Config.MESSAGE_OPTIONS);
				Registry.game.addTimer(0.5, function():void {
					Ax.camera.fadeOut(0.5, 0xff000000, function():void {
						Ax.switchState(new TitleState);
						Ax.camera.fadeIn(0.5);
					});
				});
			});
			
			super.destroy();
		}
	}
}
