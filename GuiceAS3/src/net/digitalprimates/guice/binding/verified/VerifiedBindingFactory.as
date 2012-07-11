/**
 * Copyright (c) 2011 Digital Primates
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 * 
 * @author     Michael Labriola 
 * @version	       
 **/ 
package net.digitalprimates.guice.binding.verified {
	import net.digitalprimates.guice.Scopes;
	import net.digitalprimates.guice.binder.IBinder;
	import net.digitalprimates.guice.binding.IBinding;
	import net.digitalprimates.guice.binding.IVerifiedBinding;
	import net.digitalprimates.guice.binding.decoration.VerifiedSessionDecorator;
	import net.digitalprimates.guice.binding.decoration.VerifiedSingletonDecorator;
	import net.digitalprimates.guice.session.ISessionState;

	public class VerifiedBindingFactory {
		protected var binder:IBinder;
		protected var annotation:String = "";
		protected var scope:String;
		private var type:Class;
		private var sessionState:ISessionState;
		
		public function to( dependency:Class ):IVerifiedBinding {
			var binding:IVerifiedBinding = new VerifiedClassBinding( type, annotation, dependency );
			binding.verify( binder.evaluationDomain );
			
			binder.addBinding( withDecoration( binding ) );
			return binding;
		}
		
		public function toInstance( instance:* ):IVerifiedBinding {
			var binding:IVerifiedBinding = new VerifiedInstanceBinding( type, annotation, instance ); 
			binding.verify( binder.evaluationDomain );
			
			binder.addBinding( binding );
			return binding;
		}
		
		public function toProvider( provider:Class ):IVerifiedBinding {
			var binding:IVerifiedBinding = new VerifiedProviderBinding( type, annotation, provider );
			binding.verify( binder.evaluationDomain );
			
			binder.addBinding( withDecoration( binding ) );
			return binding;
		}
		
		protected function withDecoration( binding:IVerifiedBinding ):IBinding {
			if ( scope == Scopes.SINGLETON ) {
				binding = new VerifiedSingletonDecorator( binding );
			} else if ( scope == Scopes.SESSION ) {
				binding = new VerifiedSessionDecorator( binding, sessionState );
			}
			
			return binding;
		}

/*		public function toUnverifiedClassName( dependencyName:String ):IBinding {
			var binding:IBinding = new UnverifiedClassBinding( getQualifiedClassName( type ), annotation, dependencyName );
			binding.verify();
			
			if ( scope == Scopes.SINGLETON ) {
				binding = new UnverifiedSingletonDecorator( binding );
			}
			
			binder.addBinding( binding );
			return binding;
		}*/

		public function annotatedWith( annotation:String ):VerifiedBindingFactory {
			this.annotation = annotation;
			return this;
		}
		
		public function inScope( scope:String ):VerifiedBindingFactory {
			this.scope = scope;
			
			return this;
		}

		public function VerifiedBindingFactory( binder:IBinder, type:Class, sessionState:ISessionState ) {
			this.binder = binder;
			this.type = type;
			this.sessionState = sessionState;
		}
	}
}