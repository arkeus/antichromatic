package io.arkeus.antichromatic.pause {
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.game.GameState;
	import io.arkeus.antichromatic.game.world.Tile;
	import io.arkeus.antichromatic.title.TitleState;
	import io.arkeus.antichromatic.util.Item;
	import io.arkeus.antichromatic.util.Options;
	import io.arkeus.antichromatic.util.Registry;
	
	import org.axgl.Ax;
	import org.axgl.AxButton;
	import org.axgl.AxSprite;
	import org.axgl.AxState;
	import org.axgl.input.AxKey;

	public class PauseState extends AxState {
		public var frame:AxSprite;
		public var map:AxSprite;
		
		private var music:AxButton;
		private var sound:AxButton;
		private var quality:AxButton;
		private var backButton:AxButton;
		
		override public function create():void {
			noScroll();
			
			this.add(frame = new AxSprite(0, 0, Resource.PAUSE));
			addItemName(Item.TELEPORT_BADGE, 64, 116, 0);
			addItemName(Item.WHITE_GUN, 51, 142, 1);
			addItemName(Item.BLACK_GUN, 122, 142, 2);
			addItemName(Item.SUN_BOOTS, 50, 167, 3);
			addItemName(Item.MOON_BOOTS, 121, 175, 4);
			addItemName(-1, 93, 190, 5);
			
			addItem(Item.TELEPORT_BADGE, 52, 113);
			addItem(Item.WHITE_GUN, 38, 139);
			addItem(Item.BLACK_GUN, 167, 139);
			addItem(Item.SUN_BOOTS, 38, 164);
			addItem(Item.MOON_BOOTS, 173, 172);
			addItem(Item.CRIMSON_SHARD, 79, 198);
			addItem(Item.EMERALD_SHARD, 104, 198);
			addItem(Item.AZURE_SHARD, 129, 198);
			
			this.add(map = new AxSprite(211, 86));
			map.load(Registry.map);
			addMapTarget();
			
			this.add(music = new AxButton(67, 176, Resource.BUTTON, 107, 24).text("Music On", null, 7, 3).onClick(toggleMusic));
			this.add(sound = new AxButton(186, 176, Resource.BUTTON, 107, 24).text("Sound On", null, 7, 3).onClick(toggleSound));
			this.add(quality = new AxButton(67, 212, Resource.BUTTON, 107, 24).text("High Quality", null, 7, 3).onClick(toggleQuality));
			this.add(backButton = new AxButton(186, 212, Resource.BUTTON, 107, 24).text("Quit", null, 7, 3).onClick(quit));
			
			Options.updateMusicButton(music);
			Options.updateSoundButton(sound);
			Options.updateQualityButton(quality);
			
			Ax.keys.releaseAll();
		}
		
		private function addItemName(item:int, x:uint, y:uint, index:uint):void {
			var itemName:AxSprite = new AxSprite(x, y - 50, Resource.TEXTS, 100, 5);
			if (item > -1 && !Registry.hasItem(item)) {
				itemName.alpha = 0.5;
				index = 6;
			}
			itemName.show(index);
			this.add(itemName);
		}
		
		private function addItem(itemId:uint, x:uint, y:uint):void {
			var item:AxSprite = new AxSprite(x, y - 50, Resource.ITEMS, 8, 8);
			if (!Registry.hasItem(itemId)) {
				item.alpha = 0.2;
			}
			item.show(itemId);
			this.add(item);
		}
		
		override public function update():void {
			if (Ax.keys.pressed(AxKey.ANY) && !Registry.loading) {
				Ax.popState();
				Ax.keys.releaseAll();
			}
			
			super.update();
		}
		
		private function addMapTarget():void {
			var px:int = Registry.game.world.room.x + Registry.player.x / Tile.SIZE;
			px = px / 30 * 9;
			
			var py:int = Registry.game.world.room.y + Registry.player.y / Tile.SIZE;
			py = py / 25 * 9;
			
			var target:AxSprite = new AxSprite(map.x + px, map.y + py, Resource.MAP_TARGET);
			this.add(target);
		}
		
		private function toggleMusic():void {
			Options.toggleMusic(music);
		}
		
		private function toggleSound():void {
			Options.toggleSound(sound);
		}
		
		private function toggleQuality():void {
			Options.toggleQuality(quality);
		}
		
		private function quit():void {
			if (Registry.loading) {
				return;
			}
			Ax.camera.fadeOut(0.5, 0xff000000, function():void {
				Registry.save();
				Ax.popState();
				Ax.switchState(new TitleState);
				Ax.camera.fadeIn(0.5, function():void { Registry.loading = false; });
				Ax.keys.releaseAll();
				Ax.mouse.releaseAll();
			});
			Registry.loading = true;
		}
	}
}
