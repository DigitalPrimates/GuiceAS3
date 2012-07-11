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
package net.digitalprimates.guice.reflect {
	import flex.lang.reflect.Klass;
	import flex.lang.reflect.metadata.MetaDataAnnotation;
	import flex.lang.reflect.metadata.MetaDataArgument;
	
	import net.digitalprimates.guice.GuiceAnnotations;

	public class ConstructorAnnotations {

		private var klass:Klass;
		private var annotations:Array;
		
		public function getAnnotationAt( index:int ):String {
			var annotation:String = "";

			if (!annotations) {
				annotations = constructorAnnotations;
			}
			
			if ( annotations.length > index ) {
				annotation = annotations[ index ];
			}
			
			return annotation?annotation:"";
		}

		private function get constructorAnnotations():Array {
			/**
			 * ActionScript constructor metadata does not exist, so we have to note it on the class
			 * level. Further, constructor param names are not preserved, only type and index, so
			 * we need to handle it as such
			 * 
			 * [Constructor(index=0,annotation="female")]
			 * [Constructor(index=1,annotation="male")]
			 **/
			
			if ( annotations ) {
				return annotations;
			}
			
			var annotationArray:Array = new Array();
			var classAnnotation:MetaDataAnnotation;
			var argument:MetaDataArgument;
			
			var len:int = klass.metadata.length;
			for ( var j:int=0; j<len; j++ ) {
				classAnnotation = ( klass.metadata[ j ] as MetaDataAnnotation );
				if ( classAnnotation.name == GuiceAnnotations.CONSTRUCTOR ) {
					var index:int = 0;
					argument = classAnnotation.getArgument( GuiceAnnotations.INDEX, true );
					
					if ( argument ) {
						index = Number( argument.value );
					}
					
					var annotation:String = "";
					argument = classAnnotation.getArgument( GuiceAnnotations.ANNOTATION, true );
					
					if ( argument ) {
						annotation = argument.value;
					}
					
					annotationArray[ index ] = annotation;
				} 
			}
			
			annotations = annotationArray;
			
			return annotations;
		}
		
		public function ConstructorAnnotations( klass:Klass ) {
			this.klass = klass;
		}
	}
}