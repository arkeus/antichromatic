package io.arkeus.antichromatic.util {
	import org.axgl.AxEntity;
	import org.axgl.AxVector;

	public class TransitionProperties {
		public var velocity:AxVector;
		public var hue:uint;
		public var upwards:Boolean;
		public var facing:uint;
		public var adjustedUpwards:Boolean = false;
		
		public function TransitionProperties(velocity:AxVector, hue:uint, facing:uint, upwards:Boolean = false) {
			this.velocity = velocity;
			this.hue = hue;
			this.upwards = upwards;
			this.facing = facing;
		}
		
		public function serialize():Array {
			return [velocity.x, velocity.y, hue, upwards, adjustedUpwards, facing];
		}
		
		public static function deserialize(data:Array):TransitionProperties {
			var tp:TransitionProperties = new TransitionProperties(new AxVector, 0, AxEntity.RIGHT);
			tp.velocity.x = data[0];
			tp.velocity.y = data[1];
			tp.hue = data[2];
			tp.upwards = data[3];
			tp.adjustedUpwards = data[4];
			tp.facing = data[5];
			trace("load", data);
			return tp;
		}
	}
}
