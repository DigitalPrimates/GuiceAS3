package {
	import bindings.BindingSuite;
	
	import guice.GuiceStaticTest;
	
	import integration.IntegrationSuite;
	
	import net.digitalprimates.guice.utils.DependencyHasher;
	
	import reflect.ConstructorAnnotationsTest;
	
	import utils.CircularResolutionWatcherTest;
	import utils.DependencyHasherTest;
	
	import verifier.DependencyVerifierConstructorTest;
	import verifier.DependencyVerifierFieldTest;
	import verifier.DependencyVerifierMain;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class GuiceSuite {
/*		public var suite1:BindingSuite;
		public var suite2:CircularResolutionWatcherTest;
		public var suite3:DependencyHasherTest;
		public var suite5:GuiceStaticTest;
		public var test0:ConstructorAnnotationsTest;*/
		//public var test1:DependencyVerifierMain;
		//public var test2:DependencyVerifierConstructorTest;
		//public var test3:DependencyVerifierFieldTest;
		public var suite6:IntegrationSuite;
	}
}