package io.arkeus.antichromatic.game.entity.enemy {
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.assets.Sound;
	import io.arkeus.antichromatic.game.world.Tile;
	import io.arkeus.antichromatic.util.Registry;

	public class Blade extends HueEnemy {
		protected static const HORIZONTAL:uint = 0;
		protected static const VERTICAL:uint = 1;
		
		private static const SPEED:uint = 200;
		private static const PADDING:uint = 2;
		
		public function Blade(hue:uint, x:uint, y:uint, dir:uint) {
			super(hue, x + PADDING, y + PADDING, Resource.BLADE, 12, 12);
			show(hue);
			
			velocity.x = dir == HORIZONTAL ? SPEED : 0;
			velocity.y = dir == VERTICAL ? SPEED : 0;
			velocity.a = 500;
			
			width = height = 12 - PADDING * 2;
			offset.x = offset.y = PADDING;
		}
		
		override public function update():void {
			if (touching & LEFT) {
				velocity.x = SPEED;
				play("ding-high");
			} else if (touching & RIGHT) {
				velocity.x = -SPEED;
				play("ding-low");
			}
			
			if (touching & DOWN) {
				velocity.y = -SPEED;
				play("ding-high");
			} else if (touching & UP) {
				velocity.y = SPEED;
				play("ding-low");
			}
			
			super.update();
		}
		
		private static const SOUND_DISTANCE_THRESHOLD:uint = 5;
		private function play(name:String):void {
			if (Math.abs(center.x - Registry.player.center.x) > SOUND_DISTANCE_THRESHOLD * Tile.SIZE || Math.abs(center.y - Registry.player.center.y) > SOUND_DISTANCE_THRESHOLD * Tile.SIZE) {
				return;
			}
			Sound.play(name);
		}
	}
}
