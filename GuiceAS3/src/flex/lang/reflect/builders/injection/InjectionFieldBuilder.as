package flex.lang.reflect.builders.injection {
	import net.digitalprimates.guice.GuiceAnnotations;
	
	import flex.lang.reflect.Field;
	import flex.lang.reflect.InjectionClass;

	public class InjectionFieldBuilder {
		/**
		 * @private
		 */
		private var classXML:XML;
		/**
		 * @private
		 */
		private var klass:InjectionClass;
		
		/**
		 * Builds all field objects from the provided XML 
		 * @return an Array of fields
		 * 
		 */		
		public function buildAllFields():Array {
			var fields:Array = new Array();
			var variableList:XMLList = classXML.factory.variable;			
			var metaDataList:XMLList;
			
			metaDataList = variableList..metadata.(@name==GuiceAnnotations.INJECT);

			for ( var i:int=0; i<metaDataList.length(); i++ ) {
				fields.push( new Field( metaDataList[ i ].parent(), false, klass, false ) );
			}
			
			var propertyList:XMLList = classXML.factory.accessor;			
			metaDataList = propertyList..metadata.(@name==GuiceAnnotations.INJECT);
			
			for ( var k:int=0; k<metaDataList.length(); k++ ) {
				fields.push( new Field( metaDataList[ k ].parent(), true, klass, true ) );
			}
			
			return fields;
		}
		
		/**
		 * 
		 * @param classXML
		 * @param clazz
		 * 
		 */		
		public function InjectionFieldBuilder( classXML:XML, klass:InjectionClass ) {
			this.classXML = classXML;
			this.klass = klass; 			
		}
	}
}