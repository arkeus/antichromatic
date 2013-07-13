package io.arkeus.antichromatic.ouya {
	import io.arkeus.antichromatic.input.Input;
	
	import org.axgl.AxButton;

	public class OuyaButton extends AxButton {
		public var selected:Boolean = false;
		
		public function OuyaButton(x:Number, y:Number, graphic:Class = null, frameWidth:uint = 150, frameHeight:uint = 30) {
			super(x, y, graphic, frameWidth, frameHeight);
		}
		
		override public function held():Boolean {
			return selected || super.held();
		}
		
		override public function released():Boolean {
			return (selected && Input.pressed(Input.ACCEPT)) || ((label.text == "Back" || label.text == "Cancel") && Input.pressed(Input.CANCEL)) || super.released();
		}
	}
}
