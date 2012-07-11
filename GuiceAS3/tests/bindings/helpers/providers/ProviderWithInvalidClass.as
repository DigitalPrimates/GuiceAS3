package bindings.helpers.providers {
	import net.digitalprimates.guice.IProvider;

	[Provides("a.b.c")]
	public class ProviderWithInvalidClass implements IProvider {
		public function ProviderWithInvalidClass() {
		}
		
		public function get():* {
			return "ValidString";
		}
	}
}