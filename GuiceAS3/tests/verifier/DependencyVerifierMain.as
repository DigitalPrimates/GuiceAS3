package verifier {
	import siemens.lang.reflect.Klass;
	
	import mockolate.mock;
	import mockolate.runner.MockolateRule;
	
	import net.digitalprimates.guice.Binder;
	import net.digitalprimates.guice.binding.IVerifiedBinding;
	import net.digitalprimates.guice.utils.CircularResolutionWatcher;
	import net.digitalprimates.guice.utils.KlassFactory;
	import net.digitalprimates.guice.verifier.DependencyVerifier;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.fail;
	
	public class DependencyVerifierMain {
		[Rule]
		public var mockRule:MockolateRule = new MockolateRule();

		[Mock(type="strict")]
		public var parentKlass:Klass;

		[Mock(type="strict")]
		public var klass:Klass;
		
		[Mock(type="strict")]
		public var childVerifier:DependencyVerifier;
		
		[Mock(type="strict")]
		public var klassFactory:KlassFactory;

		[Mock(type="strict")]
		public var binder:Binder;

		[Mock(type="strict")]
		public var watcher:CircularResolutionWatcher;

		[Mock(type="strict")]
		public var binding:IVerifiedBinding;

		private var testVerifier:DependencyVerifier;
		
		private static const clazz:String = "String";
		private static const blankAnnotation:String = "";
		private static const otherAnnotation:String = "Hello";

		[Before]
		public function setup():void {
			testVerifier = new DependencyVerifier( binder, watcher, klassFactory );
		}
		
		[After]
		public function tearDown():void {
			testVerifier = null;
		}
		
		[Test]
		public function shouldNotVerifyIfAlreadyComplete():void {
			mock( binding ).getter( "typeName" ).returns( clazz );
			mock( binding ).getter( "annotation" ).returns( otherAnnotation );
			mock( binding ).getter( "type" ).never();
			mock( watcher ).method( "isComplete" ).args( clazz, otherAnnotation ).returns( true );
			
			testVerifier.verifyDependency( binding );
		}
		
		[Test]
		public function shouldThrowErrorIfInProcessWithNoParent():void {
			try {
				mock( klass ).getter( "name" ).returns( clazz );
				mock( binder ).method( "getBindingByName" ).args( clazz, otherAnnotation ).returns( binding );
				mock( watcher ).method( "isInProcess" ).args( clazz, otherAnnotation ).returns( true );
				
				testVerifier.recursivelyVerifyDependency( null, klass, otherAnnotation, childVerifier );
				fail( "Should have thrown error" );
			} catch ( e:Error ) {
				assertEquals( "Circular dependency found when resolving for class String", e.message ); 
			}
		}

		[Test]
		public function shouldThrowErrorIfInProcessWithParent():void {
			const parentClass:String = "TestMe";

			try {
				mock( parentKlass ).getter( "name" ).returns( parentClass );
				mock( klass ).getter( "name" ).returns( clazz );
				mock( binder ).method( "getBindingByName" ).args( clazz, otherAnnotation ).returns( binding );
				mock( watcher ).method( "isInProcess" ).args( clazz, otherAnnotation ).returns( true );
				
				testVerifier.recursivelyVerifyDependency( parentKlass, klass, otherAnnotation, childVerifier );
				fail( "Should have thrown error" );
			} catch ( e:Error ) {
				assertEquals( "Circular dependency found when resolving String in class TestMe", e.message ); 
			}
		}
	}
}