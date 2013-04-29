package io.arkeus.antichromatic.game.world {
	import flash.geom.Rectangle;
	
	import io.arkeus.antichromatic.assets.Particle;
	import io.arkeus.antichromatic.assets.Sound;
	import io.arkeus.antichromatic.game.entity.Bullet;
	import io.arkeus.antichromatic.game.entity.Entity;
	import io.arkeus.antichromatic.game.entity.Player;
	import io.arkeus.antichromatic.util.Item;
	import io.arkeus.antichromatic.util.Registry;
	
	import org.axgl.AxEntity;
	import org.axgl.AxU;
	import org.axgl.particle.AxParticleSystem;
	import org.axgl.tilemap.AxTile;
	import org.axgl.tilemap.AxTilemap;

	public class World extends AxTilemap {
		public static const INITIAL_COLOR:uint = Entity.BLACK;
		public static const GRAVITY:Number = 800;
		
		public var room:Rectangle;
		
		public function World(x:uint = 0, y:uint = 0) {
			super(x, y);
		}
		
		public function initialize(hue:uint):void {
			adjustFromColor(hue);
			initializeCallbacks();
			initilizeCollision();
		}
		
		override public function update():void {
			swapBackgroundTile(2);
			super.update();
		}

		private function swapBackgroundTile(count:uint):void {
			for (var i:uint = 0; i < count; i++) {
				var tx:uint = AxU.rand(0, cols - 1), ty:uint = AxU.rand(0, rows - 1);
				var tile:AxTile = getTileAt(tx, ty);
				if (tile.index < 10) {
					setTileAt(tx, ty, AxU.rand(1, 8));
				} else if (tile.index < 20) {
					setTileAt(tx, ty, AxU.rand(11, 18));
				}
			}
		}

		public function adjustFromColor(hue:uint):void {
			if (hue == Entity.WHITE) {
				getTile(41).collision = NONE;
				getTile(42).collision = ANY;
			} else {
				getTile(41).collision = ANY;
				getTile(42).collision = NONE;
			}
		}
		
		private function initializeCallbacks():void {
			// Black crates
			getTile(70).callback = function(tile:AxTile, entity:AxEntity):void {
				if (!(entity is Bullet) || !((entity as Bullet).hue != Entity.WHITE)) { return; }
				setTileAt(tile.x / Tile.SIZE, tile.y / Tile.SIZE, AxU.rand(1, 8));
				AxParticleSystem.emit(Particle.BLACK_CRATE, tile.x, tile.y);
				Sound.play("crate");
			};
			// White crates
			getTile(60).callback = function(tile:AxTile, entity:AxEntity):void {
				if (!(entity is Bullet) || !((entity as Bullet).hue != Entity.BLACK)) { return; }
				setTileAt(tile.x / Tile.SIZE, tile.y / Tile.SIZE, AxU.rand(1, 8));
				AxParticleSystem.emit(Particle.WHITE_CRATE, tile.x, tile.y);
				Sound.play("crate");
			};
			
			// RED
			getTile(57).callback = function(tile:AxTile, entity:AxEntity):void {
				if (!(entity is Bullet) || !Registry.hasItem(Item.CRIMSON_SHARD)) { return; }
				setTileAt(tile.x / Tile.SIZE, tile.y / Tile.SIZE, AxU.rand(1, 8));
				AxParticleSystem.emit(Particle.RED, tile.x, tile.y);
				Sound.play("crate");
			};
			// GREEN
			getTile(67).callback = function(tile:AxTile, entity:AxEntity):void {
				if (!(entity is Bullet) || !Registry.hasItem(Item.EMERALD_SHARD)) { return; }
				setTileAt(tile.x / Tile.SIZE, tile.y / Tile.SIZE, AxU.rand(1, 8));
				AxParticleSystem.emit(Particle.GREEN, tile.x, tile.y);
				Sound.play("crate");
			};
			// BLUE
			getTile(77).callback = function(tile:AxTile, entity:AxEntity):void {
				if (!(entity is Bullet) || !Registry.hasItem(Item.AZURE_SHARD)) { return; }
				setTileAt(tile.x / Tile.SIZE, tile.y / Tile.SIZE, AxU.rand(1, 8));
				AxParticleSystem.emit(Particle.BLUE, tile.x, tile.y);
				Sound.play("crate");
			};
		}
		
		private function initilizeCollision():void {
			for (var i:uint = 10; i <= 19; i++) {
				getTile(i).callback = function(tile:AxTile, entity:AxEntity):void {
					if (entity is Player && !Registry.game.frozen) {
						entity.y = entity.previous.y = entity.y + 30;
					}
				};
			}
			
			getTile(31).collision = UP;
			getTile(32).collision = RIGHT;
			getTile(33).collision = DOWN;
			getTile(34).collision = LEFT;
			getTile(31).oneWay = true;
			getTile(32).oneWay = true;
			getTile(33).oneWay = true;
			getTile(34).oneWay = true;
		}

		private static const MAP_UNKNOWN_COLOR:uint = 0x282828;
		private static const MAP_KNOWN_COLOR:uint = 0xaeaeae;
		public function updateMap():void {
			var mx:uint = room.x / 30 * 9 + 1;
			var my:uint = room.y / 25 * 9 + 1;
			var mw:uint = room.width / 30 * 8 + Math.floor(room.width / 31);
			var mh:uint = room.height / 25 * 8 + Math.floor(room.height / 26);
			for (var x:uint = mx; x < mx + mw; x++) {
				for (var y:uint = my; y < my + mh; y++) {
					Registry.map.setPixel(x, y, MAP_KNOWN_COLOR);
				}
			}
		}
	}
}
