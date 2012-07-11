package guice
{
	import model.IEngine;
	import model.RaceEngine;
	import model.RemoveableSteeringWheel;
	import model.SteeringWheel;
	
	import net.digitalprimates.guice.IGuiceModule;
	import net.digitalprimates.guice.binder.IBinder;
	
	public class RaceModule implements IGuiceModule {
		private var removeableSteeringWheel:RemoveableSteeringWheel;

		public function RaceModule( removeableSteeringWheel:RemoveableSteeringWheel ) {
			this.removeableSteeringWheel = removeableSteeringWheel;
		}
		
		public function configure(binder:IBinder):void {
			binder.bind( IEngine ).to( RaceEngine );
			binder.bind( SteeringWheel ).toInstance( removeableSteeringWheel );
		}
	}
}