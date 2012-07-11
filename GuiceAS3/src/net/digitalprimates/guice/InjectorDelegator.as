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
	import avmplus.getQualifiedClassName;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import net.digitalprimates.guice.binder.Binder;
	import net.digitalprimates.guice.binder.IBinder;
	import net.digitalprimates.guice.binding.IBinding;
	import net.digitalprimates.guice.utils.InjectorMap;
	import net.digitalprimates.guice.utils.events.InjectorAddedEvent;

	public class InjectorDelegator implements IInjector, IBindingOwner {
		public var globalInjector:IInjector;
		private var injectorMap:InjectorMap;
		private var resolvedPackageMap:Dictionary;

		protected function splitModuleClassName( name:String ):String
		{
			// Our convention for requesting a feature is:
			//
			// moduleName.path.to.class.ClassName
			//
			// Where to moduleName effectively becomes part of the dot path syntax
			var libraryClassDivider:RegExp = /\.|::/i;
			var libraryClassDividerLength:int = 1; //.'
			
			var libraryClassDividerIndex:int = name.search( libraryClassDivider );
			var leadPackage:String = "";

			if ( libraryClassDividerIndex != -1 ) {
				leadPackage = name.substr( 0, libraryClassDividerIndex + (libraryClassDividerLength-1) );
			}

			return leadPackage;
		}
		
		protected function findAndCacheInjector( type:Class ):IInjector {
			var injector:IInjector;
			
			injector = resolvedPackageMap[ type ];
			
			if ( !injector ) {
				var leadPackage:String = splitModuleClassName( getQualifiedClassName( type ) );
				injector = injectorMap.getInjectorForPackage( leadPackage );
				
				if ( !injector ) {
					injector = globalInjector;
				}
				
				resolvedPackageMap[ type ] = injector;
			}
			
			return injector;
		}
		
		public function get localBinder() : IBinder {
			return ( globalInjector is IBindingOwner ) ? ( globalInjector as IBindingOwner ).localBinder : null;
		}

		public function injectMembers(newInstance:*):void {
			globalInjector.injectMembers( newInstance );
		}

		public function provideBinding( binding:IBinding ):* {
			var injector:IInjector = findAndCacheInjector( binding.type );
			
			throw new Error("TODO DI Refactor");
			return null; //injector.provideBinding( binding );
		}
		
		public function getInstance( type:Class, annotation:String="" ):* {
			var injector:IInjector = findAndCacheInjector( type );
			
			return injector.getInstance( type, annotation );
		}
		
		private function invalidateResolvedPackages( event:InjectorAddedEvent ):void {
			//We may make this more complicated later, for now, unresolve all packages, later, we may just unresolve those with this package
			this.resolvedPackageMap = new Dictionary();
		}
		
		public function InjectorDelegator( globalInjector:IInjector, injectorMap:InjectorMap ) {
			this.globalInjector = globalInjector;
			this.injectorMap = injectorMap;
			this.resolvedPackageMap = new Dictionary();
			
			if ( injectorMap ) {
				injectorMap.addEventListener( InjectorAddedEvent.INJECTOR_ADDED, invalidateResolvedPackages, false, 0, true );
			}
		}
	}
}