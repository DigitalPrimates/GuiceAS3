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
package net.digitalprimates.guice.binding {
	import avmplus.getQualifiedClassName;
	
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	import net.digitalprimates.guice.utils.DependencyHasher;
	import net.digitalprimates.guice.verifier.DependencyVerifier;

	public class BinderBase {
		protected var dict:Dictionary;
		protected var hasher:DependencyHasher;
		protected var _evaluationDomain:ApplicationDomain;
		
		public function get evaluationDomain():ApplicationDomain {
			
			if ( _evaluationDomain == null ) {
				_evaluationDomain = ApplicationDomain.currentDomain;
			}
			
			return _evaluationDomain;
		}
		
		public function set evaluationDomain(value:ApplicationDomain):void {
			_evaluationDomain = value;
		}
		
		public function getBinding( type:Class, annotation:String="" ):IBinding {
			var binding:IBinding = dict[ hasher.createHash( getQualifiedClassName( type ), annotation ) ];
			return binding;
		}
		
		public function getBindingByName( typeName:String, annotation:String="" ):IBinding {
			var binding:IBinding = dict[ hasher.createHash( typeName, annotation ) ];
			return binding;
		}
		
		public function addBinding( binding:IBinding ):void {
			dict[ hasher.createHash( binding.typeName, binding.annotation ) ] = binding;
		}
		
		public function verify( verifier:DependencyVerifier ):void {
			var verifiedBinding:IVerifiedBinding;
			for each ( var binding:IBinding in dict ) {
				if ( binding is IVerifiedBinding ) {
					verifiedBinding = binding as IVerifiedBinding;
					
					verifier.verifyDependency( verifiedBinding );
				}
			}
		}
		
		public function BinderBase( hasher:DependencyHasher ) {
			this.hasher = hasher;
			dict = new Dictionary( true );
		}
	}
}