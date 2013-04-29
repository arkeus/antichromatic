package io.arkeus.antichromatic.game.entity.enemy {
	import io.arkeus.antichromatic.assets.Resource;

	public class Laser extends HueEnemy {
		private static const PADDING:uint = 0;
		
		public function Laser(hue:uint, x:uint, y:uint, rotate:Boolean = false) {
			super(hue, x + PADDING, y);
			load(hue == WHITE ? Resource.LASER_WHITE : Resource.LASER_BLACK, 12, 12);
			addAnimation("laser", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 24);
			animate("laser");
			
			width = 12 - PADDING * 2;
			offset.x = PADDING;
			
			if (rotate) {
				angle = 90;
			}
		}
	}
}
