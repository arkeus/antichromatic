package io.arkeus.antichromatic.scene {
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.assets.Sound;
	import io.arkeus.antichromatic.game.GameState;
	import io.arkeus.antichromatic.game.world.World;
	import io.arkeus.antichromatic.game.world.WorldBuilder;
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
		private var complete:Boolean = false;
		
		public function SceneState(speed:Number, messages:Array) {
			this.speed = speed;
			this.messages = messages;
		}
		
		override public function create():void {
			var builder:WorldBuilder = new WorldBuilder(Resource.INTRO, Resource.TILES_BLACK, Resource.INTRO_ROOMS, 0, 0, 0, 0);
			this.add(world = builder.build(null));
			this.add(camera = new SceneCamera(speed));
			Ax.camera.follow(camera);
			Ax.camera.bounds = new AxRect(0, 0, world.width, world.height);
			persistantUpdate = true;
			addTimer(1, function():void {
				AxMessage.show(messages, Config.SCENE_MESSAGE_OPTIONS);
			});
			
			var skip:AxText = new AxText(0, Ax.viewHeight - 11, null, "@[ffdddd]Escape@[] To Skip", Ax.viewWidth, "right");
			skip.noScroll();
			this.add(skip);
		}
		
		override public function update():void {
			if (camera.x > world.width - Ax.viewWidth / 2) {
				camera.velocity.x = -speed;
			} else if (camera.x < Ax.viewWidth / 2) {
				camera.velocity.x = speed;
			}
			
			if (Ax.keys.pressed(AxKey.ESCAPE) && !complete) {
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
			Ax.camera.fadeOut(2, 0xff000000, function():void {
				Ax.switchState(new GameState);
				Ax.camera.fadeIn(0.5, function():void { Registry.loading = false; });
				Ax.keys.releaseAll();
				Ax.mouse.releaseAll();
			});
		}
	}
}
