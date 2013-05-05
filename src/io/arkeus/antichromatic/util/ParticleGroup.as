package io.arkeus.antichromatic.util {
	import org.axgl.AxGroup;
	import org.axgl.particle.AxParticleCloud;

	public class ParticleGroup extends AxGroup {
		public function ParticleGroup(x:Number = 0, y:Number = 0) {
			super(x, y);
		}
		
		override public function update():void {
			super.update();
		}
		
		override public function dispose():void {
			for (var i:uint = 0; i < members.length; i++) {
				resetParticleCloud(members[i]);
			}
			return;
		}
		
		private function resetParticleCloud(group:AxGroup):void {
			for (var i:uint = 0; i < group.members.length; i++) {
				var cloud:AxParticleCloud = group.members[i] as AxParticleCloud;
				cloud.visible = cloud.active = cloud.exists = false;
				cloud.time = 0;
			}
		}
	}
}
