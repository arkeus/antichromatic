package io.arkeus.antichromatic.game.entity.enemy {
	import io.arkeus.antichromatic.assets.Particle;
	import io.arkeus.antichromatic.assets.Resource;
	
	import org.axgl.particle.AxParticleSystem;

	public class Ring extends HueEnemy {
		private static const SPEED:Number = 100;
		
		public function Ring(hue:uint, x:uint, y:uint, dx:Number, dy:Number, cannon:Boolean = true) {
			var tx:uint = dx == 0 && cannon ? x + 3 : x;
			var ty:uint = dy == 0 && cannon ? y + 3 : y;
			
			super(hue, tx, ty, Resource.RING, 10, 10);
			width = height = 6;
			offset.x = offset.y = 2;
			velocity.x = dx * SPEED;
			velocity.y = dy * SPEED;
			if (hue == WHITE) {
				show(1);
			} else if (hue == COLOR) {
				show(2);
			}
			
			velocity.a = 500;
			deathSound = "shoot-wall";
		}
		
		override public function update():void {
			if (touching > 0) {
				AxParticleSystem.emit(Particle.BULLET, center.x, center.y);
				destroy();
			}
			
			super.update();
		}
	}
}
