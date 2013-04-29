package io.arkeus.antichromatic.game.entity.enemy {
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.assets.Sound;
	import io.arkeus.antichromatic.util.Registry;
	
	import org.axgl.Ax;

	public class Cannon extends HueEnemy {
		private static const RECHARGE_DELAY:Number = 0.8;
		
		public var recharge:Number = RECHARGE_DELAY;
		public var dir:uint;
		
		public function Cannon(hue:uint, x:uint, y:uint, dir:uint) {
			super(hue, x, y, Resource.CANNON, 12, 12);
			this.dir = dir;
			
			var frame:uint = 0;
			switch (dir) {
				case RIGHT: frame += 0; break;
				case DOWN: frame += 1; break;
				case LEFT: frame += 2; break;
				case UP: frame += 3; break;
			}
			if (hue == BLACK) {
				frame += 4;
			}
			show(frame);
			
			harmful = false;
		}
		
		override public function update():void {
			recharge -= Ax.dt;
			if (recharge < RECHARGE_DELAY) {
				recharge += RECHARGE_DELAY;
				var dx:Number, dy:Number;
				switch (dir) {
					case RIGHT: dx = 1; dy = 0; break;
					case DOWN: dx = 0; dy = 1; break;
					case LEFT: dx = -1; dy = 0; break;
					case UP: dx = 0; dy = -1; break;
				}
				Sound.play("shoot");
				Registry.game.objects.add(new Ring(hue, x, y, dx, dy));
			}
			
			super.update();
		}
	}
}
