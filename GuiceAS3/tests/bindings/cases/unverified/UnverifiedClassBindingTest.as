package bindings.cases.unverified {
	import bindings.helpers.ThingyImpl;
	
	import flash.display.Sprite;
	
	import mockolate.mock;
	import mockolate.runner.MockolateRule;
	import mockolate.stub;
	
	import net.digitalprimates.guice.Injector;
	import net.digitalprimates.guice.binding.unverified.UnverifiedClassBinding;
	
	import org.flexunit.asserts.assertStrictlyEquals;

	public class UnverifiedClassBindingTest {
		[Rule]
		public var mockRule:MockolateRule = new MockolateRule();
		
		[Mock(type="strict")]
		public var injector:Injector;
		
		[Test]
		public function shouldPassNullToInjector():void {
			var binding:UnverifiedClassBinding = new UnverifiedClassBinding( null, null, null );
			
			mock( injector ).method( "buildClass" ).args( null ).once();
			
			binding.provide( injector );
		}
		
		[Test]
		public function shouldPassSpriteToInjector():void {
			var binding:UnverifiedClassBinding = new UnverifiedClassBinding( null, null, "flash.display::Sprite" );
			
			mock( injector ).method( "buildClass" ).args( Sprite ).once();
			
			binding.provide( injector );
		}		
		
		[Test]
		public function shouldReturnThingyInstance():void {
			var binding:UnverifiedClassBinding = new UnverifiedClassBinding( null, null, null );
			var thingy:ThingyImpl = new ThingyImpl();
			
			stub( injector ).method( "buildClass" ).returns( thingy );
			
			assertStrictlyEquals( thingy, binding.provide( injector ) );
		}	
		
		[Test]
		public function shouldPassVerificationWithActualType():void {
			var binding:UnverifiedClassBinding = new UnverifiedClassBinding( "bindings.helpers::ThingyImpl", null, "bindings.helpers::ThingyImpl" );
			binding.verify();
		}		
		
		[Test]
		public function shouldPassVerificationWithMismatchType():void {
			var binding:UnverifiedClassBinding = new UnverifiedClassBinding( "bindings.helpers::ThingyImpl", null, "bindings.helpers::NotThingy" );
			binding.verify();
		}		
	}
}