package bindings {
	import bindings.cases.decorators.UnverifiedSingletonDecoratorTest;
	import bindings.cases.decorators.VerifiedSingletonDecoratorTest;
	import bindings.cases.unverified.UnverifiedSuite;
	import bindings.cases.verified.VerifiedBaseBindingTest;
	import bindings.cases.verified.VerifiedBindingFactoryTest;
	import bindings.cases.verified.VerifiedClassBindingTest;
	import bindings.cases.verified.VerifiedInstanceBindingTest;
	import bindings.cases.verified.VerifiedProviderBindingTest;
	import bindings.cases.verified.VerifiedSuite;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class BindingSuite {
		public var test1:VerifiedSuite;
		public var test2:UnverifiedSuite;
		public var test3:VerifiedSingletonDecoratorTest;
		public var test4:UnverifiedSingletonDecoratorTest;
	}
}