package model {
	public class RaceEngine extends CombustionEngine {
		private var plug5:SparkPlug;
		private var plug6:SparkPlug;
		
		
		override public function rev( amount:Number ):void {
			trace("Using really using fuel now that I rev to " + amount );
		}
		
		public function RaceEngine(plug1:SparkPlug, plug2:SparkPlug, plug3:SparkPlug, plug4:SparkPlug, plug5:SparkPlug, plug6:SparkPlug ) {
			super(plug1, plug2, plug3, plug4);
			
			this.plug5 = plug5;
			this.plug6 = plug6;

		}
	}
}