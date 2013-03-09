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
package net.digitalprimates.guice {
	import net.digitalprimates.guice.binder.Binder;
	import net.digitalprimates.guice.binder.IBinder;
	import net.digitalprimates.guice.session.ISessionState;
	import net.digitalprimates.guice.session.SessionState;
	import net.digitalprimates.guice.utils.CircularResolutionWatcher;
	import net.digitalprimates.guice.utils.DependencyHasher;
	import net.digitalprimates.guice.verifier.DependencyVerifier;

	public class Guice {
		
		public static function createInjector( module:IGuiceModule=null ):IInjector {
			var hasher:DependencyHasher = new DependencyHasher();
			var sessionState:ISessionState = new SessionState();
			var binder:Binder = new Binder( hasher, sessionState );

			if ( module ) {
				module.configure( binder );	
			}
			
			var injector:IInjector = new Injector( binder );

			//Verify before registering the injector to save a few cycles
			var watcher:CircularResolutionWatcher = new CircularResolutionWatcher( hasher );
			var verifier:DependencyVerifier = new DependencyVerifier( binder, watcher );
			binder.verify( verifier );

			//Always add the Injector as a registered binding
			//If someone wants it injected, they can have it
			//binder.bind( Injector ).toInstance( injector );
			binder.bind( IInjector ).toInstance( injector );
			binder.bind( ISessionState ).inScope( Scopes.SINGLETON ).toInstance( sessionState );
			binder.bind( IBinder ).to( Binder );

			return injector;
		}
		
		public function Guice() {
		}
	}
}