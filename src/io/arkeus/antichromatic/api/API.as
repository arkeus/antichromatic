package io.arkeus.antichromatic.api {
	import flash.utils.getQualifiedClassName;

	public class API {
		public function API() {
			trace("Initializing connect for " + getQualifiedClassName(this));
			connect();
		}
		
		public function connect():void {}; // abstract
		public function sendAll():void {};
	}
}
