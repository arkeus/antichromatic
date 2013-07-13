package {
	import io.arkeus.antichromatic.title.InitializationState;
	
	import org.axgl.Ax;

	public class Antichromatic extends Ax {
		public function Antichromatic() {
			super(InitializationState, 360, 300, 1, 60, true);
		}
		
		override public function create():void {
			Ax.unfocusedFramerate = 60;
			debuggerEnabled = true;
			//debugger.active = true;
		}
	}
}
