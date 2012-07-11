package model
{
	public class CombustionEngine implements IEngine {
		private var plug1:SparkPlug;
		private var plug2:SparkPlug;
		private var plug3:SparkPlug;
		private var plug4:SparkPlug;
		
		public function start():void {
			trace("CombustionEngine Starting");
		}

		public function rev( amount:Number ):void {
			trace("Using Gas as I Rev to " + amount );
		}

		public function cease():void {
			trace("CombustionEngine Ceasing");
		}
		
		public function CombustionEngine( plug1:SparkPlug, plug2:SparkPlug, plug3:SparkPlug, plug4:SparkPlug) {
			this.plug1 = plug1;
			this.plug2 = plug2;
			this.plug3 = plug3;
			this.plug4 = plug4;
		}
	}
}