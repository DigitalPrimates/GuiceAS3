package net.digitalprimates.guice.errors {
	import flex.lang.reflect.Klass;

	public class UnboundInterfaceError extends GuiceError {
		public function UnboundInterfaceError( type:Klass ) {
			super( "An object requires an unbound interface: " + type.asClass);
		}
	}
}