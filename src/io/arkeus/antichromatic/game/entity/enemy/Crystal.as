package io.arkeus.antichromatic.game.entity.enemy {
	import io.arkeus.antichromatic.assets.Particle;
	import io.arkeus.antichromatic.assets.Resource;
	
	import org.axgl.Ax;
	import org.axgl.input.AxKey;
	import org.axgl.particle.AxParticleSystem;

	public class Crystal extends HueEnemy {
		private static const SPEED:uint = 120;
		
		public var boss:Boss;
		
		public function Crystal(hue:uint, x:uint, y:uint, boss:Boss) {
			super(hue, x, y, Resource.CRYSTALS, 22, 22);
			this.boss = boss;
			
			switch (hue) {
				case BLACK:
					show(0);
					break;
				case WHITE:
					show(1);
					break;
				case COLOR:
					show(2);
					break;
			}
			
			width = 12;
			height = 17;
			offset.x = offset.y = 5;
			
			hp = hue == COLOR ? 100 : 40;
			velocity.x = SPEED;
			
			killable = true;
			harmful = true;
			deathSound = "enemy-die";
		}
		
		override public function update():void {
			if (touching & RIGHT) {
				velocity.x = -SPEED;
			} else if (touching & LEFT) {
				velocity.x = SPEED;
			}
			
			if (Ax.keys.pressed(AxKey.E)) {
				//destroy();
			}
			
			super.update();
		}
		
		override public function destroy():void {
			boss.crystalsRemaining--;
			AxParticleSystem.emit(Particle.EXPLOSION, center.x, center.y);
			super.destroy();
		}
	}
}
