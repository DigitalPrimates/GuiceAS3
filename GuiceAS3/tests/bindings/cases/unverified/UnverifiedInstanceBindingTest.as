package bindings.cases.unverified {
	import bindings.helpers.IThingy;
	import bindings.helpers.NotThingy;
	import bindings.helpers.ThingyImpl;
	
	import net.digitalprimates.guice.binding.unverified.UnverifiedInstanceBinding;
	import net.digitalprimates.guice.binding.verified.VerifiedInstanceBinding;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertStrictlyEquals;

	public class UnverifiedInstanceBindingTest {
		[Test]
		public function shouldReturnNullAsInstance():void {
			var binding:UnverifiedInstanceBinding = new UnverifiedInstanceBinding( null, null, null );
			assertNull( binding.provide( null ) );
		}
		
		[Test]
		public function shouldReturnThingyAsInstance():void {
			var thingy:ThingyImpl = new ThingyImpl();
			var binding:UnverifiedInstanceBinding = new UnverifiedInstanceBinding( null, null, thingy );
			
			assertStrictlyEquals( thingy, binding.provide( null ) );
		}
		
		[Test]
		public function shouldVerifyPassVerificationAlways():void {
			var thingy:ThingyImpl = new ThingyImpl();
			var binding:UnverifiedInstanceBinding = new UnverifiedInstanceBinding( "this.non.existant.thing", null, thingy );
			
			binding.verify();

			var binding1:UnverifiedInstanceBinding = new UnverifiedInstanceBinding( "this.non.existant.thing", null, [] );
			
			binding1.verify();
		}
	}
}