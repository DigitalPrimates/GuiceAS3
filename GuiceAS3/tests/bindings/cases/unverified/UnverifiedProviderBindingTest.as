package bindings.cases.unverified {
	import bindings.helpers.ThingyImpl;
	import bindings.helpers.providers.ProviderMissingAnnotation;
	import bindings.helpers.providers.ProviderWithInvalidClass;
	import bindings.helpers.providers.ValidStringProvider;
	
	import flash.display.Sprite;
	
	import mockolate.mock;
	import mockolate.runner.MockolateRule;
	
	import net.digitalprimates.guice.IProvider;
	import net.digitalprimates.guice.Injector;
	import net.digitalprimates.guice.binding.unverified.UnverifiedProviderBinding;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertStrictlyEquals;

	public class UnverifiedProviderBindingTest {
		
		[Rule]
		public var mockRule:MockolateRule = new MockolateRule();
		
		[Mock(type="strict")]
		public var injector:Injector;
		
		[Mock(type="strict")]
		public var provider:IProvider;
		
		[Test]
		public function shouldReturnNullAsProvider():void {
			var binding:UnverifiedProviderBinding = new UnverifiedProviderBinding( null, null, null );
			
			mock( injector ).method( "getInstance" ).args( null ).returns( provider ).once();
			mock( provider ).method( "get" ).noArgs();
			
			binding.provide( injector );
		}
		
		[Test]
		public function shouldReturnProviderMockAsProvider():void {
			var binding:UnverifiedProviderBinding = new UnverifiedProviderBinding( null, null, ValidStringProvider );
			
			mock( injector ).method( "getInstance" ).args( ValidStringProvider ).returns( provider ).once();
			mock( provider ).method( "get" ).noArgs();
			
			binding.provide( injector );
		}
		
		[Test]
		public function shouldReturnProvideInstanceFromProvider():void {
			var binding:UnverifiedProviderBinding = new UnverifiedProviderBinding( null, null, ValidStringProvider );
			var thingyImpl:ThingyImpl = new ThingyImpl();
			
			mock( injector ).method( "getInstance" ).args( ValidStringProvider ).returns( provider ).once();
			mock( provider ).method( "get" ).noArgs().returns( thingyImpl );
			
			assertStrictlyEquals( thingyImpl, binding.provide( injector ) );
		}
		
		[Test]
		public function shouldPassVerificationWithValidProvider():void {
			var binding:UnverifiedProviderBinding = new UnverifiedProviderBinding( "String", null, ValidStringProvider );
			binding.verify();
		}		
		
		[Test]
		public function shouldFailVerificationWhenNotIProvider():void {
			try {
				var binding:UnverifiedProviderBinding = new UnverifiedProviderBinding( "String", null, ThingyImpl );
				binding.verify();
			}
			catch ( error:Error ) {
				assertEquals( error.message, "Error attempting to provider bind class that does not implement IProvider to [class String]" );  
			}
		}		
		
		[Test]
		public function shouldFailVerificationWithoutAnnotation():void {
			try {
				var binding:UnverifiedProviderBinding = new UnverifiedProviderBinding( "String", null, ProviderMissingAnnotation );
				binding.verify();
			}
			catch ( error:Error ) {
				assertEquals( error.message, "Error attempting to provider bind class that does not have Provider metadata to [class String]" );  
			}
		}		
		
		[Test]
		public function shouldFailVerificationWithoutValidClass():void {
			try {
				var binding:UnverifiedProviderBinding = new UnverifiedProviderBinding( "String", null, ProviderWithInvalidClass );
				binding.verify();
			}
			catch ( error:Error ) {
				assertEquals( error.message, "Cannot find the class definition a.b.c provided by Provider for [class String]" );  
			}
		}		
		
		[Test]
		public function shouldFailVerificationWhenClassProvidesIncorrectly():void {
			try {
				var binding:UnverifiedProviderBinding = new UnverifiedProviderBinding( "flash.display.Sprite", null, ValidStringProvider );
				binding.verify();
			}
			catch ( error:Error ) {
				assertEquals( error.message, "Error attempting to bind [class String] to [class flash.display.Sprite]" );  
			}
		}		
		

	}
}