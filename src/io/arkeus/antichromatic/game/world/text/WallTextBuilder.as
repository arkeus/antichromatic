package io.arkeus.antichromatic.game.world.text {
	import flash.geom.Rectangle;
	
	import io.arkeus.antichromatic.util.Difficulty;
	import io.arkeus.antichromatic.util.Item;
	import io.arkeus.antichromatic.util.Registry;
	
	import org.axgl.AxGroup;
	import org.axgl.text.AxText;

	public class WallTextBuilder {
		private static var texts:Object;
		
		public function WallTextBuilder() {
			if (texts == null) {
				initializeTexts();
			}
		}
		
		private function initializeTexts():void {
			texts = {};
			//addText(120, 50, new Rectangle(), "It's been nearly a year since our world was @[bfa747]fractured@[]. Split in two, we've been trying to restore the world since. We've infiltrated the facility and obtained a suit of @[bfa747]Chromatic Armor@[] in order to pass between the @[bfa747]two fractured dimensions@[], but we have no idea where the source of the fracture is. If we can @[bfa747]destroy the source@[], we believe we can restore the world to it's former glory.");
			addText(function():Boolean { return !Registry.hasItem(Item.WHITE_GUN); }, 120, 50, new Rectangle(162, 145, 133), "Use @[222222]A (or Q) and D@[] to move, and @[222222]W (or Z)@[] to jump. You can also use @[222222]R@[] to kill yourself if you get stuck.");
			addText(function():Boolean { return !Registry.hasItem(Item.WHITE_GUN); }, 150, 25, new Rectangle(6*12, 38*12, 10*12), "To swap between the white and black dimension, hit @[222222][Space]@[]. Harmful objects in the opposite dimension cannot hurt you.");
			addText(function():Boolean { return !Registry.hasItem(Item.WHITE_GUN); }, 150, 25, new Rectangle(19*12+9, 34*12, 9*12-12), "The @[222222]White Gun Cell@[] allows you to shoot in the white dimension using the @[222222]Mouse@[] or @[222222]Arrow Keys@[].");
			addText(function():Boolean { return !Registry.hasItem(Item.MOON_BOOTS); }, 180, 50, new Rectangle(9*12, 16*12, 12*12), "Sometimes to move @[222222]forward@[], we @[222222]must go back@[].");
			addText(function():Boolean { return !Registry.hasItem(Item.BLACK_GUN); }, 60, 50, new Rectangle(33*12, 15*12, 22*12), "Objects that are @[222222]both@[] black and white exist in both dimensions, and should be @[222222]avoided@[] regardless of which dimension you currently reside in.");
			addText(function():Boolean { return !Registry.hasItem(Item.BLACK_GUN); }, 60, 50, new Rectangle(4*12, 6*12, 11*12), "The @[222222]Black Gun Cell@[] allows you to shoot in the black dimension.");
			addText(function():Boolean { return !Registry.hasItem(Item.SUN_BOOTS); }, 30, 50, new Rectangle(10*12, 15*12, 10*12), "Some challenges are best left for @[222222]another time@[].");
			addText(function():Boolean { return !Registry.hasItem(Item.SUN_BOOTS); }, 270, 0, new Rectangle(4*12+8, 14*12-9, 22*12), "The @[222222]Sun Boots@[] allow you to double jump within the @[222222]white@[] dimension.");
			addText(function():Boolean { return !Registry.hasItem(Item.MOON_BOOTS); }, 180, 75, new Rectangle(4*12, 18*12-5, 15*12), "The @[222222]Moon Boots@[] allow you to wall jump within the @[222222]black@[] dimension.");
			addText(function():Boolean { return !Registry.hasItem(Item.TELEPORT_BADGE); }, 240, 25, new Rectangle(7*12, 10*12-5, 15*12), "The @[222222]Teleport Badge@[] allows you to @[222222]touch a teleporter pad@[] in your dimension, then @[222222]swap dimensions@[] to teleport to the other pad.");
			addText(null, 0, 0, new Rectangle(), "Young warrior, you may have stolen my armor and infiltrated my fortress, but I have the shared power between the two dimensions protecting me. You'll never harm me!");
		}
		
		private function addText(condition:Function, roomX:uint, roomY:uint, textarea:Rectangle, text:String):void {
			var group:Array = (texts[getKey(roomX, roomY)] ||= []);
			group.push([textarea, text, condition]);
		}
		
		public function getTexts(x:uint, y:uint):AxGroup {
			if (Registry.difficulty == Difficulty.HARD) {
				return null;
			}
			var textArray:Array = texts[getKey(x, y)] as Array;
			if (textArray == null || textArray.length == 0) {
				return null;
			}
			var group:AxGroup = new AxGroup;
			for (var i:uint = 0; i < textArray.length; i++) {
				var info:Array = textArray[i] as Array;
				var rect:Rectangle = info[0] as Rectangle;
				var condition:Function = info[2] as Function;
				if (condition != null && !condition()) {
					continue;
				}
				var text:AxText = new AxText(rect.x, rect.y, null, info[1], rect.width, "center");
				text.alpha = 0.7;
				group.add(text);
			}
			return group;
		}
		
		private function getKey(roomX:uint, roomY:uint):String {
			return roomX + "_" + roomY;
		}
	}
}
