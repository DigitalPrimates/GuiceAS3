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
package net.digitalprimates.guice.binder {
	import flash.system.ApplicationDomain;
	
	import net.digitalprimates.guice.binding.IBinding;
	import net.digitalprimates.guice.binding.verified.VerifiedBindingFactory;
	import net.digitalprimates.guice.verifier.DependencyVerifier;

	public interface IBinder {
		function get evaluationDomain():ApplicationDomain;
		function set evaluationDomain(value:ApplicationDomain):void;
		
		function getBinding( type:Class, annotation:String="" ):IBinding;
		function getBindingByName( typeName:String, annotation:String="" ):IBinding;
		
		function addBinding( binding:IBinding ):void;
		
		function verify( verifier:DependencyVerifier ):void;
		
		function bind( clazz:Class ):VerifiedBindingFactory;
		
	}
}