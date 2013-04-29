package io.arkeus.antichromatic.game.entity.enemy {
	import io.arkeus.antichromatic.assets.Particle;
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.assets.Sound;
	import io.arkeus.antichromatic.util.Config;
	import io.arkeus.antichromatic.util.Item;
	import io.arkeus.antichromatic.util.Registry;
	
	import org.axgl.AxSprite;
	import org.axgl.particle.AxParticleSystem;
	import org.axgl.plus.message.AxMessage;

	public class Container extends HueEnemy {
		private var itemId:uint;
		private var item:AxSprite;
		
		public function Container(x:uint, y:uint, itemId:uint) {
			super(COLOR, x, y, Resource.CONTAINER, 14, 20);
			this.itemId = itemId;
			
			width = 12;
			offset.x = 1;
			height = 12;
			offset.y = 8;
			
			this.item = new AxSprite(this.x + 2, this.y - 2, Resource.ITEMS, 8, 8);
			this.item.show(itemId);
			
			killable = false;
			harmful = false;
			
			if (Registry.hasItem(itemId)) {
				visible = exists = active = false;
			}
		}
		
		override public function update():void {
			if (overlaps(Registry.player)) {
				Registry.obtainItem(itemId);
				AxParticleSystem.emit(Particle.EXPLOSION, center.x, center.y);
				destroy();
				Sound.play("collect");
				AxMessage.show(Item.MESSAGES[itemId], Config.MESSAGE_OPTIONS);
			}
			
			item.update();
			super.update();
		}
		
		override public function draw():void {
			item.draw();
			super.draw();
		}
	}
}
