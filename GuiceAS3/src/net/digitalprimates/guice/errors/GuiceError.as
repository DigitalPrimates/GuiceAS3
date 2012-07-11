package net.digitalprimates.guice.errors
{
	public class GuiceError extends Error
	{
		public function GuiceError(message:*="", id:*=0)
		{
			super(message, id);
		}
	}
}