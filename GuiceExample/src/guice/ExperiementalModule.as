package guice {
	import model.Car;
	import model.CombustionEngine;
	import model.ConsumerCar;
	import model.IEngine;
	import model.radio.Radio;
	import model.radio.RoundRadio;
	
	import net.digitalprimates.guice.IGuiceModule;
	import net.digitalprimates.guice.Scopes;
	import net.digitalprimates.guice.binder.IBinder;
	
	public class ExperimentalModule implements IGuiceModule {		
		public function configure(binder:IBinder):void {
			binder.bind( Car ).to( ConsumerCar );
			binder.bind( IEngine ).to( CombustionEngine );
			binder.bind( Radio ).inScope( Scopes.SINGLETON ).to( RoundRadio );
		}
	}
}