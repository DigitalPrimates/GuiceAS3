package reflection
{
	import avmplus.DescribeTypeJson;
	
	import flash.utils.Dictionary;

	public class HorribleJSONCache {
		private static var cache:Dictionary = new Dictionary();

		public static function getForInstance( instance:* ):TypeDescription {
			return null;
		}

		public static function get( type:Class ):Object {
			var instance:Object = cache[ type ];
			
			if ( !instance ) {
				instance = cache[ type ] = DescribeTypeJson.describeTypeForGuice( type );
			}
			
			return instance;
		}
	}
}