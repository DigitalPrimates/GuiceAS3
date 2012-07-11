package bindings.helpers.providers {
	import net.digitalprimates.guice.IProvider;

	public class ProviderMissingAnnotation implements IProvider {
		public function ProviderMissingAnnotation() {
		}
		
		public function get():* {
			return null;
		}
	}
}