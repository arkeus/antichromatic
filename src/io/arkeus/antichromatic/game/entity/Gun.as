package io.arkeus.antichromatic.game.entity {
	import io.arkeus.antichromatic.assets.Resource;
	
	import org.axgl.render.AxBlendMode;

	public class Gun extends Entity {
		public static const DELAY:Number = 0.05;
		
		public static const UP:uint = 0;
		public static const RIGHT:uint = 1;
		public static const DOWN:uint = 2;
		
		private var dir:uint = 0;
		private var hue:uint = BLACK;
		
		public function Gun(x:uint, y:uint) {
			super(x, y, Resource.GUN_BLACK_RIGHT, Player.FRAME_WIDTH, Player.FRAME_HEIGHT);
			resize();
			blend = AxBlendMode.TRANSPARENT_TEXTURE;
		}
		
		public function resize():void {
			width = 10;
			offset.x = 5;
			height = 17;
			offset.y = 8;
			origin.x = frameWidth / 2;
			origin.y = frameHeight / 2;
		}
		
		public function changeColor(hue:uint):void {
			this.hue = hue;
			reload();
		}
		
		private function reload():void {
			load(getGunSprite(hue, dir), Player.FRAME_WIDTH, Player.FRAME_HEIGHT);
		}
		
		public function setDirection(dir:uint):void {
			if (dir != this.dir) {
				this.dir = dir;
				reload();
			}	
		}
		
		public function getGunSprite(hue:uint, dir:uint):Class {
			if (hue == WHITE) {
				switch (dir) {
					case UP: return Resource.GUN_WHITE_UP; break;
					case RIGHT: return Resource.GUN_WHITE_RIGHT; break;
					case DOWN: return Resource.GUN_WHITE_DOWN; break;
				}
			} else {
				switch (dir) {
					case UP: return Resource.GUN_BLACK_UP; break;
					case RIGHT: return Resource.GUN_BLACK_RIGHT; break;
					case DOWN: return Resource.GUN_BLACK_DOWN; break;
				}
			}
			return null;
		}
	}
}
