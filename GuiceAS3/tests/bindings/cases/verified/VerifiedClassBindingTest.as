package bindings.cases.verified {
	import bindings.helpers.IThingy;
	import bindings.helpers.NotThingy;
	import bindings.helpers.SubThingyImpl;
	import bindings.helpers.ThingyImpl;
	
	import flash.display.Sprite;
	
	import mockolate.mock;
	import mockolate.runner.MockolateRule;
	import mockolate.stub;
	
	import net.digitalprimates.guice.IInjector;
	import net.digitalprimates.guice.Injector;
	import net.digitalprimates.guice.binding.verified.VerifiedClassBinding;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertStrictlyEquals;

	public class VerifiedClassBindingTest {
		
		[Rule]
		public var mockRule:MockolateRule = new MockolateRule();

		[Mock(type="strict")]
		public var injector:Injector;

		[Test]
		public function shouldPassNullToInjector():void {
			var binding:VerifiedClassBinding = new VerifiedClassBinding( null, null, null );
			
			mock( injector ).method( "buildClass" ).args( null ).once();
			
			binding.provide( injector );
		}
		
		[Test]
		public function shouldPassSpriteToInjector():void {
			var binding:VerifiedClassBinding = new VerifiedClassBinding( null, null, Sprite );
			
			mock( injector ).method( "buildClass" ).args( Sprite ).once();
			
			binding.provide( injector );
		}		

		[Test]
		public function shouldReturnThingyInstance():void {
			var binding:VerifiedClassBinding = new VerifiedClassBinding( null, null, null );
			var thingy:ThingyImpl = new ThingyImpl();

			stub( injector ).method( "buildClass" ).returns( thingy );
			
			assertStrictlyEquals( thingy, binding.provide( injector ) );
		}	

		[Test]
		public function shouldPassVerificationWithActualType():void {
			var binding:VerifiedClassBinding = new VerifiedClassBinding( ThingyImpl, null, ThingyImpl );
			binding.verify();
		}		

		[Test]
		public function shouldPassVerificationWithInterface():void {
			var binding:VerifiedClassBinding = new VerifiedClassBinding( IThingy, null, ThingyImpl );
			binding.verify();
		}		

		[Test]
		public function shouldPassVerificationWithSubclass():void {
			var binding:VerifiedClassBinding = new VerifiedClassBinding( ThingyImpl, null, SubThingyImpl );
			binding.verify();
		}		
		
		[Test]
		public function shouldFailVerificationWithMismatchType():void {
			try {
				var binding:VerifiedClassBinding = new VerifiedClassBinding( ThingyImpl, null, NotThingy );
				binding.verify();
			}
			catch ( error:Error ) {
				assertEquals( error.message, "Error attempting to bind [class NotThingy] to [class ThingyImpl]" );  
			}
		}		
		
		[Test]
		public function shouldFailVerificationWithNonImplementedInterface():void {
			try {
				var binding:VerifiedClassBinding = new VerifiedClassBinding( IThingy, null, NotThingy );
				binding.verify();
			}
			catch ( error:Error ) {
				assertEquals( error.message, "Error attempting to bind [class NotThingy] to [class IThingy]" );  

			}			
		}		
	}
}