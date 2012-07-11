package bindings.cases.unverified {
	import flash.display.Sprite;
	
	import net.digitalprimates.guice.binding.unverified.UnverifiedBaseBinding;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNull;
	
	public class UnverifiedBaseBindingTest {
		[Test]
		public function shouldReturnNullForType():void {
			var binding:UnverifiedBaseBinding = new UnverifiedBaseBinding( null, null );
			assertNull( binding.type );
		}
		
		[Test]
		public function shouldReturnNullForAnnotation():void {
			var binding:UnverifiedBaseBinding = new UnverifiedBaseBinding( null, null );
			assertNull( binding.annotation );
		}
		
		[Test]
		public function shouldReturnSpriteForTypeName():void {
			var binding:UnverifiedBaseBinding = new UnverifiedBaseBinding( "flash.display::Sprite", null );
			assertEquals( "flash.display::Sprite", binding.typeName );
		}

		[Test]
		public function shouldReturnNullForTypeWhenProvidedAsString():void {
			var binding:UnverifiedBaseBinding = new UnverifiedBaseBinding( "flash.display::Sprite", null );
			assertNull( binding.type );
		}

		[Test]
		public function shouldReturnAnnotatedForAnnotation():void {
			var binding:UnverifiedBaseBinding = new UnverifiedBaseBinding( null, "Annotated" );
			assertEquals( "Annotated", binding.annotation );
		}			
	}
}