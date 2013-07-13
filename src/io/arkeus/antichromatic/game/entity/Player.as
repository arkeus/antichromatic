package io.arkeus.antichromatic.game.entity {
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.assets.Sound;
	import io.arkeus.antichromatic.game.world.Tile;
	import io.arkeus.antichromatic.game.world.World;
	import io.arkeus.antichromatic.input.Input;
	import io.arkeus.antichromatic.util.Analytics;
	import io.arkeus.antichromatic.util.Config;
	import io.arkeus.antichromatic.util.Item;
	import io.arkeus.antichromatic.util.Registry;
	import io.arkeus.antichromatic.util.TransitionProperties;
	import io.arkeus.ouya.control.JoystickControl;
	
	import org.axgl.Ax;
	import org.axgl.AxVector;
	import org.axgl.input.AxKey;
	import org.axgl.render.AxBlendMode;

	public class Player extends Entity {
		public static const FRAME_WIDTH:uint = 20;
		public static const FRAME_HEIGHT:uint = 30;
		
		public static const SPEED:uint = 140;
		public static const JUMP_SPEED:uint = 300;
		public static const TERMINAL_VELOCITY:uint = 300;
		
		public var gun:Gun;
		public var aim:Number;
		public var jumps:uint = 0;
		
		public var gunRecharge:Number = 0;
		public var frozen:Boolean = false;
		public var invincible:Boolean = false;
		
		public var clutching:Number = 0;
		public var clutchingDirection:uint = 0;
		public var wallJumping:Number = 0;
		public var inputSinceClutch:Boolean = false;
		
		private var mx:Number = 0;
		private var my:Number = 0;
		
		private var loaded:Boolean = false;
		public var justSwapped:Boolean = false;
		
		private var initializationFunction:Function;
		
		public function Player(x:Number, y:Number, tp:TransitionProperties) {
			super(x, y, Resource.PLAYER_BLACK, FRAME_WIDTH, FRAME_HEIGHT);
			
			acceleration.y = World.GRAVITY;
			maxVelocity.y = TERMINAL_VELOCITY;
			resize();
			
			blend = AxBlendMode.TRANSPARENT_TEXTURE;
			
			addAnimation("stand", [0, 1], 4);
			addAnimation("walk", [5, 6, 7, 8], 12);
			addAnimation("wall", [2]);
			animate("stand");
			
			hue = World.INITIAL_COLOR;
			gun = new Gun(this.x, this.y);
			facing = tp == null ? RIGHT : tp.facing;
			
			if (tp != null) {
				velocity.x = tp.velocity.x;
				velocity.y = tp.velocity.y;
				//previous.x = this.x + tp.velocity.x * -Ax.dt;
				//previous.y = this.y + tp.velocity.y * -Ax.dt;
				initializationFunction = function():void {
					toggleColor(false, tp.hue);
				};
			}
			
			stationary = true;
		}
		
		override public function update():void {
			if (initializationFunction != null) {
				initializationFunction();
				initializationFunction = null;
			}
			
			if (!frozen && loaded && !Registry.game.frozen) {
				handleInput();
				handleFacing();
				handleShooting();
				handleTeleport();
			} else {
				stationary = true;
			}
			
			super.update();
			gun.update();
			
			if (Ax.camera.sprite.alpha == 0) {
				loaded = true;
				stationary = false;
			}
		}
		
		override public function draw():void {
			super.draw();
			gun.x = this.x;
			gun.y = this.y;
			gun.facing = clutching > 0 ? (this.facing == RIGHT ? LEFT : RIGHT) : this.facing;
			gun.draw();
		}
		
		private var left:Boolean, right:Boolean, up:Boolean, down:Boolean, jump:Boolean, swap:Boolean;
		private function handleInput():void {
			/*switch (Registry.controls) {
				case Controls.WASD1:
					left = Ax.keys.held(AxKey.A) || Ax.keys.held(AxKey.Q);
					right = Ax.keys.held(AxKey.D);
					jump = Ax.keys.pressed(AxKey.W) || Ax.keys.pressed(AxKey.Z);
					swap = Ax.keys.pressed(AxKey.SPACE);
				break;
				case Controls.WASD2:
					left = Ax.keys.held(AxKey.A) || Ax.keys.held(AxKey.Q);
					right = Ax.keys.held(AxKey.D);
					jump = Ax.keys.pressed(AxKey.SPACE);
					swap = Ax.keys.pressed(AxKey.W) || Ax.keys.pressed(AxKey.Z) || Ax.keys.pressed(AxKey.S);
				break;
				case Controls.ARROWS1:
					left = Ax.keys.held(AxKey.LEFT);
					right = Ax.keys.held(AxKey.RIGHT);
					jump = Ax.keys.pressed(AxKey.SPACE);
					swap = Ax.keys.pressed(AxKey.UP) || Ax.keys.pressed(AxKey.DOWN);
				break;
				case Controls.ARROWS2:
					left = Ax.keys.held(AxKey.LEFT);
					right = Ax.keys.held(AxKey.RIGHT);
					jump = Ax.keys.pressed(AxKey.UP);
					swap = Ax.keys.pressed(AxKey.SPACE);
				break;
			}*/
			left = Input.held(Input.LEFT);
			right = Input.held(Input.RIGHT);
			up = Input.held(Input.UP);
			down = Input.held(Input.DOWN);
			jump = Input.pressed(Input.JUMP) || Input.pressed(Input.ALT_JUMP);
			swap = Input.pressed(Input.SWAP) || Input.pressed(Input.ALT_SWAP);
			
			if (inputSinceClutch || (touching & DOWN)) {
				clutching -= Ax.dt;
			}
			wallJumping -= Ax.dt;
			
			justSwapped = false;
			if (swap && !invincible) {
				toggleColor();
				Sound.play(hue == WHITE ? "white" : "black");
				Registry.swaps++;
			}
			
			if (wallJumping <= 0) {
				if (left && !Input.held(Input.ALT_SHOOT)) {
					velocity.x = -SPEED;
					inputSinceClutch = true;
				} else if (right && !Input.held(Input.ALT_SHOOT)) {
					velocity.x = SPEED;
					inputSinceClutch = true;
				} else {
					velocity.x = 0;
				}
			}
			
			if (clutching > 0 && (touching & (LEFT | RIGHT)) && velocity.y > 0) {
				maxVelocity.y = 100;
			} else {
				maxVelocity.y = TERMINAL_VELOCITY;
			}
			
			if (hue == BLACK && Registry.hasItem(Item.MOON_BOOTS)) {
				if ((touching & LEFT) && !(touching & DOWN)) {
					clutching = 0.2;
					clutchingDirection = LEFT;
					inputSinceClutch = false;
					wallJumping = -1;
				} else if ((touching & RIGHT) && !(touching & DOWN)) {
					clutching = 0.1;
					clutchingDirection = RIGHT;
					inputSinceClutch = false;
					wallJumping = -1;
				}
			} else {
				clutching = -1;
			}
			
			if (touching & DOWN) {
				jumps = 0;
			} else if (jumps == 0) {
				jumps = 1;
			}
			
			if (jump) {
				if (Config.INFINITE_JUMPS || (jumps < (hue == WHITE && Registry.hasItem(Item.SUN_BOOTS) ? 2 : 1))) {
					jumps++;
					velocity.y = -JUMP_SPEED;
					if (jumps == 2) {
						Sound.play("double-jump");
					} else {
						Sound.play("jump");
					}
				} else if (clutching > 0 && Registry.hasItem(Item.MOON_BOOTS)) {
					velocity.y = -JUMP_SPEED * 0.75;
					velocity.x = (clutchingDirection == LEFT ? JUMP_SPEED : -JUMP_SPEED) / 2;
					maxVelocity.y = 600;
					clutching = -1;
					wallJumping = 0.3;
					Sound.play("jump");
				}
				inputSinceClutch = true;
			}
			
			if (Input.pressed(Input.BACK)) {
				harm();
			}
		}
		
		private function handleFacing():void {
			aim = -Math.atan2(Ax.mouse.y - center.y, Ax.mouse.x - center.x);
			if (Ax.mouse.screen.x != mx || Ax.mouse.screen.y != my) {
				mx = Ax.mouse.screen.x;
				my = Ax.mouse.screen.y;
				pointGunAtRadians(aim);
			}
			
			if (clutching > 0) {
				animate("wall");
			} else if (velocity.x != 0) {
				animate("walk");
			} else {
				animate("stand");
			}
		}
		
		private function handleShooting():void {
			gunRecharge -= Ax.dt;
			
			var shootStick:JoystickControl = Input.shootStick();
			var moveStick:JoystickControl = Input.moveStick();
			if (shootStick == null || moveStick == null) {
				return;
			}
			var shootButton:Boolean = Input.held(Input.SHOOT) || Input.held(Input.ALT_SHOOT);
			var shooting:Boolean = shootStick.distance > 0.3 || shootButton;
			
			if (!shooting) {
				if (velocity.x < 0) {
					pointGunAtRadians(Math.PI);
				} else if (velocity.x > 0) {
					pointGunAtRadians(0);
				}
			}
			
			if (gunRecharge > 0 || (hue == BLACK && !Registry.hasItem(Item.BLACK_GUN)) || (hue == WHITE && !Registry.hasItem(Item.WHITE_GUN))) {
				return;
			}
			
			if (shooting) {
				var bullet:Bullet = Registry.game.bullets.recycle() as Bullet;
				if (bullet == null) {
					Registry.game.bullets.add(bullet = new Bullet);
				}
				
				var direction:Number;
				if (!shootButton) {
					direction = shootStick.angle;
					pointGunAtRadians(direction);
				} else {
					if (moveStick.distance > 0.3) {
						direction = moveStick.angle;
					} else if (facing == RIGHT || Input.held(Input.RIGHT)) {
						direction = 0;
						facing = RIGHT;
					} else if (facing == LEFT || Input.held(Input.LEFT)) {
						direction = Math.PI;
						facing = LEFT;
					}
					pointGunAtRadians(direction);
				}
				
				bullet.shoot(hue, center.x, center.y, direction, 300);
				gunRecharge = Gun.DELAY;
			}
		}
		
		private function pointGunAtRadians(radians:Number):void {
			var degrees:Number = radians * 180 / Math.PI;
			if (degrees < 0) {
				degrees += 360;
			}
			
			if (clutching > 0) {
				facing = clutchingDirection;
			} else {
				if (degrees <= 90 || degrees >= 270) {
					facing = RIGHT;
				} else {
					facing = LEFT;
				}
			}
			
			if (degrees < 30) {
				gun.setDirection(Gun.RIGHT);
			} else if (degrees < 150) {
				gun.setDirection(Gun.UP);
			} else if (degrees < 210) {
				gun.setDirection(Gun.RIGHT);
			} else if (degrees < 330) {
				gun.setDirection(Gun.DOWN);
			} else {
				gun.setDirection(Gun.RIGHT);
			}
		}
		
		private function handleTeleport():void {
			if (x > Registry.game.world.width - width / 2) {
				Registry.game.teleport(Registry.game.world.width, y, 2, 0, new TransitionProperties(velocity, hue, facing));
			} else if (x < -width / 2) {
				Registry.game.teleport(-width, y, -2, 0, new TransitionProperties(velocity, hue, facing));
			} else if (y > Registry.game.world.height - height / 2) {
				Registry.game.teleport(x, Registry.game.world.height, 0, 2, new TransitionProperties(velocity, hue, facing));
			} else if (y < -height / 2) {
				Registry.game.teleport(x, -height, 0, -2, new TransitionProperties(velocity, hue, facing, true));
			}
			
			if ((touching & DOWN) && Registry.game.transitionProperties != null && Registry.game.transitionProperties.upwards && !Registry.game.transitionProperties.adjustedUpwards) {
				Registry.game.initialX = Registry.game.world.room.x + x / Tile.SIZE;
				Registry.game.initialY = Registry.game.world.room.y + y / Tile.SIZE;
				Registry.game.transitionProperties.velocity = new AxVector;
				Registry.game.transitionProperties.adjustedUpwards = true;
			}
		}
		
		private function toggleColor(flash:Boolean = true, force:int = -1):void {
			hue = force > -1 ? force : (hue == WHITE ? BLACK : WHITE);
			load(hue == BLACK ? Resource.PLAYER_BLACK : Resource.PLAYER_WHITE, FRAME_WIDTH, FRAME_HEIGHT, true);
			gun.changeColor(hue);
			Registry.game.world.setGraphic(hue == WHITE ? Resource.TILES_WHITE : Resource.TILES_BLACK);
			if (flash) {
				Ax.camera.flash(0.2, hue == WHITE ? 0x55ffffff : 0x55000000);
			}
			Registry.game.world.adjustFromColor(hue);
			resize();
			justSwapped = true;
//			Registry.game.lasersW.dirty = true;
//			Registry.game.lasersB.dirty = true;
			
			if (hue == WHITE) {
				clutching = 0;
				Registry.game.spikesW.alpha = 1;
				Registry.game.spikesB.alpha = 0.2;
			} else {
				Registry.game.spikesW.alpha = 0.2;
				Registry.game.spikesB.alpha = 1;
			}
		}
		
		private function resize():void {
			width = 10;
			offset.x = 5;
			height = 17;
			offset.y = 8;
			origin.x = frameWidth / 2;
			origin.y = frameHeight / 2;
		}
		
		private function freeze():void {
			acceleration.y = velocity.x = velocity.y = 0;
			frozen = true;
			resize();
			gun.blend = blend = AxBlendMode.BLEND;
			show(animation.frames[frame]);
		}
		
		private static const DIE_SCALE:Number = 10, DIE_SPEED:Number = 0.5;
		public function harm():void {
			if (Config.INVINCIBLE || frozen || invincible) {
				return;
			}
			
			Analytics.event("game", "death");
			Analytics.event("game", "death-room-" + Registry.game.world.room.x + "-" + Registry.game.world.room.y);
			Registry.deaths++;
			Sound.play("player-die");
			freeze();
			gun.grow(DIE_SPEED, DIE_SCALE, DIE_SCALE).fadeOut(DIE_SPEED);
			grow(DIE_SPEED, DIE_SCALE, DIE_SCALE).fadeOut(DIE_SPEED, 0, function():void {
				Registry.game.respawn();
			});
		}

		public function teleport(targetX:Number, targetY:Number):void {
			this.x = this.previous.x = targetX;
			this.y = this.previous.y = targetY;
			Sound.play("teleport");
		}
	}
}
