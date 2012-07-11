package verifier {
	import bindings.helpers.ThingyImpl;
	
	import siemens.lang.reflect.Constructor;
	import siemens.lang.reflect.Klass;
	import siemens.lang.reflect.constructor.ConstructorArg;
	
	import mockolate.mock;
	import mockolate.runner.MockolateRule;
	
	import net.digitalprimates.guice.Binder;
	import net.digitalprimates.guice.binding.IVerifiedBinding;
	import net.digitalprimates.guice.reflect.ConstructorAnnotations;
	import net.digitalprimates.guice.utils.CircularResolutionWatcher;
	import net.digitalprimates.guice.utils.KlassFactory;
	import net.digitalprimates.guice.verifier.DependencyVerifier;

	public class DependencyVerifierConstructorTest {
		
		[Rule]
		public var mockRule:MockolateRule = new MockolateRule();

		[Mock(type="strict")]
		public var klass:Klass;

		[Mock(type="strict")]
		public var subKlass:Klass;
		
		[Mock(type="strict")]
		public var constructor:Constructor;

		[Mock(type="strict")]
		public var constructorArg1:ConstructorArg;

		[Mock(type="strict")]
		public var constructorArg2:ConstructorArg;

		[Mock(type="strict")]
		public var constructorAnnotations:ConstructorAnnotations;
		
		[Mock(type="strict")]
		public var childVerifier:DependencyVerifier;

		[Mock(type="strict")]
		public var klassFactory:KlassFactory;
		
		private var testVerifier:DependencyVerifier;

		private static const clazz:String = "String";
		private static const blankAnnotation:String = "";

		[Before]
		public function setup():void {
			testVerifier = new DependencyVerifier( null, null, klassFactory );
		}
		
		[After]
		public function tearDown():void {
			testVerifier = null;
		}

/*		[Test]
		public function shouldNotVerifyIfAlreadyComplete():void {
			mock( binding ).getter( "typeName" ).returns( clazz );
			mock( binding ).getter( "annotation" ).returns( blankAnnotation );
			mock( binding ).getter( "type" ).never();
			mock( watcher ).method( "isComplete" ).args( clazz, blankAnnotation ).returns( true );
			
			testVerifier.verifyDependency( binding );
		}*/
		
		[Test]
		public function shouldAttemptToResolveNoConstructorArgs():void {
			var parameterTypes:Array = [];
			mock( klass ).getter( "constructor" ).returns( constructor ).once();
			mock( constructor ).getter( "parameterTypes" ).returns( parameterTypes ).once();
			mock( childVerifier ).method( "recursivelyVerifyDependency" ).never();
			
			testVerifier.verifyConstructor( klass, constructorAnnotations, childVerifier );
		}

		[Test]
		public function shouldAttemptToResolveSingleRequiredConstructorArgNoAnnotations():void {
			var parameterTypes:Array = [ constructorArg1 ];

			mock( klass ).getter( "constructor" ).returns( constructor ).once();
			mock( constructor ).getter( "parameterTypes" ).returns( parameterTypes ).once();
			mock( constructorArg1 ).getter( "required" ).returns( true ).once();
			mock( constructorArg1 ).getter( "type" ).returns( String ).once();
			mock( klassFactory ).method( "newInstance" ).args( String ).returns( null ).once();
			mock( childVerifier ).method( "recursivelyVerifyDependency" ).args( klass, null, "", childVerifier ).once();
			mock( constructorAnnotations ).method( "getAnnotationAt" ).args( 0 ).returns( "" ).once();
			
			testVerifier.verifyConstructor( klass, constructorAnnotations, childVerifier );
		}
		
		[Test]
		public function shouldNotAttemptToResolveNotRequiredConstructorArg():void {
			var parameterTypes:Array = [ constructorArg1 ];
			
			mock( klass ).getter( "constructor" ).returns( constructor ).once();
			mock( constructor ).getter( "parameterTypes" ).returns( parameterTypes ).once();
			mock( constructorArg1 ).getter( "required" ).returns( false ).once();

			testVerifier.verifyConstructor( klass, constructorAnnotations, childVerifier );
		}

		[Test]
		public function shouldAttemptToResolveSingleRequiredConstructorArgWithAnnotations():void {
			var parameterTypes:Array = [ constructorArg1 ];
			var constructorArgs:Array = [];
			const annotation:String = "whatever";
			
			mock( klass ).getter( "constructor" ).returns( constructor ).once();
			mock( constructor ).getter( "parameterTypes" ).returns( parameterTypes ).once();
			mock( constructorArg1 ).getter( "required" ).returns( true ).once();
			mock( constructorArg1 ).getter( "type" ).returns( String ).once();
			mock( klassFactory ).method( "newInstance" ).args( String ).returns( null ).once();
			mock( constructorAnnotations ).method( "getAnnotationAt" ).args( 0 ).returns( annotation ).once();
			mock( childVerifier ).method( "recursivelyVerifyDependency" ).args( klass, null, annotation, childVerifier ).once();
			
			testVerifier.verifyConstructor( klass, constructorAnnotations, childVerifier );
		}

		[Test]
		public function shouldAttemptToResolveMultipleRequiredConstructorArgNoAnnotations():void {
			var parameterTypes:Array = [ constructorArg1, constructorArg2 ];
			
			mock( klass ).getter( "constructor" ).returns( constructor ).once();
			mock( constructor ).getter( "parameterTypes" ).returns( parameterTypes ).once();
			mock( constructorArg1 ).getter( "required" ).returns( true ).once();
			mock( constructorArg1 ).getter( "type" ).returns( String ).once();

			mock( constructorArg2 ).getter( "required" ).returns( true ).once();
			mock( constructorArg2 ).getter( "type" ).returns( ThingyImpl ).once();
			
			mock( klassFactory ).method( "newInstance" ).args( String ).returns( subKlass ).once();
			mock( klassFactory ).method( "newInstance" ).args( ThingyImpl ).returns( subKlass ).once();

			mock( childVerifier ).method( "recursivelyVerifyDependency" ).args( klass, subKlass, "", childVerifier ).once();
			mock( childVerifier ).method( "recursivelyVerifyDependency" ).args( klass, subKlass, "", childVerifier ).once();

			mock( constructorAnnotations ).method( "getAnnotationAt" ).args( 0 ).returns( "" ).once();
			mock( constructorAnnotations ).method( "getAnnotationAt" ).args( 1 ).returns( "" ).once();
			
			testVerifier.verifyConstructor( klass, constructorAnnotations, childVerifier );
		}
		
		[Test]
		public function shouldAttemptToResolveMultipleRequiredConstructorArgWithAnnotations():void {
			var parameterTypes:Array = [ constructorArg1, constructorArg2 ];
			
			const annotation1:String = "whatever1";
			const annotation2:String = "whatever2";
			
			mock( klass ).getter( "constructor" ).returns( constructor ).once();
			mock( constructor ).getter( "parameterTypes" ).returns( parameterTypes ).once();
			mock( constructorArg1 ).getter( "required" ).returns( true ).once();
			mock( constructorArg1 ).getter( "type" ).returns( String ).once();
			
			mock( constructorArg2 ).getter( "required" ).returns( true ).once();
			mock( constructorArg2 ).getter( "type" ).returns( ThingyImpl ).once();
			
			mock( klassFactory ).method( "newInstance" ).args( String ).returns( subKlass ).once();
			mock( klassFactory ).method( "newInstance" ).args( ThingyImpl ).returns( subKlass ).once();
			
			mock( childVerifier ).method( "recursivelyVerifyDependency" ).args( klass, subKlass, annotation1, childVerifier ).once();
			mock( childVerifier ).method( "recursivelyVerifyDependency" ).args( klass, subKlass, annotation2, childVerifier ).once();
			
			mock( constructorAnnotations ).method( "getAnnotationAt" ).args( 0 ).returns( annotation1 ).once();
			mock( constructorAnnotations ).method( "getAnnotationAt" ).args( 1 ).returns( annotation2 ).once();
			
			testVerifier.verifyConstructor( klass, constructorAnnotations, childVerifier );
		}
		//Mapped Constructor Type
		//Mapped Field Type
		//Unmapped Constructor Type
		//Unmapped Field Type
		
		//Mapped Constructor Type with Unmapped SubType
		//Mapped Field Type with Unmapped SubType
		
		//Default Constructor Arguments
		//Buildable Types
		
		//Constructor with option argument... optional argument has known dependencies
		//Constructor with option argument... optional argument has unknown dependencies
	}
}