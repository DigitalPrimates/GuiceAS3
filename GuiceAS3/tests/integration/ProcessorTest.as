package integration {
	import integration.scenarios.classes.computer.Processor;
	
	import net.digitalprimates.guice.Binder;
	import net.digitalprimates.guice.Guice;
	import net.digitalprimates.guice.Injector;
	import net.digitalprimates.guice.utils.DependencyHasher;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.fail;

	public class ProcessorTest {
		private var binder:Binder;
		
		[Before]
		public function setup():void {
			binder = new Binder( new DependencyHasher() );			
		}
		
		[Test]
		public function shouldFailBuildProcessorWithoutDependency():void {
			var thrown:Boolean = false;
			try {
				var injector:Injector = new Injector( binder );
				injector.getInstance( Processor );
			} catch (e:Error ) {
				thrown = true;
				assertEquals( "Cannot build type integration.scenarios.classes.computer::Processor because [class String] cannot be resolved to a concrete dependency", e.message );
			}
			
			assertTrue( "Should have thrown error", thrown );
		}
		
		[Test]
		public function shouldBuildProcessorWithGenericStringMapping():void {
			var injector:Injector = new Injector( binder );
			binder.bind( String ).toInstance( "x86" );
			injector.getInstance( Processor );
		}		
		
		[Test]
		public function shouldBuildProcessorWithAnnotatedStringMapping():void {
			var injector:Injector = new Injector( binder );
			binder.bind( String ).annotatedWith( "processorLabel" ).toInstance( "x86" );
			injector.getInstance( Processor );
		}		
		
		[Test]
		public function shouldFailBuildProcessorWithWrongAnnotation():void {
			var thrown:Boolean = false;
			try {
				var injector:Injector = new Injector( binder );
				binder.bind( String ).annotatedWith( "none" ).toInstance( "x86" );
				injector.getInstance( Processor );
			} catch (e:Error ) {
				thrown = true;
				assertEquals( "Cannot build type integration.scenarios.classes.computer::Processor because [class String] cannot be resolved to a concrete dependency", e.message );
			}
			
			assertTrue( "Should have thrown error", thrown );
		}		
	}
}