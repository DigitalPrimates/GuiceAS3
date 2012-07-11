package utils {
	import net.digitalprimates.guice.utils.DependencyHasher;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertNotNull;
	import org.hamcrest.core.not;

	public class DependencyHasherTest {
		private var hasher:DependencyHasher;
		
		[Before]
		public function setup():void {
			hasher = new DependencyHasher();
		}
		
		[After]
		public function teardown():void {
			hasher = null;
		}
		
		/** This really needs to be a theory, will get there eventually 
		 *  Right now this might be the worst test of hashing algorithm ever**/
		[Test]
		public function shouldReturnDifferentHashForDifferentTypes():void {
			var hash1:String = hasher.createHash( "String", "" );
			var hash2:String = hasher.createHash( "Number", "" );
			
			assertThat( hash1, not( hash2 ) );
		}
		
		[Test]
		public function shouldReturnDifferentHashForDifferentAnnotations():void {
			var hash1:String = hasher.createHash( "String", "Test1" );
			var hash2:String = hasher.createHash( "String", "Test2" );
			
			assertThat( hash1, not( hash2 ) );
		}
		
	}
}