package reflection
{
	public class MethodInjectionPoint
	{
		public var name:String;
		public var annotation:String;
		public var parameters:Vector.<InjectionPoint>;	
		
		public function MethodInjectionPoint( name:String, annotation:String, parameters:Vector.<InjectionPoint> ) {
			this.name = name;
			this.annotation = annotation;
			this.parameters = parameters;
		}
	}
}