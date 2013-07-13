package io.arkeus.antichromatic.input {
	import io.arkeus.antichromatic.util.Config;
	import io.arkeus.ouya.ControllerInput;
	import io.arkeus.ouya.control.JoystickControl;
	import io.arkeus.ouya.controller.GameController;
	import io.arkeus.ouya.controller.OuyaController;
	import io.arkeus.ouya.controller.Xbox360Controller;
	
	import org.axgl.Ax;
	import org.axgl.input.AxKey;

	public class Input {
		public static const LEFT:uint = 0;
		public static const RIGHT:uint = 1;
		public static const DOWN:uint = 2;
		public static const UP:uint = 3;
		
		public static const ACCEPT:uint = 4;
		public static const JUMP:uint = 4;
		
		public static const SHOOT:uint = 5;
		
		public static const CANCEL:uint = 6;
		public static const SWAP:uint = 6;
		
		public static const ALT_SHOOT:uint = 7;
		public static const ALT_JUMP:uint = 8;
		public static const ALT_SWAP:uint = 9;
		
		public static const BACK:uint = 10;
		public static const MENU:uint = 11;
		
		public static var xbox:Xbox360Controller;
		public static var ouya:OuyaController;
		
		public static function pressed(key:uint):Boolean {
			return ouyaButtonPressed(key) || xboxButtonPressed(key) || Ax.keys.pressed(toKeyboardKey(key));
		}
		
		public static function held(key:uint):Boolean {
			return ouyaButtonHeld(key) || xboxButtonHeld(key) || Ax.keys.held(toKeyboardKey(key));
		}
		
		private static function toKeyboardKey(input:uint):uint {
			if (!Config.KEYBOARD_ENABLED) {
				return AxKey.NINE;
			}
			
			switch (input) {
				case LEFT: return AxKey.A; break;
				case RIGHT: return AxKey.D; break;
				case DOWN: return AxKey.S; break;
				case UP: return AxKey.W; break;
				case ACCEPT: return AxKey.W; break;
				case SWAP: return AxKey.SPACE; break;
				case ALT_SHOOT: return AxKey.SHIFT; break;
				case SHOOT: return AxKey.SHIFT; break;
				case MENU: return AxKey.ESCAPE; break;
			}
			return AxKey.NINE;
		}
		
		private static function ouyaButtonHeld(input:uint):Boolean {
			if (ouya == null) {
				return false;
			}
			
			switch (input) {
				case LEFT: return ouya.leftStick.left.held || ouya.dpad.left.held; break;
				case RIGHT: return ouya.leftStick.right.held || ouya.dpad.right.held; break;
				case DOWN: return ouya.leftStick.down.held || ouya.dpad.down.held; break;
				case UP: return ouya.leftStick.up.held || ouya.dpad.up.held; break;
				case ACCEPT: return ouya.o.held; break;
				case SHOOT: return ouya.u.held; break;
				case SWAP: return ouya.a.held; break;
				case ALT_SHOOT: return ouya.rt.held || ouya.lt.held; break;
				case ALT_JUMP: return ouya.lb.held; break;
				case ALT_SWAP: return ouya.rb.held; break;
				case BACK: return ouya.leftStick.held; break;
				case MENU: return ouya.y.held; break;
			}
			
			return false;
		}
		
		private static function ouyaButtonPressed(input:uint):Boolean {
			if (ouya == null) {
				return false;
			}
			
			switch (input) {
				case LEFT: return (ouya.leftStick.distance < 0.3 && ouya.dpad.left.pressed) || ouya.leftStick.left.pressed; break;
				case RIGHT: return (ouya.leftStick.distance < 0.3 && ouya.dpad.right.pressed) || ouya.leftStick.right.pressed; break;
				case DOWN: return (ouya.leftStick.distance < 0.3 && ouya.dpad.down.pressed) || ouya.leftStick.down.pressed; break;
				case UP: return (ouya.leftStick.distance < 0.3 && ouya.dpad.up.pressed) || ouya.leftStick.up.pressed; break;
				case ACCEPT: return ouya.o.pressed; break;
				case SHOOT: return ouya.u.pressed; break;
				case SWAP: return ouya.a.pressed; break;
				case ALT_SHOOT: return ouya.rt.pressed || ouya.lt.pressed; break;
				case ALT_JUMP: return ouya.lb.pressed; break;
				case ALT_SWAP: return ouya.rb.pressed; break;
				case BACK: return ouya.leftStick.pressed; break;
				case MENU: return ouya.y.pressed; break;
			}
			
			return false;
		}
		
		private static function xboxButtonHeld(input:uint):Boolean {
			if (xbox == null) {
				return false;
			}
			
			switch (input) {
				case LEFT: return xbox.leftStick.left.held || xbox.dpad.left.held; break;
				case RIGHT: return xbox.leftStick.right.held || xbox.dpad.right.held; break;
				case DOWN: return xbox.leftStick.down.held || xbox.dpad.down.held; break;
				case UP: return xbox.leftStick.up.held || xbox.dpad.up.held; break;
				case ACCEPT: return xbox.a.held; break;
				case SHOOT: return xbox.x.held; break;
				case SWAP: return xbox.b.held; break;
				case ALT_SHOOT: return xbox.rt.held || xbox.lt.held; break;
				case ALT_JUMP: return xbox.lb.held; break;
				case ALT_SWAP: return xbox.rb.held; break;
				case BACK: return xbox.back.held; break;
				case MENU: return xbox.start.held || xbox.y.held; break;
			}
			
			return false;
		}
		
		private static function xboxButtonPressed(input:uint):Boolean {
			if (xbox == null) {
				return false;
			}
			
			switch (input) {
				case LEFT: return xbox.leftStick.left.pressed || xbox.dpad.left.pressed; break;
				case RIGHT: return xbox.leftStick.right.pressed || xbox.dpad.right.pressed; break;
				case DOWN: return xbox.leftStick.down.pressed || xbox.dpad.down.pressed; break;
				case UP: return xbox.leftStick.up.pressed || xbox.dpad.up.pressed; break;
				case ACCEPT: return xbox.a.pressed; break;
				case SHOOT: return xbox.x.pressed; break;
				case SWAP: return xbox.b.pressed; break;
				case ALT_SHOOT: return xbox.rt.pressed || xbox.lt.pressed; break;
				case ALT_JUMP: return xbox.lb.pressed; break;
				case ALT_SWAP: return xbox.rb.pressed; break;
				case BACK: return xbox.back.pressed; break;
				case MENU: return xbox.start.pressed || xbox.y.pressed; break;
			}
			return 0;
		}
		
		public static function shootStick():JoystickControl {
			if (ouya != null) {
				return ouya.rightStick;
			} else if (xbox != null) {
				return xbox.rightStick;
			}
			return null;
		}
		
		public static function moveStick():JoystickControl {
			if (ouya != null) {
				return ouya.leftStick;
			} else if (xbox != null) {
				return xbox.leftStick;
			}
			return null;
		}
		
		public static function update():void {
			var controller:GameController;
			
			if (ControllerInput.hasRemovedController()) {
				controller = ControllerInput.getRemovedController();
				if (xbox == controller) {
					xbox = null;
				} else if (ouya == controller) {
					ouya = null;
				}
			}
			
			if (ControllerInput.hasReadyController()) {
				controller = ControllerInput.getReadyController();
				if (xbox == null && controller is Xbox360Controller) {
					xbox = controller as Xbox360Controller;
				} else if (ouya == null && controller is OuyaController) {
					ouya = controller as OuyaController;
				}
			}
		}
		
		public static function reset():void {
			if (xbox != null) {
				xbox.reset();
			}
			if (ouya != null) {
				ouya.reset();
			}
		}
	}
}
