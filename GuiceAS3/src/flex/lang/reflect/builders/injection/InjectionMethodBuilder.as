package flex.lang.reflect.builders.injection {
	import net.digitalprimates.guice.GuiceAnnotations;
	
	import flex.lang.reflect.InjectionClass;
	import flex.lang.reflect.Method;
	import flex.lang.reflect.cache.ClassDataCache;
	import flex.lang.reflect.utils.MetadataTools;

	public class InjectionMethodBuilder {
		/**
		 * @private
		 */		
		private var classXML:XML;
		/**
		 * @private
		 */		
		private var inheritance:Array;
		/**
		 * @private
		 */		
		private var methodMap:Object;
		private var parentKlass:InjectionClass;
		
		/**
		 * @private
		 */		
		private function buildMethod( methodData:XML, isStatic:Boolean ):Method {
			return new Method( methodData, parentKlass, isStatic );
		}
		
		/**
		 * @private
		 */
		private function buildMethods( parentBlock:XML, isStatic:Boolean = false ):Array {
			var methods:Array = new Array();
			var methodList:XMLList = new XMLList();
			var metaDataList:XMLList;
			
			if ( parentBlock ) {
				methodList = parentBlock.method;
				metaDataList = methodList..metadata.(@name==GuiceAnnotations.INJECT);
			}
			
			for ( var i:int=0; i<metaDataList.length(); i++ ) {
				methods.push( buildMethod( metaDataList[ i ].parent(), isStatic ) );
			}
			
			return methods;
		}
		
		/**
		 * Builds all Methods in this class, considering methods defined or overriden in this class and through inheritance		  
		 * @return An array of Method instances
		 * 
		 */		
		public function buildAllMethods():Array {
			var methods:Array = new Array();
			var method:Method;
			
			if ( classXML.factory ) {
				methods = methods.concat( buildMethods( classXML.factory[ 0 ], false ) );
			}

			return methods;
		}
		
		/**
		 * Resposible for building method instances from XML descriptions 
		 * @param classXML
		 * @param inheritance
		 * 
		 */		
		public function InjectionMethodBuilder( classXML:XML, inheritance:Array, parentKlass:InjectionClass ) {
			this.classXML = classXML;
			this.inheritance = inheritance; 
			this.parentKlass = parentKlass;
			
			methodMap = new Object();
		}
	}
}