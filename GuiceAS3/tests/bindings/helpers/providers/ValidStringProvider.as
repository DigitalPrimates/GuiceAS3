package bindings.helpers.providers {
	import net.digitalprimates.guice.IProvider;
	
	[Provides("String")]
	public class ValidStringProvider implements IProvider {
		public function ValidStringProvider() {
		}
		
		public function get():* {
			return "ValidString";
		}
	}
}