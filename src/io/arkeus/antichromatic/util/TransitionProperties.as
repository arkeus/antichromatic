package io.arkeus.antichromatic.util {
	import org.axgl.AxVector;

	public class TransitionProperties {
		public var velocity:AxVector;
		public var hue:uint;
		public var upwards:Boolean;
		public var adjustedUpwards:Boolean = false;
		
		public function TransitionProperties(velocity:AxVector, hue:uint, upwards:Boolean = false) {
			this.velocity = velocity;
			this.hue = hue;
			this.upwards = upwards;
		}
	}
}
