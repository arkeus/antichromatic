package io.arkeus.antichromatic.game.entity.enemy {
	import io.arkeus.antichromatic.assets.Resource;

	public class Spike extends HueEnemy {
		public function Spike(hue:uint, x:uint, y:uint, dir:uint) {
			super(hue, x, y, Resource.SPIKE, 12, 12);
			
			height = 6;
			
			var frame:uint = 0;
			switch (dir) {
				case DOWN: frame += 3; height = 6; break;
				case RIGHT: frame += 6; width = 6; break;
				case LEFT: frame += 9; width = 6; offset.x = 6; break;
				case UP: height = 6; offset.y = 6; break;
			}
			if (hue == WHITE) {
				frame += 1;
			} else if (hue == COLOR) {
				frame += 2;
			}
			show(frame);
		}
	}
}
