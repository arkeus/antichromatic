package io.arkeus.antichromatic.game.entity {
	import io.arkeus.antichromatic.assets.Particle;
	import io.arkeus.antichromatic.assets.Sound;
	
	import org.axgl.AxSprite;
	import org.axgl.particle.AxParticleSystem;

	public class Entity extends AxSprite {
		public static const BLACK:uint = 0;
		public static const WHITE:uint = 1;
		public static const COLOR:uint = 2;
		public static const NONE:uint = 4;
		
		public var hue:uint = NONE;
		public var harmful:Boolean = true;
		public var killable:Boolean = false;
		
		public var hp:int = 5;
		
		public function Entity(x:Number = 0, y:Number = 0, graphic:Class = null, frameWidth:uint = 0, frameHeight:uint = 0) {
			super(x, y, graphic, frameWidth, frameHeight);
		}
		
		public function hit(bullet:Bullet):void {
			Sound.play("hit-enemy");
			hp--;
			color.hex = 0xffff5555;
			addTimer(0.1, function():void { color.hex = 0xffffffff; });
			if (hp <= 0) {
				destroy();
			}
		}
	}
}
