package integration.scenarios.classes.computer {

	[Constructor(index=0,annotation="processorLabel")]
	public class Processor {
		private var designation:String;

		public function Processor( designation:String ) {
			this.designation = designation;
		}
	}
}