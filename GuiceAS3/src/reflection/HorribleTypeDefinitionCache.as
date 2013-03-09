package reflection
{
	import flash.utils.Dictionary;

	public class HorribleTypeDefinitionCache {
		private static var cache:Dictionary = new Dictionary();

		public static function getForInstance( instance:* ):TypeDescription {
			return null;
		}

		public static function get( type:Class ):TypeDescription {
			var instance:TypeDescription = cache[ type ];
			
			if ( !instance ) {
				instance = cache[ type ] = new TypeDescription( type );
			}
			
			return instance;
		}
	}
}