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
package net.digitalprimates.guice.utils {
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	public class CircularResolutionWatcher {
		private static const BEGAN:String = "began";
		private static const COMPLETED:String = "completed";
		
		private var hasher:DependencyHasher;
		private var dict:Dictionary;
		
		public function isInProcess( typeName:String, annotation:String ):Boolean {
			var hash:String = hasher.createHash( typeName, annotation );
			return ( dict[ hash ] == BEGAN );
		}

		public function isComplete( typeName:String, annotation:String ):Boolean {
			var hash:String = hasher.createHash( typeName, annotation );
			return ( dict[ hash ] == COMPLETED );
		}

		public function beginResolution( typeName:String, annotation:String ):void {
			var hash:String = hasher.createHash( typeName, annotation );
			dict[ hash ] = BEGAN;
		}
		
		public function completeResolution( typeName:String, annotation:String ):void {
			var hash:String = hasher.createHash( typeName, annotation );
			dict[ hash ] = COMPLETED;
		}
		
		public function CircularResolutionWatcher( hasher:DependencyHasher ) {
			this.hasher = hasher;
			dict = new Dictionary( true );
		}
	}
}