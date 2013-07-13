package io.arkeus.antichromatic.ouya {
	import flash.utils.getTimer;
	
	import io.arkeus.antichromatic.input.Input;
	
	import org.axgl.Ax;
	import org.axgl.AxEntity;
	import org.axgl.AxGroup;

	public class OuyaButtonGroup extends AxGroup {
		public var selected:OuyaButton = null;
		
		public function OuyaButtonGroup(x:Number = 0, y:Number = 0) {
			super(x, y);
		}
		
		override public function add(entity:AxEntity, linkParent:Boolean=true, inheritScroll:Boolean=true):AxGroup {
			super.add(entity);
			if (selected == null) {
				(entity as OuyaButton).selected = true;
				selected = entity as OuyaButton;
			}
			return this;
		}
		
		public function forceSelect(button:OuyaButton):void {
			selected.selected = false;
			selected = button;
			selected.selected = true;
		}
		
		override public function update():void {
			if (Input.pressed(Input.RIGHT)) {
				select(toTheRight, verticalDistance);
			} else if (Input.pressed(Input.LEFT)) {
				select(toTheLeft, verticalDistance);
			} else if (Input.pressed(Input.DOWN)) {
				select(below, horizontalDistance);
			} else if (Input.pressed(Input.UP)) {
				select(above, diagonalDistance);
			}
			
			super.update();
		}
		
		private function select(requirementFunction:Function, minimizeFunction:Function):void {
			var score:Number = Infinity;
			var best:OuyaButton = null;
			for each(var button:OuyaButton in members) {
				var newScore:Number = requirementFunction(selected, button) ? minimizeFunction(selected, button) : Infinity;
				if (newScore < score) {
					score = newScore;
					best = button;
				}
			}
			
			if (best != null) {
				forceSelect(best);
			}
		}
		
		// Minimize and requirement functions
		
		private function below(selected:OuyaButton, target:OuyaButton):Boolean {
			return target.y > selected.y;
		}
		
		private function above(selected:OuyaButton, target:OuyaButton):Boolean {
			return target.y < selected.y;
		}
		
		private function toTheRight(selected:OuyaButton, target:OuyaButton):Boolean {
			return target.x > selected.x && Math.abs(target.y - selected.y) < 5;
		}
		
		private function toTheLeft(selected:OuyaButton, target:OuyaButton):Boolean {
			return target.x < selected.x && Math.abs(target.y - selected.y) < 5;
		}
		
		private function horizontalDistance(selected:OuyaButton, target:OuyaButton):Number {
			return Math.abs(target.x - selected.x);
		}
		
		private function verticalDistance(selected:OuyaButton, target:OuyaButton):Number {
			return Math.abs(target.y - selected.y);
		}
		
		private function diagonalDistance(selected:OuyaButton, target:OuyaButton):Number {
			return Math.abs(target.x - selected.x) + Math.abs(target.y - selected.y);
		}
	}
}
