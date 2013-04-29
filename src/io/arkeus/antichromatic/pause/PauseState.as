package io.arkeus.antichromatic.pause {
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.game.GameState;
	import io.arkeus.antichromatic.game.world.Tile;
	import io.arkeus.antichromatic.util.Item;
	import io.arkeus.antichromatic.util.Registry;
	
	import org.axgl.Ax;
	import org.axgl.AxSprite;
	import org.axgl.AxState;
	import org.axgl.input.AxKey;
	import org.axgl.text.AxText;

	public class PauseState extends AxState {
		public var frame:AxSprite;
		public var map:AxSprite;
		
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
			
			this.add(map = new AxSprite(211, 136));
			map.load(Registry.map);
			addMapTarget();
			
			var bg:AxSprite = new AxSprite(50, Ax.viewHeight - 77);
			bg.create(260, 13, 0xaa000000);
			this.add(bg);
			
			var mute:AxText = new AxText(55, Ax.viewHeight - 75, null, "PRESS @[ffcccc]M@[] TO MUTE", 250, "left");
			mute.alpha = 0.8;
			this.add(mute);
			
			var quality:AxText = new AxText(61, Ax.viewHeight - 75, null, "PRESS @[ffcccc]L@[] FOR LOW QUALITY", 250, "right");
			quality.alpha = 0.8;
			this.add(quality);
			
			Ax.keys.releaseAll();
		}
		
		private function addItemName(item:int, x:uint, y:uint, index:uint):void {
			var itemName:AxSprite = new AxSprite(x, y, Resource.TEXTS, 100, 5);
			if (item > -1 && !Registry.hasItem(item)) {
				itemName.alpha = 0.5;
				index = 6;
			}
			itemName.show(index);
			this.add(itemName);
		}
		
		private function addItem(itemId:uint, x:uint, y:uint):void {
			var item:AxSprite = new AxSprite(x, y, Resource.ITEMS, 8, 8);
			if (!Registry.hasItem(itemId)) {
				item.alpha = 0.2;
			}
			item.show(itemId);
			this.add(item);
		}
		
		override public function update():void {
			if (Ax.keys.pressed(AxKey.ANY)) {
				Ax.popState();
				Ax.keys.releaseAll();
			}
			
			GameState.handleCommonLogic();
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
	}
}
