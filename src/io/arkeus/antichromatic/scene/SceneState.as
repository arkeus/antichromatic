package io.arkeus.antichromatic.scene {
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.game.world.World;
	import io.arkeus.antichromatic.game.world.WorldBuilder;
	
	import org.axgl.Ax;
	import org.axgl.AxRect;
	import org.axgl.AxState;

	public class SceneState extends AxState {
		public var world:World;
		public var camera:SceneCamera;
		
		private var speed:Number;
		private var messages:Array;
		
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
		}
		
		override public function update():void {
			if (camera.x > world.width - Ax.viewWidth / 2) {
				camera.velocity.x = -speed;
			} else if (camera.x < Ax.viewWidth / 2) {
				camera.velocity.x = speed;
			}
			
			super.update();
		}
	}
}
