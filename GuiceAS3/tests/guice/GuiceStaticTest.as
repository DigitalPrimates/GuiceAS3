package guice {
	import mockolate.mock;
	import mockolate.runner.MockolateRule;
	
	import net.digitalprimates.guice.Binder;
	import net.digitalprimates.guice.Guice;
	import net.digitalprimates.guice.IGuiceModule;
	import net.digitalprimates.guice.Injector;
	
	import org.hamcrest.object.instanceOf;

	public class GuiceStaticTest {
		[Rule]
		public var mockRule:MockolateRule = new MockolateRule();
		
		[Mock(type="strict")]
		public var module:IGuiceModule;
		
		[Test]
		public function shouldCallConfigureOnModule():void {
			mock( module ).method( "configure" ).args( instanceOf( Binder ) ).once();
			Guice.createInjector( module );
		}
	}
}