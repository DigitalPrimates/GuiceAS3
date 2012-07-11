package integration {
	import integration.scenarios.classes.computer.PowerSupply;
	
	import net.digitalprimates.guice.Binder;
	import net.digitalprimates.guice.Injector;
	import net.digitalprimates.guice.utils.DependencyHasher;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;

	public class PowerSupplyTest {
		private var binder:Binder;
		
		[Before]
		public function setup():void {
			binder = new Binder( new DependencyHasher() );			
		}
		
		[Test]
		public function shouldFailBuildPowerSupplyWithoutDependency():void {
			var thrown:Boolean = false;
			try {
				var injector:Injector = new Injector( binder );
				injector.getInstance( PowerSupply );
			} catch (e:Error ) {
				thrown = true;
				assertEquals( "Cannot build type integration.scenarios.classes.computer::PowerSupply because [class IFan] cannot be resolved to a concrete dependency", e.message );
			}
			
			assertTrue( "Should have thrown error", thrown );
		}
		
/*		[Test]
		public function shouldBuildSupplyWithGenericInterfaceMapping():void {
			var injector:Injector = new Injector( binder );
			binder.bind( String ).toInstance( "x86" );
			injector.getInstance( Processor );
		}	*/	
	}
}