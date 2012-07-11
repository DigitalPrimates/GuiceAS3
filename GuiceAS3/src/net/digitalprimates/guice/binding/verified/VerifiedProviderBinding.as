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
	import flash.net.getClassByAlias;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	
	import flex.lang.reflect.Klass;
	import flex.lang.reflect.metadata.MetaDataAnnotation;
	
	import net.digitalprimates.guice.GuiceAnnotations;
	import net.digitalprimates.guice.IProvider;
	import net.digitalprimates.guice.Injector;

	public class VerifiedProviderBinding extends VerifiedBaseBinding {
		private var providerClass:Class;

		override public function verify( evaluationDomain:ApplicationDomain ):void {
			var providerInfo:Klass = new Klass( providerClass, evaluationDomain );
			var providedClassInfo:Klass;;
			var implementsInterface:Boolean = false;
			
			if ( !providerInfo.implementsInterface( IProvider ) ) {
				//throwMessage( type, provider );
				throw new TypeError("Error attempting to provider bind class that does not implement IProvider to " + type );
			}
			
			var annotation:MetaDataAnnotation = providerInfo.getMetaData( GuiceAnnotations.PROVIDES );
			if ( !annotation ) {
				throw new TypeError("Error attempting to provider bind class that does not have Provider metadata to " + type );
			}
			
			var classString:String = annotation.defaultArgument.key;
			try {
				var providedClass:Class = getDefinitionByName( classString ) as Class;
			} catch (e:Error) {
				//safe to ignore as the throw below will deal with this
			}

			if ( !providedClass ) {
				throw new TypeError("Cannot find the class definition " + classString + " provided by Provider for " + type );
			}

			//Is this thing a legal binding for the provider 
			//basically, the validation inside of ClassBinding
			var classBinding:VerifiedClassBinding = new VerifiedClassBinding( type, "", providedClass );
			classBinding.verify( evaluationDomain );
		}

		override public function provide( injector:Injector ):* {
			var providerInstance:IProvider = injector.getInstance( providerClass );
			return providerInstance.get();
		}
		
		public function VerifiedProviderBinding(type:Class, annotation:String, providerClass:Class ) {
			super( type, annotation );
			this.providerClass = providerClass;
		}
	}
}