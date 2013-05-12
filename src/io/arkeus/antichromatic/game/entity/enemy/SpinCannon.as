package io.arkeus.antichromatic.game.entity.enemy {
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.util.Registry;
	
	import org.axgl.Ax;
	
	public class SpinCannon extends HueEnemy {
		private static const SPIN_SPEED:uint = 90;
		
		private var aim:Number = 0;
		
		public function SpinCannon(hue:uint, x:uint, y:uint) {
			super(hue, x, y, Resource.SPIN_CANNON, 12, 12);
			
			show(hue == BLACK ? 1 : 0);
			//addTimer(SHOOT_DELAY, shoot, 0);
			
			harmful = false;
			killable = false;
			hp = 30;
			deathSound = "enemy-die";
			angle = 45;
			
			velocity.a = SPIN_SPEED;
		}
		
		private var da:Number = 0;
		override public function update():void {
			da += velocity.a * Ax.dt;
			if (da >= 45) {
				angle -= da % 45;
				da = 0;
				velocity.a = 0;
				addTimer(0.1, shoot);
				addTimer(0.2, function():void { velocity.a = SPIN_SPEED; });
			}
			
			super.update();
		}
		
		private function shoot():void {
			for (var a:Number = angle; a < angle + 360; a += 90) {
				var radians:Number = a * Math.PI / 180;
				var dx:Number = Math.cos(radians);
				var dy:Number = Math.sin(radians);
				var ring:Ring = new Ring(hue, center.x - 5, center.y - 5, dx, dy);
				ring.x += ring.velocity.x * Ax.dt * 5;
				ring.y += ring.velocity.y * Ax.dt * 5;
				Registry.game.objects.add(ring);
			}
		}
	}
}
