package io.arkeus.antichromatic.game.entity.enemy {
	import io.arkeus.antichromatic.assets.Sound;
	import io.arkeus.antichromatic.game.entity.Entity;
	import io.arkeus.antichromatic.util.Registry;
	
	import org.axgl.render.AxBlendMode;

	public class HueEnemy extends Entity {
		public var deathSound:String;
		
		public function HueEnemy(hue:uint, x:Number = 0, y:Number = 0, graphic:Class = null, frameWidth:uint = 0, frameHeight:uint = 0) {
			super(x, y, graphic, frameWidth, frameHeight);
			this.hue = hue;
		}
		
		override public function update():void {
			if (!(this is Boss)) {
				if (hue == Registry.player.hue || hue == COLOR) {
					alpha = hurt ? 0.5 : 1;
					blend = AxBlendMode.TRANSPARENT_TEXTURE;
				} else {
					alpha = 0.2;
					blend = AxBlendMode.BLEND;
				}
			}
			
			super.update();
		}
		
		override public function destroy():void {
			if (deathSound != null) {
				Sound.play(deathSound);
			}
			super.destroy();
		}
	}
}
