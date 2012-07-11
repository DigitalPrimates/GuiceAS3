package bindings.cases.verified {
	import bindings.helpers.IThingy;
	import bindings.helpers.NotThingy;
	import bindings.helpers.ThingyImpl;
	
	import net.digitalprimates.guice.binding.verified.VerifiedInstanceBinding;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertStrictlyEquals;

	public class VerifiedInstanceBindingTest {
		[Test]
		public function shouldReturnNullAsInstance():void {
			var binding:VerifiedInstanceBinding = new VerifiedInstanceBinding( null, null, null );
			assertNull( binding.provide( null ) );
		}

		[Test]
		public function shouldReturnThingyAsInstance():void {
			var thingy:ThingyImpl = new ThingyImpl();
			var binding:VerifiedInstanceBinding = new VerifiedInstanceBinding( null, null, thingy );
			
			assertStrictlyEquals( thingy, binding.provide( null ) );
		}

		[Test]
		public function shouldVerifyInstanceAsValidInterfaceType():void {
			var thingy:ThingyImpl = new ThingyImpl();
			var binding:VerifiedInstanceBinding = new VerifiedInstanceBinding( IThingy, null, thingy );

			binding.verify();
		}

		[Test]
		public function shouldVerifyInstanceAsValidConcreteType():void {
			var thingy:ThingyImpl = new ThingyImpl();
			var binding:VerifiedInstanceBinding = new VerifiedInstanceBinding( ThingyImpl, null, thingy );
			
			binding.verify();
		}

		[Test]
		public function shouldFailMistmatchType():void {
			var thingy:ThingyImpl = new ThingyImpl();
			var binding:VerifiedInstanceBinding = new VerifiedInstanceBinding( NotThingy, null, thingy );

			try {
				binding.verify();
			}
			catch ( error:Error ) {
				assertEquals( error.message, "Error attempting to bind [object ThingyImpl] to [class NotThingy]" );  
			}			
		}

	}
}