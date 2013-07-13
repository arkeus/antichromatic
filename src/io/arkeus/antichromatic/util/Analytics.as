package io.arkeus.antichromatic.util {
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	
	import org.axgl.Ax;

	public class Analytics {
		private static var tracker:AnalyticsTracker;
		private static var enabled:Boolean = false;
		
		public static function initialize():void {
			enabled = true;
			tracker = new GATracker(Ax.stage2D, "UA-40922558-1", "AS3", false);
			view("");
			trackReferral();
		}
		
		public static function view(page:String):void {
			if (!enabled) {
				return;
			}
			
			try {
				page = "/" + page;
				tracker.trackPageview(page);
				Ax.logger.info("Viewed page " + page);
			} catch (error:Error) {
				Ax.logger.error("Error viewing page " + page + ": " + error.message);
			}
		}
		
		public static function event(category:String, action:String, label:String = null, value:Number = NaN):void {
			if (!enabled) {
				return;
			}
			
			try {
				tracker.trackEvent(category, action, label, value);
				Ax.logger.info("Sent event " + category + ":" + action);
			} catch (error:Error) {
				Ax.logger.error("Error sending event " + category + ":" + action + ": " + error.message);
			}
		}
		
		private static function trackReferral():void {
			if (!enabled) {
				return;
			}
			
			var url:String = "OUYA";
			view("refer/?page=" + url);
			event("refer", url);
		}
	}
}
