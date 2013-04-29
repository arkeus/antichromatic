package org.axgl.plus.message {
	import org.axgl.Ax;
	import org.axgl.AxRect;
	import org.axgl.AxSprite;
	import org.axgl.AxState;
	import org.axgl.input.AxKey;
	import org.axgl.input.AxMouseButton;
	import org.axgl.resource.AxResource;
	import org.axgl.text.AxFont;
	import org.axgl.text.AxText;
	import org.axgl.text.AxTextLine;

	public class AxMessageState extends AxState {
		private var messages:Vector.<String>;
		private var box:AxRect;
		private var font:AxFont;
		private var align:String;
		private var delay:Number;
		private var key:uint;
		private var speedDelay:Number;
		private var background:Class;
		private var paddingLeft:Number;
		private var paddingRight:Number;
		private var paddingTop:Number;
		private var paddingBottom:Number;
		
		private var message:AxText;
		private var currentMessage:String;
		private var timer:Number;
		private var speedKeyDisabled:Boolean;
		
		public function AxMessageState(messages:*, options:Object) {
			var rawMessages:Vector.<String>;
			if (messages is Array) {
				rawMessages = Vector.<String>(messages);
			} else if (messages is String) {
				rawMessages = Vector.<String>([messages]);
			} else {
				throw new Error("AxMessage requires either a string or an array of strings to display.");
			}
			
			var x:Number = options['x'] is Number ? options['x'] : 0;
			var y:Number = options['y'] is Number ? options['y'] : 0;
			var width:Number = options['width'] is Number ? options['width'] : Ax.viewWidth;
			var height:Number = options['height'] is Number ? options['height'] : Ax.viewHeight / 3;
			this.box = new AxRect(x, y, width, height);
			this.font = options['font'] is AxFont ? options['font'] : AxResource.font;
			this.align = options['align'] is String ? options['align'] : AxMessageAlign.LEFT;
			this.delay = options['delay'] is Number ? options['delay'] : 50;
			this.key = options['key'] is uint ? options['key'] : AxKey.SPACE;
			this.speedDelay = options['speedDelay'] is Number ? options['speedDelay'] : 0.1;
			this.background = options['background'] is Class ? options['background'] : null;
			this.paddingLeft = options['paddingLeft'] is Number ? options['paddingLeft'] : 0;
			this.paddingRight = options['paddingRight'] is Number ? options['paddingRight'] : 0;
			this.paddingTop = options['paddingTop'] is Number ? options['paddingTop'] : 0;
			this.paddingBottom = options['paddingBottom'] is Number ? options['paddingBottom'] : 0;
			
			this.messages = generateMessages(rawMessages);
		}
		
		override public function create():void {
			if (background != null) {
				var bg:AxSprite = new AxSprite(box.x, box.y, background);
				bg.scroll.x = bg.scroll.y = 0;
				this.add(bg);
			}
			message = new AxText(box.x + paddingLeft, box.y + paddingTop, font, "", box.width - (paddingLeft + paddingRight), align);
			message.scroll.x = message.scroll.y = 0;
			this.add(message);
			this.timer = 0;
			this.speedKeyDisabled = false;
			next();
		}
		
		override public function update():void {
			tick();
			
			super.update();
		}
		
		private function tick():void {
			if (message.text.length < currentMessage.length) {
				timer -= Ax.dt;
				while (timer <= 0) {
					timer += delay / 1000 * (Ax.keys.down(ANY) && !speedKeyDisabled ? speedDelay : 1);
					addCharacter();
				}
				
				if (!Ax.keys.down(AxKey.SPACE)) {
					speedKeyDisabled = false;
				}
			} else {
				if (Ax.keys.pressed(AxKey.ANY) || Ax.mouse.pressed(AxMouseButton.LEFT)) {
					next();
					speedKeyDisabled = true;
				}
			}
		}
		
		private function next():void {
			if (messages.length > 0) {
				currentMessage = messages.shift();
				message.text = "";
			} else {
				Ax.popState();
			}
		}
		
		private function addCharacter():void {
			var index:uint = message.text.length;
			var inTag:Boolean = currentMessage.charAt(index) == "@";
			while (inTag) {
				inTag = currentMessage.charAt(++index) != "]";
				if (!inTag) {
					index++;
				}
			}
			index++;
			message.text = currentMessage.substr(0, index);
		}
		
		private function generateMessages(strings:Vector.<String>):Vector.<String> {
			var messages:Vector.<String> = new Vector.<String>;
			var numLines:uint = getLineCount();
			var currentSet:Vector.<String> = new Vector.<String>;
			
			for each(var string:String in strings) {
				var lines:Vector.<AxTextLine> = AxText.split(string, font, box.width - (paddingLeft + paddingRight));
				currentSet.length = 0;
				
				for each(var line:AxTextLine in lines) {
					currentSet.push(line.text);
					if (currentSet.length == numLines) {
						messages.push(currentSet.join("\n"));
						currentSet.length = 0;
					}
				}
				
				if (currentSet.length > 0) {
					messages.push(currentSet.join("\n"));
				}
			}
			
			return messages;
		}
		
		private function getLineCount():uint {
			return Math.floor((box.height - (paddingTop + paddingBottom)) / (font.height + font.spacing.y));
		}
		
		override public function dispose():void {
			messages = null;
			font = null;
			super.dispose();
		}
	}
}
