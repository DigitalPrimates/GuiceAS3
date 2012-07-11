package reflect {
	import siemens.lang.reflect.Constructor;
	import siemens.lang.reflect.Klass;
	import siemens.lang.reflect.metadata.MetaDataAnnotation;
	import siemens.lang.reflect.metadata.MetaDataArgument;
	
	import mockolate.mock;
	import mockolate.runner.MockolateRule;
	import mockolate.strict;
	
	import net.digitalprimates.guice.GuiceAnnotations;
	import net.digitalprimates.guice.reflect.ConstructorAnnotations;
	import net.digitalprimates.guice.verifier.DependencyVerifier;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNull;

	public class ConstructorAnnotationsTest {
		[Rule]
		public var mockRule:MockolateRule = new MockolateRule();
		
		[Mock(type="strict")]
		public var klass:Klass;

		[Mock(inject="false")]
		public var metaDataAnnotation1:MetaDataAnnotation;

		[Mock(inject="false")]
		public var argument1_annotation1:MetaDataArgument;

		[Mock(inject="false")]
		public var argument2_annotation1:MetaDataArgument;

		[Mock(inject="false")]
		public var metaDataAnnotation2:MetaDataAnnotation;
		
		[Mock(inject="false")]
		public var argument1_annotation2:MetaDataArgument;
		
		[Mock(inject="false")]
		public var argument2_annotation2:MetaDataArgument;

		public var annotations:ConstructorAnnotations;
		
		[Before]
		public function setup():void {
			annotations = new ConstructorAnnotations( klass );
		}
		
		[After]
		public function tearDown():void {
			annotations = null;
		}

		[Test]
		public function shouldCacheAnnotations():void {
		}		

		[Test]
		public function shouldReturnNullForNonExistantAnnotations():void {
			var classMetaData:Array = [];
			
			mock( klass ).getter( "metadata" ).returns( classMetaData );
			
			assertEquals( "", annotations.getAnnotationAt( 0 ) );
			assertEquals( "", annotations.getAnnotationAt( 1 ) );
			assertEquals( "", annotations.getAnnotationAt( 2 ) );
		}		

		[Test]
		public function shouldReturnDefaultAnnotationAsIndex0():void {
			var classMetaData:Array = [];
			const bob:String = "Bob";
			
			metaDataAnnotation1 = strict( MetaDataAnnotation, "metaDataAnnotation", [<root/>] );
			argument1_annotation1 = strict( MetaDataArgument, "metaDataArgument", [<root/>] );
			
			classMetaData[ 0 ] = metaDataAnnotation1;
			
			mock( klass ).getter( "metadata" ).returns( classMetaData );
			mock( metaDataAnnotation1 ).getter( "name" ).returns( GuiceAnnotations.CONSTRUCTOR ).once();
			mock( metaDataAnnotation1 ).method( "getArgument" ).args( GuiceAnnotations.INDEX, true ).returns( null );
			mock( metaDataAnnotation1 ).method( "getArgument" ).args( GuiceAnnotations.ANNOTATION, true ).returns( argument1_annotation1 );
			mock( argument1_annotation1 ).getter( "value" ).returns( bob );
			
			assertEquals( bob, annotations.getAnnotationAt( 0 ) );
		}
		
		[Test]
		public function shouldReturnAnnotationAtIndex0():void {
			var classMetaData:Array = [];
			const bob:String = "Bob";

			metaDataAnnotation1 = strict( MetaDataAnnotation, "metaDataAnnotation", [<root/>] );
			argument1_annotation1 = strict( MetaDataArgument, "metaDataArgument", [<root/>] );
			argument2_annotation1 = strict( MetaDataArgument, "metaDataArgument", [<root/>] );
			
			classMetaData[ 0 ] = metaDataAnnotation1;

			mock( klass ).getter( "metadata" ).returns( classMetaData );
			mock( metaDataAnnotation1 ).getter( "name" ).returns( GuiceAnnotations.CONSTRUCTOR ).once();
			mock( metaDataAnnotation1 ).method( "getArgument" ).args( GuiceAnnotations.INDEX, true ).returns( argument1_annotation1 );
			mock( argument1_annotation1 ).getter( "value" ).returns( "0" );

			mock( metaDataAnnotation1 ).method( "getArgument" ).args( GuiceAnnotations.ANNOTATION, true ).returns( argument2_annotation1 );
			mock( argument2_annotation1 ).getter( "value" ).returns( bob );
			
			assertEquals( bob, annotations.getAnnotationAt( 0 ) );
		}
		
		[Test]
		public function shouldReturnSparseAnnotationAtIndex1():void {
			var classMetaData:Array = [];
			const bob:String = "Bob";
			
			metaDataAnnotation1 = strict( MetaDataAnnotation, "metaDataAnnotation", [<root/>] );
			argument1_annotation1 = strict( MetaDataArgument, "metaDataArgument", [<root/>] );
			argument2_annotation1 = strict( MetaDataArgument, "metaDataArgument", [<root/>] );
			
			classMetaData[ 0 ] = metaDataAnnotation1;
			
			mock( klass ).getter( "metadata" ).returns( classMetaData );
			mock( metaDataAnnotation1 ).getter( "name" ).returns( GuiceAnnotations.CONSTRUCTOR ).once();
			mock( metaDataAnnotation1 ).method( "getArgument" ).args( GuiceAnnotations.INDEX, true ).returns( argument1_annotation1 );
			mock( argument1_annotation1 ).getter( "value" ).returns( "1" );
			
			mock( metaDataAnnotation1 ).method( "getArgument" ).args( GuiceAnnotations.ANNOTATION, true ).returns( argument2_annotation1 );
			mock( argument2_annotation1 ).getter( "value" ).returns( bob );
			
			assertEquals( "", annotations.getAnnotationAt( 0 ) );
			assertEquals( bob, annotations.getAnnotationAt( 1 ) );
		}		
		
		[Test]
		public function shouldReturnMultipleAnnotations():void {
			var parameterTypes:Array = [];
			var classMetaData:Array = [];
			const bob:String = "Bob";
			const nancy:String = "Nancy";
			
			metaDataAnnotation1 = strict( MetaDataAnnotation, "metaDataAnnotation1", [<root/>] );
			argument1_annotation1 = strict( MetaDataArgument, "metaDataArgument", [<root/>] );
			argument2_annotation1 = strict( MetaDataArgument, "metaDataArgument", [<root/>] );

			metaDataAnnotation2 = strict( MetaDataAnnotation, "metaDataAnnotation2", [<root/>] );
			argument1_annotation2 = strict( MetaDataArgument, "metaDataArgument", [<root/>] );
			argument2_annotation2 = strict( MetaDataArgument, "metaDataArgument", [<root/>] );

			classMetaData[ 0 ] = metaDataAnnotation1;
			classMetaData[ 1 ] = metaDataAnnotation2;
			
			mock( klass ).getter( "metadata" ).returns( classMetaData );
			mock( metaDataAnnotation1 ).getter( "name" ).returns( GuiceAnnotations.CONSTRUCTOR ).once();
			mock( metaDataAnnotation2 ).getter( "name" ).returns( GuiceAnnotations.CONSTRUCTOR ).once();

			mock( metaDataAnnotation1 ).method( "getArgument" ).args( GuiceAnnotations.INDEX, true ).returns( argument1_annotation1 );
			mock( argument1_annotation1 ).getter( "value" ).returns( "0" );
			
			mock( metaDataAnnotation1 ).method( "getArgument" ).args( GuiceAnnotations.ANNOTATION, true ).returns( argument2_annotation1 );
			mock( argument2_annotation1 ).getter( "value" ).returns( bob );

			mock( metaDataAnnotation2 ).method( "getArgument" ).args( GuiceAnnotations.INDEX, true ).returns( argument1_annotation2 );
			mock( argument1_annotation2 ).getter( "value" ).returns( "1" );
			
			mock( metaDataAnnotation2 ).method( "getArgument" ).args( GuiceAnnotations.ANNOTATION, true ).returns( argument2_annotation2 );
			mock( argument2_annotation2 ).getter( "value" ).returns( nancy );

			assertEquals( bob, annotations.getAnnotationAt( 0 ) );
			assertEquals( nancy, annotations.getAnnotationAt( 1 ) );
		}
		

		[Test]
		public function shouldSkipMalformedAnnotation():void {
			var classMetaData:Array = [];
			const bob:String = "Bob";
			
			metaDataAnnotation1 = strict( MetaDataAnnotation, "metaDataAnnotation", [<root/>] );
			
			classMetaData[ 0 ] = metaDataAnnotation1;
			
			mock( klass ).getter( "metadata" ).returns( classMetaData );
			mock( metaDataAnnotation1 ).getter( "name" ).returns( GuiceAnnotations.CONSTRUCTOR ).once();
			mock( metaDataAnnotation1 ).method( "getArgument" ).args( GuiceAnnotations.INDEX, true ).returns( null );
			mock( metaDataAnnotation1 ).method( "getArgument" ).args( GuiceAnnotations.ANNOTATION, true ).returns( null );
			
			assertEquals( "", annotations.getAnnotationAt( 0 ) );
			assertEquals( "", annotations.getAnnotationAt( 1 ) );
		}
	}
}