package io.arkeus.antichromatic.game.entity.enemy {
	import io.arkeus.antichromatic.assets.Resource;

	public class Crate extends HueEnemy {
		public function Crate(hue:uint, x:uint, y:uint) {
			super(hue, x, y, Resource.CRATE, 12, 12);
			show(hue == BLACK ? 0 : 1);
			deathSound = "crate";
			// THIS CLASS ISNT USED DON'T BELIEVE THE LIES
		}
	}
}
