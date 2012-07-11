package bindings.cases.verified {
	import bindings.helpers.IThingy;
	import bindings.helpers.ThingyImpl;
	import bindings.helpers.providers.ValidStringProvider;
	
	import mockolate.mock;
	import mockolate.runner.MockolateRule;
	
	import net.digitalprimates.guice.Binder;
	import net.digitalprimates.guice.Scopes;
	import net.digitalprimates.guice.binding.IBinding;
	import net.digitalprimates.guice.binding.IVerifiedBinding;
	import net.digitalprimates.guice.binding.decoration.IBindingDecorator;
	import net.digitalprimates.guice.binding.decoration.VerifiedSingletonDecorator;
	import net.digitalprimates.guice.binding.unverified.UnverifiedClassBinding;
	import net.digitalprimates.guice.binding.verified.VerifiedBindingFactory;
	import net.digitalprimates.guice.binding.verified.VerifiedClassBinding;
	import net.digitalprimates.guice.binding.verified.VerifiedInstanceBinding;
	import net.digitalprimates.guice.binding.verified.VerifiedProviderBinding;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.instanceOf;

	public class VerifiedBindingFactoryTest {
		
		[Rule]
		public var mockRule:MockolateRule = new MockolateRule();
		
		[Mock(type="strict")]
		public var binder:Binder;
		
		private var annotation:String = "Annotated";

		[Test]
		public function shouldReturnVerifiedClassBinding():void {
			var factory:VerifiedBindingFactory = new VerifiedBindingFactory( binder, IThingy );
			
			mock( binder ).method( "addBinding" ).args( instanceOf( VerifiedClassBinding ) );
			
			var binding:IVerifiedBinding = factory.to( ThingyImpl );
			assertEquals( IThingy, binding.type ); 
		}

		[Test]
		public function shouldReturnClassBinding():void {
			var factory:VerifiedBindingFactory = new VerifiedBindingFactory( binder, IThingy );
			
			mock( binder ).method( "addBinding" ).args( instanceOf( UnverifiedClassBinding ) );
			
			var binding:IBinding = factory.toUnverifiedClassName( "bindings.helpers.ThingyImpl" );
			assertEquals( "bindings.helpers::IThingy", binding.typeName ); 
		}
		
		[Test]
		public function shouldReturnInstanceBinding():void {
			var factory:VerifiedBindingFactory = new VerifiedBindingFactory( binder, IThingy );
			
			mock( binder ).method( "addBinding" ).args( instanceOf( VerifiedInstanceBinding ) );
			
			var binding:IVerifiedBinding = factory.toInstance( new ThingyImpl() );
			assertEquals( IThingy, binding.type ); 
		}

		[Test]
		public function shouldReturnProviderBinding():void {
			var factory:VerifiedBindingFactory = new VerifiedBindingFactory( binder, String );
			
			mock( binder ).method( "addBinding" ).args( instanceOf( VerifiedProviderBinding ) );
			
			var binding:IVerifiedBinding = factory.toProvider( ValidStringProvider );
			assertEquals( String, binding.type ); 
		}

		[Test]
		public function shouldReturnAnnotatedClassBinding():void {
			var factory:VerifiedBindingFactory = new VerifiedBindingFactory( binder, IThingy );
			
			mock( binder ).method( "addBinding" ).args( instanceOf( VerifiedClassBinding ) );
			
			var binding:IBinding = factory.annotatedWith( annotation ).to( ThingyImpl );
			assertEquals( annotation, binding.annotation ); 			
		}
		
		[Test]
		public function shouldReturnAnnotatedInstanceBinding():void {
			var factory:VerifiedBindingFactory = new VerifiedBindingFactory( binder, IThingy );
			
			mock( binder ).method( "addBinding" ).args( instanceOf( VerifiedInstanceBinding ) );
			
			var binding:IBinding = factory.annotatedWith( annotation ).toInstance( new ThingyImpl() );
			assertEquals( annotation, binding.annotation ); 		
		}
		
		[Test]
		public function shouldReturnAnnotatedProviderBinding():void {
			var factory:VerifiedBindingFactory = new VerifiedBindingFactory( binder, String );
			
			mock( binder ).method( "addBinding" ).args( instanceOf( VerifiedProviderBinding ) );
			
			var binding:IBinding = factory.annotatedWith( annotation ).toProvider( ValidStringProvider );
			assertEquals( annotation, binding.annotation );  			
		}

		[Test]
		public function shouldReturnSingletonClassBinding():void {
			var factory:VerifiedBindingFactory = new VerifiedBindingFactory( binder, IThingy );
			
			mock( binder ).method( "addBinding" ).args( instanceOf( VerifiedSingletonDecorator ) );
			
			var binding:IBindingDecorator = factory.inScope( Scopes.SINGLETON ).to( ThingyImpl ) as IBindingDecorator;
			assertThat( binding.decorating, isA( VerifiedClassBinding ) );
		}
		
		[Test]
		public function shouldReturnSingletonProviderBinding():void {
			var factory:VerifiedBindingFactory = new VerifiedBindingFactory( binder, String );
			
			mock( binder ).method( "addBinding" ).args( instanceOf( VerifiedSingletonDecorator ) );
			
			var binding:IBindingDecorator = factory.inScope( Scopes.SINGLETON ).toProvider( ValidStringProvider ) as IBindingDecorator;
			assertThat( binding.decorating, isA( VerifiedProviderBinding ) );
		}

	}
}