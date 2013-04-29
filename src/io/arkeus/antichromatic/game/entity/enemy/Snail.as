package io.arkeus.antichromatic.game.entity.enemy {
	import io.arkeus.antichromatic.assets.Particle;
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.game.world.World;
	import io.arkeus.antichromatic.util.Registry;
	
	import org.axgl.AxEntity;
	import org.axgl.particle.AxParticleSystem;

	public class Snail extends HueEnemy {
		private static const SPEED:uint = 100;
		
		public function Snail(hue:uint, x:uint, y:uint) {
			super(hue, x, y + 2, Resource.SNAIL, 20, 10);
			addAnimation("walk", hue == BLACK ? [0, 1, 2] : [3, 4, 5], 8);
			animate("walk");
			acceleration.y = World.GRAVITY;
			killable = true;
			width = 16;
			height = 8;
			offset.x = offset.y = 2;
			
			velocity.x = SPEED;
			deathSound = "enemy-die";
		}
		
		override public function update():void {
			if (touching & RIGHT) {
				velocity.x = -SPEED;
			} else if (touching & LEFT) {
				velocity.x = SPEED;
			}
			
			if (velocity.x > 0 && Registry.game.world.getTileAtPixelCoordinates(right, bottom + 2).collision == AxEntity.NONE) {
				velocity.x = -SPEED;
			} else if (velocity.x < 0 && Registry.game.world.getTileAtPixelCoordinates(left, bottom + 2).collision == AxEntity.NONE) {
				velocity.x = SPEED;
			}
			
			facing = velocity.x >= 0 ? RIGHT : LEFT;
			
			super.update();
		}
		
		override public function destroy():void {
			AxParticleSystem.emit(Particle.EXPLOSION, center.x, center.y);
			super.destroy();
		}
	}
}
