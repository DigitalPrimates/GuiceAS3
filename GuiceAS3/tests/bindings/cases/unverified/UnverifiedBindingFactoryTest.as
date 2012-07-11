package bindings.cases.unverified {

	import bindings.helpers.IThingy;
	import bindings.helpers.ThingyImpl;
	import bindings.helpers.providers.ValidStringProvider;
	
	import mockolate.mock;
	import mockolate.runner.MockolateRule;
	
	import net.digitalprimates.guice.Binder;
	import net.digitalprimates.guice.Scopes;
	import net.digitalprimates.guice.binding.IBinding;
	import net.digitalprimates.guice.binding.decoration.IBindingDecorator;
	import net.digitalprimates.guice.binding.decoration.UnverifiedSingletonDecorator;
	import net.digitalprimates.guice.binding.unverified.UnverifiedBindingFactory;
	import net.digitalprimates.guice.binding.unverified.UnverifiedClassBinding;
	import net.digitalprimates.guice.binding.unverified.UnverifiedInstanceBinding;
	import net.digitalprimates.guice.binding.unverified.UnverifiedProviderBinding;
	import net.digitalprimates.guice.binding.verified.VerifiedBindingFactory;
	import net.digitalprimates.guice.binding.verified.VerifiedClassBinding;
	import net.digitalprimates.guice.binding.verified.VerifiedInstanceBinding;
	import net.digitalprimates.guice.binding.verified.VerifiedProviderBinding;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.instanceOf;

	public class UnverifiedBindingFactoryTest {
		[Rule]
		public var mockRule:MockolateRule = new MockolateRule();
		
		[Mock(type="strict")]
		public var binder:Binder;
		
		private var annotation:String = "Annotated";
		
		[Test]
		public function shouldReturnClassBinding():void {
			var factory:UnverifiedBindingFactory = new UnverifiedBindingFactory( binder, "bindings.helpers::IThingy" );
			
			mock( binder ).method( "addBinding" ).args( instanceOf( UnverifiedClassBinding ) );
			
			var binding:IBinding = factory.toUnverifiedClassName( "bindings.helpers.ThingyImpl" );
			assertEquals( "bindings.helpers::IThingy", binding.typeName ); 
		}
		
		[Test]
		public function shouldReturnUnverifiedInstanceBinding():void {
			var factory:UnverifiedBindingFactory = new UnverifiedBindingFactory( binder, "bindings.helpers::IThingy" );
			
			mock( binder ).method( "addBinding" ).args( instanceOf( UnverifiedInstanceBinding ) );
			
			var binding:IBinding = factory.toInstance( new ThingyImpl() );
			assertEquals( "bindings.helpers::IThingy", binding.typeName ); 
		}
		
		[Test]
		public function shouldReturnUnverifiedProviderBinding():void {
			var factory:UnverifiedBindingFactory = new UnverifiedBindingFactory( binder, "String" );
			
			mock( binder ).method( "addBinding" ).args( instanceOf( UnverifiedProviderBinding ) );
			
			var binding:IBinding = factory.toProvider( ValidStringProvider );
			assertEquals( "String", binding.typeName ); 
		}
		
		[Test]
		public function shouldReturnAnnotatedClassBinding():void {
			var factory:UnverifiedBindingFactory = new UnverifiedBindingFactory( binder, "bindings.helpers::IThingy" );
			
			mock( binder ).method( "addBinding" ).args( instanceOf( UnverifiedClassBinding ) );
			
			var binding:IBinding = factory.annotatedWith( annotation ).to( ThingyImpl );
			assertEquals( annotation, binding.annotation ); 			
		}
		
		[Test]
		public function shouldReturnAnnotatedInstanceBinding():void {
			var factory:UnverifiedBindingFactory = new UnverifiedBindingFactory( binder, "bindings.helpers::IThingy" );
			
			mock( binder ).method( "addBinding" ).args( instanceOf( UnverifiedInstanceBinding ) );
			
			var binding:IBinding = factory.annotatedWith( annotation ).toInstance( new ThingyImpl() );
			assertEquals( annotation, binding.annotation ); 		
		}
		
		[Test]
		public function shouldReturnAnnotatedProviderBinding():void {
			var factory:UnverifiedBindingFactory = new UnverifiedBindingFactory( binder, "String" );
			
			mock( binder ).method( "addBinding" ).args( instanceOf( UnverifiedProviderBinding ) );
			
			var binding:IBinding = factory.annotatedWith( annotation ).toProvider( ValidStringProvider );
			assertEquals( annotation, binding.annotation );  			
		}
		
		[Test]
		public function shouldReturnSingletonClassBinding():void {
			var factory:UnverifiedBindingFactory = new UnverifiedBindingFactory( binder, "bindings.helpers::IThingy" );
			
			mock( binder ).method( "addBinding" ).args( instanceOf( UnverifiedSingletonDecorator ) );
			
			var binding:IBindingDecorator = factory.inScope( Scopes.SINGLETON ).to( ThingyImpl ) as IBindingDecorator;
			assertThat( binding.decorating, isA( UnverifiedClassBinding ) );
		}
		
		[Test]
		public function shouldReturnSingletonProviderBinding():void {
			var factory:UnverifiedBindingFactory = new UnverifiedBindingFactory( binder, "String" );
			
			mock( binder ).method( "addBinding" ).args( instanceOf( UnverifiedSingletonDecorator ) );
			
			var binding:IBindingDecorator = factory.inScope( Scopes.SINGLETON ).toProvider( ValidStringProvider ) as IBindingDecorator;
			assertThat( binding.decorating, isA( UnverifiedProviderBinding ) );
		}
	}
}