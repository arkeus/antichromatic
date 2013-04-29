package io.arkeus.antichromatic.game.entity {
	import io.arkeus.antichromatic.assets.Particle;
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.assets.Sound;
	
	import org.axgl.Ax;
	import org.axgl.particle.AxParticleSystem;
	import org.axgl.render.AxBlendMode;

	public class Bullet extends Entity {
		private var hideParticles:Boolean = false;
		
		public function Bullet() {
			super();
			blend = AxBlendMode.TRANSPARENT_TEXTURE;
		}
		
		public function shoot(hue:uint, x:Number, y:Number, angle:Number, speed:Number):void {
			if (hue != this.hue) {
				this.hue = hue;
				load(hue == WHITE ? Resource.BULLET_WHITE : Resource.BULLET_BLACK, 6, 6);
				width = height = 2;
				offset.x = offset.y = 2;
			}
			velocity.x = Math.cos(-angle) * speed;
			velocity.y = Math.sin(-angle) * speed;
			this.x = this.previous.x = x + velocity.x * Ax.dt;
			this.y = this.previous.y = y + velocity.y * Ax.dt;
			screen.x = this.x - Ax.camera.x;
			screen.y = this.y - Ax.camera.y;
			Sound.play("shoot");
		}
		
		override public function update():void {
			if (screen.x < -width || screen.x > Ax.viewWidth || screen.y < -height || screen.y > Ax.viewHeight || touching != 0) {
				if (touching == 0) {
					hideParticles = true;
				}
				destroy();
			}
			
			super.update();
		}
		
		override public function destroy():void {
			AxParticleSystem.emit(Particle.BULLET, center.x, center.y);
			hideParticles = false;
			super.destroy();
		}
	}
}
