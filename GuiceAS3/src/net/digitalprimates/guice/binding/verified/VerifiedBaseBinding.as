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
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import net.digitalprimates.guice.Injector;
	import net.digitalprimates.guice.binding.IBinding;
	import net.digitalprimates.guice.binding.IVerifiedBinding;
	
	import reflection.HorribleJSONCache;
	import reflection.TypeDescription;

	public class VerifiedBaseBinding implements IVerifiedBinding {
		private var _typeName:String;
		private var _type:Class;
		private var _annotation:String;
		
		public function get annotation() : String {
			return _annotation;
		}

		public function set annotation(value:String):void {
			_annotation = value;
		}

		public function get type():Class {
			return _type;
		}

		public function set type(value:Class):void {
			_type = value;			
		}
		
		public function get typeName():String {
			return _typeName;
		}
		
		public function set typeName(value:String):void {
			_typeName = value;
		}

		public function provide( injector:Injector ):* {
			return null;
		}
		
		public function verify( evaluationDomain:ApplicationDomain ):void {
		}
	
		protected function implementsUs( typeDefinition:TypeDescription ):Boolean {
			//typeDefinition is binder
			//type is ibinder
			
			var instance:Object = HorribleJSONCache.get( typeDefinition.type );
			var inter:Array = instance.traits.interfaces;

			for ( var i:int=0; i<inter.length; i++ ) {
				if ( getDefinitionByName( inter[ i ] ) == type ) {
					return true;
				}
			}
			
			return false;
		}

		protected function descendsFromUs( typeDefinition:TypeDescription ):Boolean {
			var instance:Object = HorribleJSONCache.get( typeDefinition.type );
			var bases:Array = instance.traits.bases;
			
			if ( bases ) {
				for ( var i:int=0; i<bases.length; i++ ) {
					if ( getDefinitionByName( bases[ i ] ) == type ) {
						return true;
					}
				}				
			}

			
			return false;
		}

		public static function throwMessage( type:Class, dependency:* ):void {
			throw new TypeError("Error attempting to bind " + dependency + " to " + type );
		}

		public function VerifiedBaseBinding( type:Class, annotation:String ) {
			this.type = type;
			this.annotation = annotation;
			
			if ( type ) {
				this.typeName = getQualifiedClassName( type );
			}
		}
	}
}
