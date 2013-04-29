package io.arkeus.antichromatic.game.world {
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.util.Registry;
	
	import org.axgl.AxSprite;
	import org.axgl.render.AxBlendMode;

	public class Noise extends AxSprite {
		public function Noise() {
			super(0, 0, Resource.NOISE);
			noScroll();
			
			color.red = color.green = color.blue = 1;
			alpha = 0.2;
			blend = AxBlendMode.FILTER;
			
			addTimer(0.1, function():void { angle += 90; }, 0);
		}
		
		override public function draw():void {
			if (Registry.quality == 0) {
				return;
			}
			super.draw();
		}
	}
}
