package org.axgl.plus.message {
	import org.axgl.Ax;

	public class AxMessage {
		private static var defaultOptions:Object = {};
		
		public static function show(messages:*, options:Object = null):void {
			Ax.pushState(new AxMessageState(messages, options ? options : defaultOptions));
		}
		
		public static function setDefaultOptions(options:Object):void {
			if (options == null) {
				return;
			}
			defaultOptions = options;
		}
	}
}
