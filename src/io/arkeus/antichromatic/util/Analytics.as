package io.arkeus.antichromatic.util {
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	
	import flash.external.ExternalInterface;
	
	import org.axgl.Ax;

	public class Analytics {
		private static var tracker:AnalyticsTracker;
		
		public static function initialize():void {
			tracker = new GATracker(Ax.stage2D, "UA-40922558-1", "AS3", false);
			view("");
			trackReferral();
		}
		
		public static function view(page:String):void {
			try {
				page = "/" + page;
				tracker.trackPageview(page);
				Ax.logger.info("Viewed page " + page);
			} catch (error:Error) {
				Ax.logger.error("Error viewing page " + page + ": " + error.message);
			}
		}
		
		public static function event(category:String, action:String, label:String = null, value:Number = NaN):void {
			try {
				tracker.trackEvent(category, action, label, value);
				Ax.logger.info("Sent event " + category + ":" + action);
			} catch (error:Error) {
				Ax.logger.error("Error sending event " + category + ":" + action + ": " + error.message);
			}
		}
		
		private static function trackReferral():void {
			var url:String = getUrl();
			view("refer/?page=" + url);
			event("refer", url);
		}
		
		private static function getUrl():String {
			var page:String = "Unknown";
			try {
				page = ExternalInterface.call('window.location.href.toString');
			} catch (error:Error) {
				Ax.logger.error("External interface could not call window location: " + error.message);
				try {
					page = Ax.stage2D.loaderInfo.url;
				} catch (error:Error) {
					Ax.logger.error("Could not get url from loaderInfo: " + error.message);
				}
			}
			return page;
		}
	}
}
