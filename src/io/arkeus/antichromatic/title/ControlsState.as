package io.arkeus.antichromatic.title {
	import io.arkeus.antichromatic.assets.Resource;
	import io.arkeus.antichromatic.util.Analytics;
	import io.arkeus.antichromatic.util.Controls;
	import io.arkeus.antichromatic.util.Registry;
	
	import org.axgl.Ax;
	import org.axgl.AxButton;
	import org.axgl.AxSprite;
	import org.axgl.AxState;
	import org.axgl.text.AxText;

	public class ControlsState extends AxState {
		private static const SELECTED_COLOR:uint = 0xff55ff55;
		
		private var wasd1Button:AxButton;
		private var wasd2Button:AxButton;
		private var arrows1Button:AxButton;
		private var arrows2Button:AxButton;
		
		private var controlsFrame:AxSprite;
		private var controlsText:AxText;
		
		override public function create():void {
			noScroll();
			
			this.add(wasd1Button = new AxButton(67, 144, Resource.BUTTON, 107, 24).text("WASD", null, 7, 3).onClick(wasd1));
			this.add(wasd2Button = new AxButton(186, 144, Resource.BUTTON, 107, 24).text("Alt WASD", null, 7, 3).onClick(wasd2));
			this.add(arrows1Button = new AxButton(67, 180, Resource.BUTTON, 107, 24).text("Arrows", null, 7, 3).onClick(arrows1));
			this.add(arrows2Button = new AxButton(186, 180, Resource.BUTTON, 107, 24).text("Alt Arrows", null, 7, 3).onClick(arrows2));
			this.add(new AxButton(127, 216, Resource.BUTTON, 107, 24).text("Back", null, 7, 3).onClick(back));
			
			this.add(controlsFrame = new AxSprite(68, 61));
			controlsFrame.create(224, 48, 0xcc000000);
			this.add(controlsText = new AxText(70, 66, null, CONTROL_TEXT[0], 220, "center"));
			
			updateControlScheme(Registry.controls);
			Analytics.view("controls");
		}
		
		override public function update():void {
			if (wasd1Button.hover()) {
				showTooltip(0);
			} else if (wasd2Button.hover()) {
				showTooltip(1);
			} else if (arrows1Button.hover()) {
				showTooltip(2);
			} else if (arrows2Button.hover()) {
				showTooltip(3);
			} else {
				showTooltip(-1);
			}
			
			super.update();
		}
		
		private function showTooltip(scheme:int):void {
			if (scheme == -1) {
				controlsFrame.visible = false;
				controlsText.visible = false;
				return;
			}
			
			controlsFrame.visible = true;
			controlsText.visible = true;
			controlsText.text = CONTROL_TEXT[scheme];
		}
		
		private function wasd1():void {
			updateControlScheme(Controls.WASD1);
		}
		
		private function wasd2():void {
			updateControlScheme(Controls.WASD2);
		}
		
		private function arrows1():void {
			updateControlScheme(Controls.ARROWS1);
		}
		
		private function arrows2():void {
			updateControlScheme(Controls.ARROWS2);
		}
		
		private function updateControlScheme(scheme:uint):void {
			Registry.controls = scheme;
			Registry.saveGlobals();
			wasd1Button.color.hex = wasd2Button.color.hex = arrows1Button.color.hex = arrows2Button.color.hex = 0xffffffff;
			switch (scheme) {
				case Controls.WASD1: wasd1Button.color.hex = SELECTED_COLOR; break;
				case Controls.WASD2: wasd2Button.color.hex = SELECTED_COLOR; break;
				case Controls.ARROWS1: arrows1Button.color.hex = SELECTED_COLOR; break;
				case Controls.ARROWS2: arrows2Button.color.hex = SELECTED_COLOR; break;
			}
		}
		
		private function back():void {
			Ax.popState();
			Ax.keys.releaseAll();
			Ax.mouse.releaseAll();
		}
		
		private static const CONTROL_TEXT:Array = [
			"WASD Control Scheme:\n@[999999]Move Left: @[]A or Q@[999999], Move Right: @[]D\n@[999999]Jump: @[]W or Z@[999999], Swap Color: @[]Space\n@[999999]Shoot: @[]Arrow Keys or Mouse",
			"Alt WASD Control Scheme:\n@[999999]Move Left: @[]A or Q@[999999], Move Right: @[]D\n@[999999]Jump: @[]Space@[999999], Swap Color: @[]W or Z or S\n@[999999]Shoot: @[]Arrow Keys or Mouse",
			"Arrows Control Scheme:\n@[999999]Move Left: @[]Left@[999999], Move Right: @[]Right\n@[999999]Jump: @[]Space@[999999], Swap Color: @[]Up or Down\n@[999999]Shoot: @[]WASD",
			"Alt Arrows Control Scheme:\n@[999999]Move Left: @[]Left@[999999], Move Right: @[]Right\n@[999999]Jump: @[]Up@[999999], Swap Color: @[]SPACE\n@[999999]Shoot: @[]WASD",
		];
	}
}
