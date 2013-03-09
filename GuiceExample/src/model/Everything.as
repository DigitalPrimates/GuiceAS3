package model
{
	import model.radio.Radio;

	public class Everything
	{
		private var engine:IEngine;
		private var steeringWheel:SteeringWheel;

		[Inject]
		public var radio:Radio;

		[Inject]
		public function set parkingBreak( value:ParkingBreak ):void {
			
		}

		[Inject("gary")]
		public function setCupHolder( cupHolder1:BigCupHolder, cupholder2:SmallCupHolder ):void {
			
		}
		
		public function Everything(engine:IEngine, steeringWheel:SteeringWheel)
		{
			this.engine = engine;
			this.steeringWheel = steeringWheel;
			
		}
	}
}