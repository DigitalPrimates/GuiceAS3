package model {
	

	public class Car {
		private var engine:IEngine;
		private var steeringWheel:SteeringWheel;

		public function start():void {
			engine.start();
		}
		
		public function accelerate( amount:Number ):void {
			engine.rev( amount );
		}
		
		public function cease():void {
			engine.cease();
		}
		
		public function Car( engine:IEngine, steeringWheel:SteeringWheel ){
			this.engine = engine;
			this.steeringWheel = steeringWheel;
		}
	}
}