package model {
	public class ElectricMotor implements IEngine {
		public function start():void {
			trace("Electric Motor Starting");
		}
		
		public function rev(amount:Number):void {
			trace("Battery Draining as I rev to " + amount );
		}
		
		public function cease():void {
			trace("Electric Motor Ceasing");
		}
		
		public function ElectricMotor()
		{
		}
	}
}