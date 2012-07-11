package utils {
	import mockolate.mock;
	import mockolate.runner.MockolateRule;
	
	import net.digitalprimates.guice.Injector;
	import net.digitalprimates.guice.utils.CircularResolutionWatcher;
	import net.digitalprimates.guice.utils.DependencyHasher;
	
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

	public class CircularResolutionWatcherTest {
		[Rule]
		public var mockRule:MockolateRule = new MockolateRule();
		
		[Mock(type="strict")]
		public var hasher:DependencyHasher;
		
		private var watcher:CircularResolutionWatcher;
		private var typeName:String = "String";
		private var annotation:String = "Annotated";

		[Before]
		public function setup():void {
			watcher = new CircularResolutionWatcher( hasher );
		}
		
		[After]
		public function tearDown():void {
			watcher = null;
		}
		
		[Test]
		public function shouldCreateHashWithTypeAndAnnotation():void {
			mock( hasher ).method( "createHash" ).args( typeName, annotation ).returns( "Hash" ).once();
			watcher.beginResolution( typeName, annotation );
		}

		[Test]
		public function shouldShowInProcess():void {
			mock( hasher ).method( "createHash" ).args( typeName, annotation ).returns( "Hash" ).twice();
			watcher.beginResolution( typeName, annotation );
			assertTrue( watcher.isInProcess( typeName, annotation ) );
		}

		[Test]
		public function shouldNotShowInProcessWhenNotStarted():void {
			mock( hasher ).method( "createHash" ).args( typeName, annotation ).returns( "Hash" ).once();
			
			assertFalse( watcher.isInProcess( typeName, annotation ) );
		}

		[Test]
		public function shouldNotShowInProcessWhenComplete():void {
			mock( hasher ).method( "createHash" ).args( typeName, annotation ).returns( "Hash" ).thrice();
			watcher.beginResolution( typeName, annotation );
			watcher.completeResolution( typeName, annotation );
							
			assertFalse( watcher.isInProcess( typeName, annotation ) );
		}

		[Test]
		public function shouldNotShowInProcess():void {
			mock( hasher ).method( "createHash" ).args( typeName, annotation ).returns( "Hash" ).once();
			
			assertFalse( watcher.isInProcess( typeName, annotation ) );
		}

		[Test]
		public function shouldShowComplete():void {
			mock( hasher ).method( "createHash" ).args( typeName, annotation ).returns( "Hash" ).thrice();
			watcher.beginResolution( typeName, annotation );
			watcher.completeResolution( typeName, annotation );
			assertTrue( watcher.isComplete( typeName, annotation ) );			
		}

		[Test]
		public function shouldNotShowCompleteWhenNotStarted():void {
			mock( hasher ).method( "createHash" ).args( typeName, annotation ).returns( "Hash" ).once();
			
			assertFalse( watcher.isComplete( typeName, annotation ) );			
		}

		[Test]
		public function shouldNotShowCompleteWhenInProcess():void {
			mock( hasher ).method( "createHash" ).args( typeName, annotation ).returns( "Hash" ).twice();
			watcher.beginResolution( typeName, annotation );
			assertFalse( watcher.isComplete( typeName, annotation ) );			
		}
	}
}