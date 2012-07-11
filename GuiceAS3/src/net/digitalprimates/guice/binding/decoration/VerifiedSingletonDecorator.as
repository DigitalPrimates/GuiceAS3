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
package net.digitalprimates.guice.binding.decoration {
	import flash.system.ApplicationDomain;
	
	import net.digitalprimates.guice.Injector;
	import net.digitalprimates.guice.binding.IBinding;
	import net.digitalprimates.guice.binding.IVerifiedBinding;
	
	public class VerifiedSingletonDecorator implements IVerifiedBinding, IBindingDecorator {
		private var binding:IVerifiedBinding;
		private var instance:*;

		public function get decorating():IBinding {
			return binding;
		}
		
		public function get annotation():String {
			return binding.annotation;
		}
		
		public function set annotation(value:String):void {
			binding.annotation = value;
		}
		
		public function get type():Class {
			return binding.type;
		}
		
		public function set type(value:Class):void {
			binding.type = value;
		}

		public function get typeName():String {
			return binding.typeName;
		}
		
		public function set typeName(value:String):void {
			binding.typeName = value;
		}		
		
		public function verify( evaluationDomain:ApplicationDomain ):void {
			binding.verify( evaluationDomain );
		}

		public function provide(injector:Injector):* {
			if ( !instance ) {
				instance = injector.buildClass(type);
			}
			return instance;
		}

		public function VerifiedSingletonDecorator( binding:IVerifiedBinding ) {
			this.binding = binding;
		}

	}
}
