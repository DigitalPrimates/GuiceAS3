package guice {
	import model.Car;
	import model.ConsumerCar;
	import model.ElectricMotor;
	import model.IEngine;
	import model.LuxurySteeringWheel;
	import model.SteeringWheel;
	import model.radio.Radio;
	import model.radio.SuperCoolRadio;
	
	import net.digitalprimates.guice.IGuiceModule;
	import net.digitalprimates.guice.Scopes;
	import net.digitalprimates.guice.binder.IBinder;
	
	public class ElectricModule implements IGuiceModule {
		public function configure(binder:IBinder):void {
			binder.bind( Car ).to( ConsumerCar );
			binder.bind( IEngine ).to( ElectricMotor );
			binder.bind( SteeringWheel ).to( LuxurySteeringWheel );
			binder.bind( Radio ).inScope( Scopes.SINGLETON ).to( SuperCoolRadio );
		}
	}
}