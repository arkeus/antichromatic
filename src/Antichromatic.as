package {
	import io.arkeus.antichromatic.title.TitleState;
	
	import org.axgl.Ax;
	
	[SWF(width = "720", height = "600", backgroundColor = "#777777")]

	public class Antichromatic extends Ax {
		public function Antichromatic() {
			super(TitleState, 720, 600, 2, 60, true);
		}
		
		override public function create():void {
			Ax.unfocusedFramerate = 60;
			//debuggerEnabled = true;
			//debugger.active = true;
		}
	}
}
