package io.arkeus.antichromatic.sponsor {
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.axgl.Ax;
	import org.axgl.AxSprite;
	import org.axgl.AxU;
	import org.axgl.render.AxBlendMode;

	public class SponsorSprite extends AxSprite {
		private var url:String;
		
		public function SponsorSprite(x:uint, y:uint, graphic:Class, url:String, scales:Boolean = false, dimensions:Rectangle = null) {
			super(x, y, graphic);
			Ax.stage2D.addEventListener(MouseEvent.CLICK, click);
			this.url = url;
			this.zooms = scales;
			blend = AxBlendMode.TRANSPARENT_TEXTURE;
			
			if (dimensions) {
				offset.x = dimensions.x;
				offset.y = dimensions.y;
				width = dimensions.width;
				height = dimensions.height;
			}
		}
		
		override public function update():void {
			if (hover()) {
				alpha = 0.9;
			} else {
				alpha = 1;
			}
			super.update();
		}
		
		override public function contains(x:Number, y:Number):Boolean {
			var multiplier:Number = zooms ? 1 : Ax.zoom;
			return super.contains(x * multiplier, y * multiplier);
		}
		
		private function click(event:MouseEvent):void {
			if (hover()) {
				AxU.openURL(url);
			}
		}
		
		override public function dispose():void {
			Ax.stage2D.removeEventListener(MouseEvent.CLICK, click);
			super.dispose();
		}
	}
}
