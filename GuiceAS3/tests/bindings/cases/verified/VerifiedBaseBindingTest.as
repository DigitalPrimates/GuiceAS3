package bindings.cases.verified {
	import flash.display.Sprite;
	
	import net.digitalprimates.guice.binding.verified.VerifiedBaseBinding;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;

	public class VerifiedBaseBindingTest {

		[Test]
		public function shouldReturnNullForType():void {
			var binding:VerifiedBaseBinding = new VerifiedBaseBinding( null, null );
			assertNull( binding.type );
		}

		[Test]
		public function shouldReturnNullForAnnotation():void {
			var binding:VerifiedBaseBinding = new VerifiedBaseBinding( null, null );
			assertNull( binding.annotation );
		}

		[Test]
		public function shouldReturnSpriteForType():void {
			var binding:VerifiedBaseBinding = new VerifiedBaseBinding( Sprite, null );
			assertEquals( Sprite, binding.type );
		}

		[Test]
		public function shouldReturnSpriteForTypeName():void {
			var binding:VerifiedBaseBinding = new VerifiedBaseBinding( Sprite, null );
			assertEquals( "flash.display::Sprite", binding.typeName );
		}

		[Test]
		public function shouldReturnAnnotatedForAnnotation():void {
			var binding:VerifiedBaseBinding = new VerifiedBaseBinding( null, "Annotated" );
			assertEquals( "Annotated", binding.annotation );
		}
	}
}