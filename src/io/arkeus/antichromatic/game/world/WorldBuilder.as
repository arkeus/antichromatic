package io.arkeus.antichromatic.game.world {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import io.arkeus.antichromatic.game.GameState;
	import io.arkeus.antichromatic.game.entity.Entity;
	import io.arkeus.antichromatic.game.entity.enemy.AlternatingCannon;
	import io.arkeus.antichromatic.game.entity.enemy.Boss;
	import io.arkeus.antichromatic.game.entity.enemy.Cannon;
	import io.arkeus.antichromatic.game.entity.enemy.Container;
	import io.arkeus.antichromatic.game.entity.enemy.HBlade;
	import io.arkeus.antichromatic.game.entity.enemy.Laser;
	import io.arkeus.antichromatic.game.entity.enemy.Snail;
	import io.arkeus.antichromatic.game.entity.enemy.Spike;
	import io.arkeus.antichromatic.game.entity.enemy.Spinner;
	import io.arkeus.antichromatic.game.entity.enemy.Teleport;
	import io.arkeus.antichromatic.game.entity.enemy.VBlade;
	import io.arkeus.antichromatic.util.TransitionProperties;
	
	import org.axgl.Ax;
	import org.axgl.AxEntity;
	import org.axgl.AxGroup;
	import org.axgl.AxPoint;
	import org.axgl.AxU;

	public class WorldBuilder {
		private static const WALL:uint = 0xba00ff;

		public var map:Class;
		public var tiles:Class;
		public var rooms:Class;
		public var entities:AxGroup;

		private var x:uint, y:uint;
		private var roomX:uint, roomY:uint;
		private var roomOffsetX:int, roomOffsetY:int;
		private var room:Rectangle;

		public function WorldBuilder(map:Class, tiles:Class, rooms:Class, roomX:Number, roomY:Number, roomOffsetX:int, roomOffsetY:int) {
			this.map = map;
			this.tiles = tiles;
			this.rooms = rooms;
			this.entities = new AxGroup;
			this.roomX = roomX;
			this.roomY = roomY;
			this.roomOffsetX = roomOffsetX;
			this.roomOffsetY = roomOffsetY;
		}

		public function build(transitionProperties:TransitionProperties):World {
			room = discoverRoom();
			if (room == null) {
				return null;
			}
			var world:World = new World;
			world.build(generateTerrain((new map as Bitmap).bitmapData), tiles, Tile.SIZE, Tile.SIZE, 50);
			world.initialize(transitionProperties == null ? World.INITIAL_COLOR : transitionProperties.hue);
			world.room = room;
			world.updateMap();
			Ax.dt = 0;
			return world;
		}

		private function discoverRoom():Rectangle {
			var roomPixels:BitmapData = (new rooms as Bitmap).bitmapData;
			var rx:int = roomX + roomOffsetX, ry:int = roomY + roomOffsetY;
			trace("Discovering room...", rx, ry);
			var limit:uint = 0;
			while (roomPixels.getPixel(rx, ry) != WALL) {
				limit++;
				if (limit > 1000) {
					Ax.switchState(new GameState(139, 68, 0, 0, null));
					return null;
				}
				rx--;
			}
			while (roomPixels.getPixel(rx + 1, ry) != WALL) {
				limit++;
				if (limit > 1000) {
					Ax.switchState(new GameState(139, 68, 0, 0, null));
					return null;
				}
				ry--;
			}
			var rw:int = 1, rh:int = 1;
			while (roomPixels.getPixel(rx + rw, ry + rh) != WALL) {
				limit++;
				if (limit > 1000) {
					Ax.switchState(new GameState(139, 68, 0, 0, null));
					return null;
				}
				rh++;
			}
			while (roomPixels.getPixel(rx + rw, ry + rh - 1) != WALL) {
				limit++;
				if (limit > 1000) {
					Ax.switchState(new GameState(139, 68, 0, 0, null));
					return null;
				}
				rw++;
			}
			trace("Discovered room:", rx, ry, rw, rh, "Limit:", limit);
			return new Rectangle(rx, ry, rw + 1, rh + 1);
		}

		private function generateTerrain(pixels:BitmapData):Array {
			var data:Array = [];
			for (y = room.y; y < room.y + room.height; y++) {
				var row:Array = [];
				for (x = room.x; x < room.x + room.width; x++) {
					populatePixelData(pixels, x, y);
					row.push(getTile(processObject()));
				}
				data.push(row);
			}
			return data;
		}

		private var teleportMap:Object = {};
		private function processObject():Boolean {
			var px:uint = (x - room.x) * Tile.SIZE;
			var py:uint = (y - room.y) * Tile.SIZE;

			var udDir:uint;
			if (dp == SOLID) {
				udDir = AxEntity.UP;
			} else if (up == SOLID) {
				udDir = AxEntity.DOWN;
			} else if (lp == SOLID) {
				udDir = AxEntity.RIGHT;
			} else if (rp == SOLID) {
				udDir = AxEntity.LEFT;
			}

			var lrDir:uint;
			if (lp == SOLID) {
				lrDir = AxEntity.RIGHT;
			} else if (rp == SOLID) {
				lrDir = AxEntity.LEFT;
			} else if (dp == SOLID) {
				lrDir = AxEntity.UP;
			} else if (up == SOLID) {
				lrDir = AxEntity.DOWN;
			}
			
			// special teleport case
			if ((cp & 0x00ffff) == 0x0000ff || (cp & 0x00ffff) == 0x0000fe) { // black teleport
				var teleportId:uint = (cp & 0xff0000) >> 16;
				var hue:uint = (cp & 0x00ffff) == 0x0000ff ? Entity.BLACK : Entity.WHITE;
				var link:Teleport = teleportMap[teleportId];
				var teleport:Teleport = new Teleport(hue, px, py, link);
				teleportMap[teleportId] = teleport;
				entities.add(teleport);
			}
			
			// special item case
			if ((cp & 0x00ffff) == 0x007eff) {
				var itemId:uint = (cp & 0xff0000) >> 16;
				entities.add(new Container(px, py, itemId));
			}
			
			switch (cp) {
				case WHITE_HBLADE:  {
					entities.add(new HBlade(Entity.WHITE, px, py));
					break;
				}
				case COLOR_HBLADE:  {
					entities.add(new HBlade(Entity.COLOR, px, py));
					break;
				}
				case BLACK_HBLADE:  {
					entities.add(new HBlade(Entity.BLACK, px, py));
					break;
				}
				case WHITE_VBLADE:  {
					entities.add(new VBlade(Entity.WHITE, px, py));
					break;
				}
				case COLOR_VBLADE:  {
					entities.add(new VBlade(Entity.COLOR, px, py));
					break;
				}
				case BLACK_VBLADE:  {
					entities.add(new VBlade(Entity.BLACK, px, py));
					break;
				}
				case WHITE_LASER:  {
					entities.add(new Laser(Entity.WHITE, px, py));
					break;
				}
				case BLACK_LASER:  {
					entities.add(new Laser(Entity.BLACK, px, py));
					break;
				}
				case WHITE_HLASER:  {
					entities.add(new Laser(Entity.WHITE, px, py, true));
					break;
				}
				case BLACK_HLASER:  {
					entities.add(new Laser(Entity.BLACK, px, py, true));
					break;
				}
				case WHITE_SPIKE:
				case BLACK_SPIKE:
				case COLOR_SPIKE:  {
					entities.add(new Spike(cp == COLOR_SPIKE ? Entity.COLOR : cp == WHITE_SPIKE ? Entity.WHITE : Entity.BLACK, px, py, udDir));
					break;
				}
				case WHITE_CANNON:  {
					entities.add(new Cannon(Entity.WHITE, px, py, lrDir));
					break;
				}
				case BLACK_CANNON:  {
					entities.add(new Cannon(Entity.BLACK, px, py, lrDir));
					break;
				}
				case ALTERNATING_CANNON:  {
					entities.add(new AlternatingCannon(px, py, lrDir));
					break;
				}
				case WHITE_SNAIL:  {
					entities.add(new Snail(Entity.WHITE, px, py));
					break;
				}
				case BLACK_SNAIL:  {
					entities.add(new Snail(Entity.BLACK, px, py));
					break;
				}
				case SPINNER:  {
					entities.add(new Spinner(px, py));
					break;
				}
				case BOSS:  {
					entities.add(new Boss(px, py));
					break;
				}
				default:  {
					return false;
					break;
				}
			}
			return true;
		}

		private function getTile(override:Boolean):uint {
			var ix:uint = roomX + roomOffsetX, iy:uint = roomY + roomOffsetY;
			// Non-terrain blocks
			switch (cp) {
				case WHITE_BLOCK:  {
					return 42;
				}
				case BLACK_BLOCK:  {
					return 41;
				}
				case WHITE_CRATE:  {
					if (Math.abs(ix - x) > 3 || Math.abs(iy - y) > 3) {
						return 60;
					}
					break;
				}
				case BLACK_CRATE:  {
					if (Math.abs(ix - x) > 3 || Math.abs(iy - y) > 3) {
						return 70;
					}
					break
				}
				case ONE_WAY_UP:  {
					return 31;
				}
				case ONE_WAY_RIGHT:  {
					return 32;
				}
				case ONE_WAY_DOWN:  {
					return 33;
				}
				case ONE_WAY_LEFT:  {
					return 34;
				}
				case RED:  {
					return 57;
				}
				case GREEN:  {
					return 67;
				}
				case BLUE:  {
					return 77;
				}
			}

			// Autotile Terrain
			if (!c || override) {
				return AxU.rand(1, 9);
			}

			var start:uint = 50, tile:uint = 0;
			if (l && r && u && d) {
				if (!ul) {
					tile = 26;
				} else if (!ur) {
					tile = 24;
				} else if (!dl) {
					tile = 6;
				} else if (!dr) {
					tile = 4;
				} else {
					return AxU.rand(11, 19);
				}
			} else if (l && r && d) {
				tile = 2;
			} else if (u && l && d) {
				tile = 13;
			} else if (u && r && d) {
				tile = 11;
			} else if (l && r && u) {
				tile = 22;
			} else if (r && d) {
				tile = 1;
			} else if (l && d) {
				tile = 3;
			} else if (r && u) {
				tile = 21;
			} else if (l && u) {
				tile = 23;
			}

			return start + tile;
		}

		private var cp:uint, lp:uint, up:uint, dp:uint, rp:uint;
		private var c:Boolean, l:Boolean, u:Boolean, d:Boolean, r:Boolean;
		private var ulp:uint, urp:uint, dlp:uint, drp:uint;
		private var ul:Boolean, ur:Boolean, dl:Boolean, dr:Boolean;

		private function populatePixelData(pixels:BitmapData, x:uint, y:uint):void {
			cp = pixels.getPixel(x, y);
			lp = pixels.getPixel(x - 1, y);
			up = pixels.getPixel(x, y - 1);
			dp = pixels.getPixel(x, y + 1);
			rp = pixels.getPixel(x + 1, y);
			ulp = pixels.getPixel(x - 1, y - 1);
			urp = pixels.getPixel(x + 1, y - 1);
			dlp = pixels.getPixel(x - 1, y + 1);
			drp = pixels.getPixel(x + 1, y + 1);

			c = cp == SOLID;
			l = lp == cp;
			r = rp == cp;
			u = up == cp;
			d = dp == cp;
			ul = ulp == cp;
			ur = urp == cp;
			dl = dlp == cp;
			dr = drp == cp;
		}
		
		public static function getDebugStart(world:Class):AxPoint {
			var px:BitmapData = (new world as Bitmap).bitmapData;
			for (var x:uint = 0; x < px.width; x++) {
				for (var y:uint = 0; y < px.height; y++) {
					if (px.getPixel(x, y) == 0xff9000) {
						return new AxPoint(x, y - (5 / 16));
					}
				}
			}
			
			return new AxPoint(140, 70);
		}

		private static const SOLID:uint = 0x000000;
		private static const WHITE_BLOCK:uint = 0xe4e4e4;
		private static const BLACK_BLOCK:uint = 0x282828;
		
		private static const ONE_WAY_UP:uint = 0x4f5a91;
		private static const ONE_WAY_RIGHT:uint = 0x384278;
		private static const ONE_WAY_DOWN:uint = 0x263163;
		private static const ONE_WAY_LEFT:uint = 0x151e49;

		private static const WHITE_SPIKE:uint = 0xffb1b1;
		private static const BLACK_SPIKE:uint = 0x360000;
		private static const COLOR_SPIKE:uint = 0xd02e2e;

		private static const WHITE_LASER:uint = 0xfffcc9;
		private static const BLACK_LASER:uint = 0x4f4a00;
		private static const WHITE_HLASER:uint = 0xfff880;
		private static const BLACK_HLASER:uint = 0x918800;

		private static const WHITE_HBLADE:uint = 0xe5ffbb;
		private static const BLACK_HBLADE:uint = 0x2d4900;
		private static const COLOR_HBLADE:uint = 0x9eff00;
		private static const WHITE_VBLADE:uint = 0xd2ff8a;
		private static const BLACK_VBLADE:uint = 0x619d00;
		private static const COLOR_VBLADE:uint = 0x98ea12;

		private static const WHITE_CRATE:uint = 0xc79aff;
		private static const BLACK_CRATE:uint = 0x150030;

		private static const WHITE_CANNON:uint = 0xabffe1;
		private static const BLACK_CANNON:uint = 0x00593a;
		private static const ALTERNATING_CANNON:uint = 0xffc663;

		private static const WHITE_SNAIL:uint = 0xa0c4ff;
		private static const BLACK_SNAIL:uint = 0x002a6f;
		
		private static const SPINNER:uint = 0xdb286b;
		
		private static const RED:uint = 0xdd0000;
		private static const GREEN:uint = 0x0add00;
		private static const BLUE:uint = 0x0063dd;
		
		private static const BOSS:uint = 0x00eaff
	}
}
