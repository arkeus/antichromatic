package io.arkeus.antichromatic.game.entity.enemy {
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.util.Item;
	import io.arkeus.antichromatic.util.Registry;
	
	import org.axgl.AxSprite;

	public class Teleport extends HueEnemy {
		public var link:Teleport;
		
		private var badge:AxSprite;
		
		public function Teleport(hue:uint, x:uint, y:uint, link:Teleport) {
			super(hue, x, y, Resource.TELEPORT, 20, 20);
			if (link != null) {
				link.link = this;
				this.link = link;
			}
			
			badge = new AxSprite(this.x, this.y, Resource.TELEPORT, 20, 20);
			
			badge.width = width = 12;
			badge.offset.x = offset.x = 4;
			badge.height = height = 16;
			badge.offset.y = offset.y = 4;
			
			show(hue == WHITE ? 0 : 2);
			badge.show(frame + 1);
			
			maxVelocity.a = 1200;
			drag.a = 1200;
			
			harmful = false;
			killable = false;
		}
		
		override public function update():void {
			if (overlaps(Registry.player) && Registry.hasItem(Item.TELEPORT_BADGE)) {
				if (Registry.player.hue == hue) {
				acceleration.a = 2400;
				} else if (Registry.player.justSwapped) {
					Registry.player.teleport(link.x, link.y);
				}
			} else {
				acceleration.a = 0;
			}
			
			super.update();
			badge.update();
		}
		
		override public function draw():void {
			super.draw();
			badge.alpha = alpha;
			badge.draw();
		}
	}
}
