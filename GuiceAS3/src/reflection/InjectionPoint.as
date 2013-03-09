package reflection {
	public class InjectionPoint {
		
		public var optional:Boolean = true;
		public var type:Class;
		public var name:String;
		public var annotation:String;
		
		public function InjectionPoint( type:Class, optional:Boolean=true, name:String="", annotation:String="" ) {
			this.name = name;
			this.type = type;
			this.optional = optional;
			this.annotation = annotation;
		}
	}
}