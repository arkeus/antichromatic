package io.arkeus.antichromatic.scene {
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.game.world.World;
	import io.arkeus.antichromatic.game.world.WorldBuilder;
	import io.arkeus.antichromatic.input.Input;
	import io.arkeus.antichromatic.util.Config;
	import io.arkeus.antichromatic.util.Registry;
	
	import org.axgl.Ax;
	import org.axgl.AxRect;
	import org.axgl.AxState;
	import org.axgl.input.AxKey;
	import org.axgl.plus.message.AxMessage;
	import org.axgl.text.AxText;

	public class SceneState extends AxState {
		public var world:World;
		public var camera:SceneCamera;
		
		private var speed:Number;
		private var messages:Array;
		private var map:Class;
		private var rooms:Class;
		private var complete:Boolean = false;
		
		public function SceneState(speed:Number, messages:Array, map:Class, rooms:Class) {
			this.speed = speed;
			this.messages = messages;
			this.map = map;
			this.rooms = rooms;
			Registry.playMusic(SceneMusic);
		}
		
		override public function create():void {
			var builder:WorldBuilder = new WorldBuilder(map, Resource.TILES_BLACK, rooms, 0, 0, 0, 0);
			this.add(world = builder.build(null));
			this.add(camera = new SceneCamera(speed));
			Ax.camera.follow(camera);
			Ax.camera.bounds = new AxRect(0, 0, world.width, world.height);
			persistantUpdate = true;
			addTimer(1, function():void {
				AxMessage.show(messages, Config.SCENE_MESSAGE_OPTIONS);
			});
			
			var skip:AxText = new AxText(0, Ax.viewHeight - 21, null, "@[ffdddd](A)@[] To Skip", Ax.viewWidth, "right");
			skip.noScroll();
			this.add(skip);
		}
		
		override public function update():void {
			if (camera.x > world.width - Ax.viewWidth / 2) {
				camera.velocity.x = -speed;
			} else if (camera.x < Ax.viewWidth / 2) {
				camera.velocity.x = speed;
			}
			
			if (Input.pressed(Input.CANCEL) && !complete) {
				if (Ax.state == this) {
					clearTimers();
					onResume(null);
				} else {
					Ax.popState();
				}
				complete = true;
			}
			
			super.update();
		}
		
		override public function onResume(sourceState:Class):void {
			complete = true;
			onComplete();
		}
		
		protected function onComplete():void {
			// abstract
		}
		
		protected function onSkip():void {
			// abstract
		}
	}
}
