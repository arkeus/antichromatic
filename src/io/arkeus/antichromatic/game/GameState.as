package io.arkeus.antichromatic.game {
	import io.arkeus.antichromatic.assets.Particle;
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.game.entity.Bullet;
	import io.arkeus.antichromatic.game.entity.Entity;
	import io.arkeus.antichromatic.game.entity.Player;
	import io.arkeus.antichromatic.game.world.Tile;
	import io.arkeus.antichromatic.game.world.World;
	import io.arkeus.antichromatic.game.world.WorldBuilder;
	import io.arkeus.antichromatic.game.world.text.WallTextBuilder;
	import io.arkeus.antichromatic.pause.PauseState;
	import io.arkeus.antichromatic.util.Config;
	import io.arkeus.antichromatic.util.Difficulty;
	import io.arkeus.antichromatic.util.HUD;
	import io.arkeus.antichromatic.util.Registry;
	import io.arkeus.antichromatic.util.TransitionProperties;
	
	import org.axgl.Ax;
	import org.axgl.AxEntity;
	import org.axgl.AxGroup;
	import org.axgl.AxPoint;
	import org.axgl.AxRect;
	import org.axgl.AxState;
	import org.axgl.AxVector;
	import org.axgl.collision.AxCollisionGroup;
	import org.axgl.collision.AxGrid;
	import org.axgl.input.AxKey;
	import org.axgl.plus.message.AxMessage;

	public class GameState extends AxState {
		public static var grid:AxCollisionGroup;

		public var world:World;
		public var objects:AxGroup;
		public var player:Player;
		public var bullets:AxGroup;
		public var entities:AxGroup;
		public var harmful:AxGroup;
		public var particles:AxGroup;
		
		public var initialX:Number = 0;
		public var initialY:Number = 0;
		public var roomOffsetX:int = 0;
		public var roomOffsetY:int = 0;
		public var transitionProperties:TransitionProperties;
		
		public var frozen:Boolean = false;
		public var ticking:Boolean = true;
		
		public function GameState() {
			this.initialX = Registry.initialX;
			this.initialY = Registry.initialY;
			this.roomOffsetX = Registry.roomOffsetX;
			this.roomOffsetY = Registry.roomOffsetY;
			this.transitionProperties = Registry.transitionProperties;
			Registry.playMusic(GameplayMusic);
		}

		override public function create():void {
			if (initialX == -1) {
				var debugStart:AxPoint = WorldBuilder.getDebugStart(Resource.WORLD);
				initialX = debugStart.x;
				initialY = debugStart.y;
			}
			
			var tiles:Class = transitionProperties == null || transitionProperties.hue == Entity.BLACK ? Resource.TILES_BLACK : Resource.TILES_WHITE;
			var builder:WorldBuilder = new WorldBuilder(Registry.difficulty == Difficulty.HARD ? Resource.WORLD_HARD : Resource.WORLD, tiles, Resource.ROOMS, initialX, initialY, roomOffsetX, roomOffsetY);
			world = builder.build(transitionProperties);
			if (world == null) {
				return;
			}
			this.add(world);
			
			var wallText:AxGroup = new WallTextBuilder().getTexts(world.room.x, world.room.y);
			if (wallText != null) {
				this.add(wallText);
			}
			
			this.add(builder.entities);
			this.add(objects = new AxGroup);

			this.add(player = new Player((initialX - world.room.x) * Tile.SIZE, (initialY - world.room.y) * Tile.SIZE, transitionProperties));
			this.add(bullets = new AxGroup);
			this.add(particles = Particle.initialize(), false, false);
			this.add(new HUD);

			entities = new AxGroup;
			entities.add(player, false);
			entities.add(bullets, false);
			entities.add(builder.entities, false);
			entities.add(objects, false);
			
			harmful = new AxGroup;
			harmful.add(builder.entities, false);
			harmful.add(objects, false);

			grid = new AxGrid(world.width, world.height);
			
			Ax.camera.bounds = new AxRect(0, 0, world.width, world.height);
			Ax.camera.follow(player);

			Registry.game = this;
			Registry.player = player;
			Ax.dt = 0;
		}

		override public function update():void {
			if (Ax.keys.pressed(AxKey.ESCAPE) || Ax.keys.pressed(AxKey.TAB)) {
				Ax.pushState(new PauseState); 
			}
			
			if (ticking) {
				Registry.time += Ax.adt;
			}
			
			super.update();
			Ax.collide(entities, world, collideWorld);
			Ax.overlap(player, harmful, collideHarmful, grid);
			Ax.overlap(bullets, harmful, shootHarmful, grid);
		}

		private function collideWorld(source:AxEntity, world:World):void {
			// do i need this
		}
		
		private function collideHarmful(player:Player, entity:Entity):void {
			if (entity.harmful && (player.hue == entity.hue || entity.hue == Entity.COLOR)) {
				player.harm();
			}
		}
		
		private function shootHarmful(bullet:Bullet, entity:Entity):void {
			if (entity.killable && (bullet.hue == entity.hue || entity.hue == Entity.COLOR)) {
				entity.hit(bullet);
				bullet.destroy();
			}
		}

		public function teleport(x:Number, y:Number, ox:int = 0, oy:int = 0, transitionProperties:TransitionProperties = null):void {
			if (frozen) {
				return;
			}
			
			frozen = true;
			var targetX:Number = world.room.x + x / Tile.SIZE;
			var targetY:Number = world.room.y + y / Tile.SIZE;
			
			var tp:TransitionProperties = transitionProperties == null ? new TransitionProperties(new AxVector, player.hue, RIGHT) : transitionProperties;
			tp.hue = player.hue;
			Ax.camera.fadeOut(0.25, 0xff000000, function():void {
				Registry.initialX = targetX;
				Registry.initialY = targetY;
				Registry.roomOffsetX = ox;
				Registry.roomOffsetY = oy;
				Registry.transitionProperties = tp;
				
				Registry.save();
				Ax.switchState(new GameState);
				Ax.camera.fadeIn(0.25);
			});
		}
		
		public function respawn():void {
			teleport((initialX - world.room.x) * Tile.SIZE, (initialY - world.room.y) * Tile.SIZE, roomOffsetX, roomOffsetY, transitionProperties);
		}
		
		// hardcoded for time
		private function handleTutorials():void {
			if (!Config.DIALOG_ENABLED) {
				return;
			}
			/*handleTutorial(120, 50, Flag.INTRO, "It's been nearly a year since our world was @[bfa747]fractured@[]. Split in two, we've been trying to restore the world since. We've infiltrated the facility and obtained a suit of @[bfa747]Chromatic Armor@[] in order to pass between the @[bfa747]two fractured dimensions@[], but we have no idea where the source of the fracture is. If we can @[bfa747]destroy the source@[], we believe we can restore the world to it's former glory.", 0.01);
			handleTutorial(120, 50, Flag.MOVE_TUTORIAL, "Use @[bfa747]A (or Q) and D@[] to move, and @[bfa747]W (or Z)@[] to jump. You can also use @[bfa747]R@[] to kill yourself if you get stuck.");
			handleTutorial(150, 25, Flag.SWAP_TUTORIAL, "To swap between the white and black dimension, hit @[bfa747][Space]@[]. Harmful objects in the opposite dimension cannot hurt you.");
			handleTutorial(60, 50, Flag.DOUBLE_TUTORIAL, "Objects that are @[bfa747]both@[] black and white exist in both dimensions, and should be @[bfa747]avoided@[] regardless of which dimension you currently reside in.");
			handleTutorial(0, 0, Flag.BOSS, "Young warrior, you may have stolen my armor and infiltrated my fortress, but I have the shared power between the two dimensions protecting me. You'll never harm me!");*/
		}
		
		private function handleTutorial(roomX:uint, roomY:uint, flag:uint, message:String, delay:Number = 0.5):void {
			if (world.room.x == roomX && world.room.y == roomY && Registry.flags[flag] != 1) {
				addTimer(delay, function():void {
					Registry.flags[flag] = 1;
					AxMessage.show(message, Config.MESSAGE_OPTIONS);
				});
			}
		}
	}
}
