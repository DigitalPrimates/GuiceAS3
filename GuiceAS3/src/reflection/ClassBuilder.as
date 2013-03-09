package reflection
{
	public class ClassBuilder
	{
		/**
		 * @private
		 */
		private static var argMap:Array = [ createInstance0, createInstance1, createInstance2, createInstance3, createInstance4, createInstance5, createInstance6, createInstance7, createInstance8, createInstance9, createInstance10 ];
		//okay, so AS doesn't really allow us to do an apply on the constructor, so we need to fake it
		/**
		 * @private
		 */
		private static function createInstance0( klass:Class ):* {
			return new klass();
		}
		
		/**
		 * @private
		 */
		private static function createInstance1( clazz:Class, arg1:* ):* {
			return new clazz( arg1 );
		}
		
		/**
		 * @private
		 */
		private static function createInstance2( clazz:Class, arg1:*, arg2:* ):* {
			return new clazz( arg1, arg2 );
		}
		
		/**
		 * @private
		 */
		private static function createInstance3( clazz:Class, arg1:*, arg2:*, arg3:* ):* {
			return new clazz( arg1, arg2, arg3 );
		}
		
		/**
		 * @private
		 */
		private static function createInstance4( clazz:Class, arg1:*, arg2:*, arg3:*, arg4:* ):* {
			return new clazz( arg1, arg2, arg3, arg4 );
		}
		
		/**
		 * @private
		 */
		private static function createInstance5( clazz:Class, arg1:*, arg2:*, arg3:*, arg4:*, arg5:* ):* {
			return new clazz( arg1, arg2, arg3, arg4, arg5 );
		}
		
		/**
		 * @private
		 */
		private static function createInstance6( clazz:Class, arg1:*, arg2:*, arg3:*, arg4:*, arg5:*, arg6:* ):* {
			return new clazz( arg1, arg2, arg3, arg4, arg5, arg6 );
		}
		
		/**
		 * @private
		 */
		private static function createInstance7( clazz:Class, arg1:*, arg2:*, arg3:*, arg4:*, arg5:*, arg6:*, arg7:* ):* {
			return new clazz( arg1, arg2, arg3, arg4, arg5, arg6, arg7 );
		}
		
		/**
		 * @private
		 */
		private static function createInstance8( clazz:Class, arg1:*, arg2:*, arg3:*, arg4:*, arg5:*, arg6:*, arg7:*, arg8:* ):* {
			return new clazz( arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8 );
		}
		
		/**
		 * @private
		 */
		private static function createInstance9( clazz:Class, arg1:*, arg2:*, arg3:*, arg4:*, arg5:*, arg6:*, arg7:*, arg8:*, arg9:* ):* {
			return new clazz( arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 );
		}
		
		/**
		 * @private
		 */
		private static function createInstance10( clazz:Class, arg1:*, arg2:*, arg3:*, arg4:*, arg5:*, arg6:*, arg7:*, arg8:*, arg9:*, arg10:* ):* {
			return new clazz( arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10 );
		}
		
		public static function newInstanceApply( typeDefinition:TypeDescription, params:Array ):Object {
			var constructorPoints:Vector.<InjectionPoint> = typeDefinition.constructorPoints;
			var generator:Function;

			if ( !params ) {
				//null should mean the same as no params
				params = [];
			}
			
			if ( !constructorPoints ) {
				generator = argMap[ 0 ];
				return generator.apply( null, [typeDefinition.type] );
			}
			
			//We do have some constructor points... welcome to the world of optional
			var localParams:Array = params.slice();

			var mapIndex : uint = Math.min( typeDefinition.constructorPoints.length, localParams.length );
			if ( localParams.length > argMap.length ) {
				throw new ArgumentError("Sorry, we can't support constructors with more than " + argMap.length + " args out of the box... yes, its dumb, take a look at Constructor.as to modify on your own");
			}

			if ( constructorPoints.length == localParams.length ) {
				//all is easy, do it!
				generator = argMap[ mapIndex ];
				localParams.unshift( typeDefinition.type );
				
				return generator.apply( null, localParams );
			}

			//Possible optional types.. ready?
			if ( localParams.length < typeDefinition.requiredConstructorArgCount || localParams.length > constructorPoints.length ) {
				throw new ArgumentError("Invalid number or type of arguments to contructor");
			}
			
			generator = argMap[ mapIndex ];
			localParams.unshift( typeDefinition.type );
			
			return generator.apply( null, localParams );
		}
		
		public static function methodApply( newInstance:*, methodName:String, invocationArgs:Array ):void {
			var method:Function = newInstance.methodName;
			
			if ( invocationArgs && ( invocationArgs.length > 0 ) ) {
				method.apply( newInstance, invocationArgs );
			} else {
				method.apply( newInstance );
			}
			
			newInstance.methodName.apply( newInstance, invocationArgs );
			
		}

		public function ClassBuilder()
		{
		}
	}
}