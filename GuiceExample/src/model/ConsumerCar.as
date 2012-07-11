package model
{
	import model.radio.Radio;
	
	public class ConsumerCar extends Car {
		private var radio:Radio;

		public function ConsumerCar(engine:IEngine, steeringWheel:SteeringWheel, radio:Radio) {
			super(engine, steeringWheel );
			this.radio = radio;
		}
	}
}