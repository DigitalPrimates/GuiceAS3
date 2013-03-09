package avmplus {
	public class DescribeTypeJson {
/*
		public static const INSTANCE_FLAGS:uint = INCLUDE_BASES | INCLUDE_INTERFACES
			| INCLUDE_VARIABLES | INCLUDE_ACCESSORS | INCLUDE_METHODS | INCLUDE_METADATA
			| INCLUDE_CONSTRUCTOR | INCLUDE_TRAITS | USE_ITRAITS | HIDE_OBJECT;
		public static const CLASS_FLAGS:uint = INCLUDE_INTERFACES | INCLUDE_VARIABLES
			| INCLUDE_ACCESSORS | INCLUDE_METHODS | INCLUDE_METADATA | INCLUDE_TRAITS | HIDE_OBJECT
			
			
		public static const INSTANCE_FLAGS:uint = INCLUDE_BASES | INCLUDE_INTERFACES
			| INCLUDE_VARIABLES | INCLUDE_ACCESSORS | INCLUDE_METHODS | INCLUDE_METADATA
			| INCLUDE_CONSTRUCTOR | INCLUDE_TRAITS | USE_ITRAITS | HIDE_OBJECT;

		INCLUDE_BASES | INCLUDE_INTERFACES | INCLUDE_VARIABLES | INCLUDE_ACCESSORS | INCLUDE_METHODS | INCLUDE_METADATA | INCLUDE_CONSTRUCTOR | INCLUDE_TRAITS | USE_ITRAITS
*/			
		public static const CLASS_FLAGS:uint = INCLUDE_BASES | INCLUDE_INTERFACES | INCLUDE_VARIABLES | INCLUDE_ACCESSORS | INCLUDE_METHODS | INCLUDE_METADATA | INCLUDE_CONSTRUCTOR | INCLUDE_TRAITS | USE_ITRAITS | HIDE_OBJECT;
		

		public function describeType(target : Object, flags : uint) : Object
		{
			return describeTypeJSON(target, flags);
		}

		public static function describeTypeForGuice(target : Object) : Object
		{
			return describeTypeJSON(target, CLASS_FLAGS );
		}

		public function DescribeTypeJson()
		{
		}
	}
}