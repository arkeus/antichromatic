package io.arkeus.antichromatic.game.entity.enemy {
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.assets.Sound;

	public class Blade extends HueEnemy {
		protected static const HORIZONTAL:uint = 0;
		protected static const VERTICAL:uint = 1;
		
		private static const SPEED:uint = 200;
		
		public function Blade(hue:uint, x:uint, y:uint, dir:uint) {
			super(hue, x, y, Resource.BLADE, 12, 12);
			show(hue);
			
			velocity.x = dir == HORIZONTAL ? SPEED : 0;
			velocity.y = dir == VERTICAL ? SPEED : 0;
			velocity.a = 500;
		}
		
		override public function update():void {
			if (touching & LEFT) {
				velocity.x = SPEED;
				Sound.play("ding-high");
			} else if (touching & RIGHT) {
				velocity.x = -SPEED;
				Sound.play("ding-low");
			}
			
			if (touching & DOWN) {
				velocity.y = -SPEED;
				Sound.play("ding-high");
			} else if (touching & UP) {
				velocity.y = SPEED;
				Sound.play("ding-low");
			}
			
			super.update();
		}
	}
}
