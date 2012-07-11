package flex.lang.reflect.constructor {
	public class ConstructorArg {
		private var _type:Class;
		private var _required:Boolean;

		public function get required():Boolean {
			return _required;
		}

		public function set required(value:Boolean):void {
			_required = value;
		}

		public function get type():Class {
			return _type;
		}

		public function set type(value:Class):void {
			_type = value;
		}

		public function ConstructorArg( type:Class, required:Boolean = true ) {
			this.type = type;
			this.required = required;
		}
	}
}