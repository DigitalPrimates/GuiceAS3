package integration.scenarios.classes.computer {
	public class PowerSupply {
		private var fan:IFan;

		public function PowerSupply( fan:IFan ) {
			this.fan = fan;
		}
	}
}