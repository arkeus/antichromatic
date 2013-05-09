package io.arkeus.antichromatic.scene {
	import org.axgl.Ax;
	import org.axgl.AxEntity;

	public class SceneCamera extends AxEntity {
		public function SceneCamera(speed:Number) {
			super(Ax.viewWidth / 2, Ax.viewHeight / 2);
			velocity.x = speed;
		}
	}
}
