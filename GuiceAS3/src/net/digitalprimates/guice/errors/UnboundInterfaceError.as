package net.digitalprimates.guice.errors {
	import reflection.TypeDescription;

	public class UnboundInterfaceError extends GuiceError {
		public function UnboundInterfaceError( typeDef:TypeDescription ) {
			super( "An object requires an unbound interface: " + typeDef.type );
		}
	}
}