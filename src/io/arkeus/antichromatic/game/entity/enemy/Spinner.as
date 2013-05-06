package io.arkeus.antichromatic.game.entity.enemy {
	import io.arkeus.antichromatic.assets.Particle;
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.game.entity.Bullet;
	import io.arkeus.antichromatic.util.Difficulty;
	import io.arkeus.antichromatic.util.Registry;
	
	import org.axgl.Ax;
	import org.axgl.AxSprite;
	import org.axgl.AxU;
	import org.axgl.particle.AxParticleSystem;

	public class Spinner extends HueEnemy {
		private static const SWAP_DELAY:Number = 3;
		private static const SHOOT_DELAY:Number = 0.7;
		
		private var turret:AxSprite;
		private var aim:Number = 0;
		
		public function Spinner(x:uint, y:uint) {
			super(AxU.rand(0, 1), x, y, Resource.SPINNER, 22, 22);
			turret = new AxSprite(x, y, Resource.SPINNER, 22, 22);
			
			width = height = turret.width = turret.height = 16;
			offset.x = offset.y = turret.offset.x = turret.offset.y = 3;
			
			swapColor(hue);
			addTimer(SHOOT_DELAY, shoot, 0);
			
			harmful = true;
			killable = true;
			hp = 30;
			deathSound = "enemy-die";
		}
		
		override public function update():void {
			aim = Math.atan2(Registry.player.center.y - center.y, Registry.player.center.x - center.x);
			super.update();
			turret.update();
		}
		
		override public function draw():void {
			super.draw();
			turret.angle = aim * 180 / Math.PI;
			turret.alpha = alpha;
			turret.draw();
		}
		
		private function swap():void {
			swapColor(hue == WHITE ? BLACK : WHITE);
		}
		
		private function swapColor(hue:uint):void {
			this.hue = hue;
			show(hue == BLACK ? 0 : 2);
			turret.show(frame + 1);
			AxParticleSystem.emit(Particle.EXPLOSION, center.x, center.y);
		}
		
		private function shoot():void {
			var dx:Number = Math.cos(aim);
			var dy:Number = Math.sin(aim);
			var ring:Ring = new Ring(Registry.difficulty == Difficulty.NORMAL ? hue : COLOR, center.x - 5, center.y - 5, dx, dy);
			ring.x += ring.velocity.x * Ax.dt * 5;
			ring.y += ring.velocity.y * Ax.dt * 5;
			Registry.game.objects.add(ring);
		}
		
		private var damageTaken:uint = 0;
		override public function hit(bullet:Bullet):void {
			damageTaken++;
			if (damageTaken >= 10) {
				damageTaken -= 10;
				swap();
			}
			super.hit(bullet);
		}
	}
}
