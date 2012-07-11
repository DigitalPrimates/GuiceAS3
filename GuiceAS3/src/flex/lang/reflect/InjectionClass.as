package flex.lang.reflect {
	import flash.system.ApplicationDomain;
	
	import flex.lang.reflect.builders.injection.InjectionFieldBuilder;
	import flex.lang.reflect.builders.injection.InjectionMethodBuilder;
	import flex.lang.reflect.cache.ClassDataCache;

	public class InjectionClass extends Klass {

		
		/**
		 * @private
		 */
		private var _methods:Array;
		
		override public function get methods():Array {
			if ( !_methods ) {
				var methodBuilder:InjectionMethodBuilder = new InjectionMethodBuilder( classXML, classInheritance, this );
				_methods = methodBuilder.buildAllMethods();
			}
			return _methods;
		}

		/**
		 * @private
		 */
		private var _fields:Array;
		
		override public function get fields():Array {
			if (!_fields ) {
				var fieldBuilder:InjectionFieldBuilder = new InjectionFieldBuilder( classXML, this );
				_fields = fieldBuilder.buildAllFields();
			}
			
			return _fields;
		}
		
		public function InjectionClass( clazz:Class, applicationDomain:ApplicationDomain=null ) {
			super( clazz, applicationDomain );
			
			var localXML:XML = classXML;
		}
		
	}
}