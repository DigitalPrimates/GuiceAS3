package integration.scenarios.classes.computer {
	public class Case {
		private var motherBoard:MotherBoard;
		private var drives:Array;
		private var powerSupply:PowerSupply;

		public function Case( motherBoard:MotherBoard, powerSupply:PowerSupply, drives:Array=null ) {
			this.motherBoard = motherBoard;
			this.powerSupply = powerSupply;
			this.drives = drives; 
		}
	}
}