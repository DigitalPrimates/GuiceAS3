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
	import flash.system.ApplicationDomain;
	
	import net.digitalprimates.guice.Injector;
	
	import flex.lang.reflect.Klass;

	public class VerifiedClassBinding extends VerifiedBaseBinding {
		protected var dependency:Class;

		override public function verify( evaluationDomain:ApplicationDomain ):void {
			var dependencyInfo:Klass = new Klass( dependency, evaluationDomain );
			var descendsFrom:Boolean = false;
			var implementsInterface:Boolean = false;
			var isClass:Boolean = false;
			
			if ( type == dependency ) {
				isClass = true;
			} else if ( dependencyInfo.implementsInterface( type ) ) {
				implementsInterface = true;
			} else if ( dependencyInfo.descendsFrom( type ) ) {
				descendsFrom = true;
			}
			
			if ( ! ( isClass || implementsInterface || descendsFrom ) ) {
				throwMessage( type, dependency );
			}
		}
		
		override public function provide( injector:Injector ):* {
			return injector.buildClass( dependency );
		}		

		public function VerifiedClassBinding( type:Class, annotation:String, dependency:Class ) {
			super( type, annotation );
			this.dependency = dependency;
		}
	}
}
