package net.digitalprimates.guice.errors
{
	public class ResolutionError extends GuiceError
	{
		public function ResolutionError(dependency:Class, type:Class=null)
		{
			super( "Error attempting to bind " + dependency + " to " + type );
		}
	}
}