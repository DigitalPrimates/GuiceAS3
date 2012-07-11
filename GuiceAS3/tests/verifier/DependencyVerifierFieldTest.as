package verifier {
	import bindings.helpers.IThingy;
	
	import siemens.lang.reflect.Field;
	import siemens.lang.reflect.Klass;
	import siemens.lang.reflect.metadata.MetaDataAnnotation;
	import siemens.lang.reflect.metadata.MetaDataArgument;
	
	import mockolate.mock;
	import mockolate.runner.MockolateRule;
	import mockolate.strict;
	
	import net.digitalprimates.guice.Binder;
	import net.digitalprimates.guice.GuiceAnnotations;
	import net.digitalprimates.guice.binding.IVerifiedBinding;
	import net.digitalprimates.guice.utils.CircularResolutionWatcher;
	import net.digitalprimates.guice.utils.KlassFactory;
	import net.digitalprimates.guice.verifier.DependencyVerifier;

	public class DependencyVerifierFieldTest {
		[Rule]
		public var mockRule:MockolateRule = new MockolateRule();
		
		[Mock(type="strict")]
		public var klass:Klass;

		[Mock(type="strict")]
		public var subKlass:Klass;

		[Mock(inject="false")]
		public var field:Field;

		[Mock(inject="false")]
		public var annotation:MetaDataAnnotation;

		[Mock(inject="false")]
		public var argument:MetaDataArgument;

		[Mock(type="strict")]
		public var childVerifier:DependencyVerifier;
		
		[Mock(type="strict")]
		public var klassFactory:KlassFactory;
		
		private var testVerifier:DependencyVerifier;
		
		private static const clazz:String = "String";
		private static const blankAnnotation:String = "";
		
		[Before]
		public function setup():void {
			var xml:XML = <root/>;
			testVerifier = new DependencyVerifier( null, null, klassFactory );
			field = strict( Field, "field", [ xml, false, String, false ] );
			annotation = strict( MetaDataAnnotation, "annotation", [ xml ] );
			argument = strict( MetaDataArgument, "argument", [ xml ] );
		}
		
		[After]
		public function tearDown():void {
			testVerifier = null;
		}
		
		[Test]
		public function shouldNotAttemptToResolveNoFields():void {
			var fields:Array = [];
			mock( klass ).getter( "fields" ).returns( fields ).once();
			mock( childVerifier ).method( "recursivelyVerifyDependency" ).never();
			
			testVerifier.verifyFields( klass, childVerifier );
		}
		
		[Test]
		public function shouldNotAttemptToResolveNoFieldsWithInject():void {
			var fields:Array = [ field ];
			mock( klass ).getter( "fields" ).returns( fields ).once();
			mock( field ).method( "getMetaData" ).args( GuiceAnnotations.INJECT ).returns( null ).once();
			mock( childVerifier ).method( "recursivelyVerifyDependency" ).never();
			
			testVerifier.verifyFields( klass, childVerifier );
		}		

		[Test]
		public function shouldAttemptToResolveInjectFieldWithoutAnnotation():void {
			var fields:Array = [ field ];
			mock( klass ).getter( "fields" ).returns( fields ).once();
			mock( field ).method( "getMetaData" ).args( GuiceAnnotations.INJECT ).returns( annotation ).once();
			mock( field ).getter( "type" ).returns( IThingy ).once();
			mock( annotation ).getter( "defaultArgument" ).returns( null ).once();
			mock( klassFactory ).method( "newInstance" ).args( IThingy ).returns( subKlass ).once();
			mock( childVerifier ).method( "recursivelyVerifyDependency" ).args( klass, subKlass, "", childVerifier ).once();
			
			testVerifier.verifyFields( klass, childVerifier );
		}		
		
		[Test]
		public function shouldAttemptToResolveInjectFieldWithAnnotation():void {
			var fields:Array = [ field ];
			const injectAnnotation:String = "annotateMe";
			
			mock( klass ).getter( "fields" ).returns( fields ).once();
			mock( field ).method( "getMetaData" ).args( GuiceAnnotations.INJECT ).returns( annotation ).once();
			mock( field ).getter( "type" ).returns( IThingy ).once();
			mock( annotation ).getter( "defaultArgument" ).returns( argument ).once();
			mock( argument ).getter( "key" ).returns( injectAnnotation ).once();
			mock( klassFactory ).method( "newInstance" ).args( IThingy ).returns( subKlass ).once();
			mock( childVerifier ).method( "recursivelyVerifyDependency" ).args( klass, subKlass, injectAnnotation, childVerifier ).once();
			
			testVerifier.verifyFields( klass, childVerifier );
		}	
		
		[Test]
		public function shouldAttemptToResolveInjectFieldsWithoutAnnotation():void {
			var fields:Array = [ field, field ];
			mock( klass ).getter( "fields" ).returns( fields ).once();
			mock( field ).method( "getMetaData" ).args( GuiceAnnotations.INJECT ).returns( annotation ).twice();
			mock( field ).getter( "type" ).returns( IThingy ).twice();
			mock( annotation ).getter( "defaultArgument" ).returns( null ).twice();
			mock( klassFactory ).method( "newInstance" ).args( IThingy ).returns( subKlass ).twice();
			mock( childVerifier ).method( "recursivelyVerifyDependency" ).args( klass, subKlass, "", childVerifier ).twice();
			
			testVerifier.verifyFields( klass, childVerifier );
		}		
		
		[Test]
		public function shouldAttemptToResolveInjectFieldsWithAnnotation():void {
			var fields:Array = [ field, field ];
			const injectAnnotation:String = "annotateMe";
			
			mock( klass ).getter( "fields" ).returns( fields ).once();
			mock( field ).method( "getMetaData" ).args( GuiceAnnotations.INJECT ).returns( annotation ).twice();
			mock( field ).getter( "type" ).returns( IThingy ).twice();
			mock( annotation ).getter( "defaultArgument" ).returns( argument ).twice();
			mock( argument ).getter( "key" ).returns( injectAnnotation ).twice();
			mock( klassFactory ).method( "newInstance" ).args( IThingy ).returns( subKlass ).twice();
			mock( childVerifier ).method( "recursivelyVerifyDependency" ).args( klass, subKlass, injectAnnotation, childVerifier ).twice();
			
			testVerifier.verifyFields( klass, childVerifier );
		}		
	}
}