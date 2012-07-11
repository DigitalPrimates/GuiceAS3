package bindings.cases.verified {
	import bindings.cases.verified.VerifiedBaseBindingTest;
	import bindings.cases.verified.VerifiedBindingFactoryTest;
	import bindings.cases.verified.VerifiedClassBindingTest;
	import bindings.cases.verified.VerifiedInstanceBindingTest;
	import bindings.cases.verified.VerifiedProviderBindingTest;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class VerifiedSuite {
		public var test1:VerifiedBaseBindingTest;
		public var test2:VerifiedClassBindingTest;
		public var test3:VerifiedInstanceBindingTest;
		public var test4:VerifiedProviderBindingTest;
		public var test5:VerifiedBindingFactoryTest;
	}
}