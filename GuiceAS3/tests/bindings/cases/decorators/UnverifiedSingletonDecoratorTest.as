package bindings.cases.decorators {

	import bindings.helpers.ThingyImpl;
	
	import mockolate.mock;
	import mockolate.runner.MockolateRule;
	
	import net.digitalprimates.guice.IProvider;
	import net.digitalprimates.guice.Injector;
	import net.digitalprimates.guice.binding.IBinding;
	import net.digitalprimates.guice.binding.IVerifiedBinding;
	import net.digitalprimates.guice.binding.decoration.UnverifiedSingletonDecorator;
	import net.digitalprimates.guice.binding.decoration.VerifiedSingletonDecorator;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertStrictlyEquals;

	public class UnverifiedSingletonDecoratorTest {
		[Rule]
		public var mockRule:MockolateRule = new MockolateRule();
		
		[Mock(type="strict")]
		public var injector:Injector;
		
		[Mock(type="strict")]
		public var binding:IBinding;
		
		private var annotation:String = "Annotated";
		
		[Test]
		public function shouldReturnBindingAsDecorating():void {
			var decorator:UnverifiedSingletonDecorator = new UnverifiedSingletonDecorator( binding );
			
			assertStrictlyEquals( binding, decorator.decorating );
		}		
		
		[Test]
		public function shouldReturnBindingAnnotation():void {
			var decorator:UnverifiedSingletonDecorator = new UnverifiedSingletonDecorator( binding );
			
			mock( binding ).getter( "annotation" ).returns( annotation ).once();
			assertEquals( annotation, decorator.annotation );
		}		
		
		[Test]
		public function shouldReturnSetBindingAnnotation():void {
			var decorator:UnverifiedSingletonDecorator = new UnverifiedSingletonDecorator( binding );
			
			mock( binding ).setter( "annotation" ).arg( annotation ).once();
			decorator.annotation = annotation;
		}		
		
		[Test]
		public function shouldReturnBindingType():void {
			var decorator:UnverifiedSingletonDecorator = new UnverifiedSingletonDecorator( binding );
			
			mock( binding ).getter( "typeName" ).returns( "String" ).once();
			assertEquals( "String", decorator.typeName );
		}		
		
		[Test]
		public function shouldReturnSetBindingType():void {
			var decorator:UnverifiedSingletonDecorator = new UnverifiedSingletonDecorator( binding );
			
			mock( binding ).setter( "typeName" ).arg( "String" ).once();
			decorator.typeName = "String";
		}		
		
		[Test]
		public function shouldCallBindingVerify():void {
			var decorator:UnverifiedSingletonDecorator = new UnverifiedSingletonDecorator( binding );
			
			mock( binding ).method( "verify" ).noArgs().once();
			decorator.verify();
		}			
		
		[Test]
		public function shouldCallBindingProvideOnlyOnce():void {
			var decorator:UnverifiedSingletonDecorator = new UnverifiedSingletonDecorator( binding );
			var instance:* = new ThingyImpl();
			
			mock( binding ).method( "provide" ).args( injector ).returns( instance ).once();
			
			assertStrictlyEquals( instance, decorator.provide( injector ) ); 
			assertStrictlyEquals( instance, decorator.provide( injector ) ); 
			assertStrictlyEquals( instance, decorator.provide( injector ) ); 
			assertStrictlyEquals( instance, decorator.provide( injector ) ); 
		}	
	}
}