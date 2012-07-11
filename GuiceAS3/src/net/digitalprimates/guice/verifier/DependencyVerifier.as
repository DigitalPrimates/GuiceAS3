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
package net.digitalprimates.guice.verifier {
	import net.digitalprimates.guice.GuiceAnnotations;
	import net.digitalprimates.guice.binder.IBinder;
	import net.digitalprimates.guice.binding.IBinding;
	import net.digitalprimates.guice.binding.IVerifiedBinding;
	import net.digitalprimates.guice.binding.decoration.IBindingDecorator;
	import net.digitalprimates.guice.binding.verified.VerifiedProviderBinding;
	import net.digitalprimates.guice.reflect.ConstructorAnnotations;
	import net.digitalprimates.guice.utils.CircularResolutionWatcher;
	import net.digitalprimates.guice.utils.KlassFactory;
	
	import flex.lang.reflect.Field;
	import flex.lang.reflect.Klass;
	import flex.lang.reflect.constructor.ConstructorArg;
	import flex.lang.reflect.metadata.MetaDataAnnotation;
	import flex.lang.reflect.metadata.MetaDataArgument;
	
	public class DependencyVerifier {
		
		private var binder:IBinder;
		private var watcher:CircularResolutionWatcher;
		private var klassFactory:KlassFactory;
		
		public function verifyDependency( verifiedBinding:IVerifiedBinding ):void {
			var klass:Klass;
			
			if ( !watcher.isComplete( verifiedBinding.typeName, verifiedBinding.annotation ) ) {
				klass = new Klass( verifiedBinding.type, binder.evaluationDomain );
				recursivelyVerifyDependency( null, klass, verifiedBinding.annotation, this );
			}
		}
		
		public function verifyConstructor( klass:Klass, constructorAnnotations:ConstructorAnnotations, childVerifier:DependencyVerifier ):Boolean {
			var constructorParams:Array = klass.constructor.parameterTypes;
			
			var constructorArg:ConstructorArg;
			for ( var i:int=0; i<constructorParams.length; i++ ) {
				
				constructorArg = ( constructorParams[ i ] as ConstructorArg );
				
				if ( constructorArg.required ) {
					//Need refactored way to get constructor dependencies
					childVerifier.recursivelyVerifyDependency( klass, 
						klassFactory.newInstance( constructorArg.type, binder.evaluationDomain ), 
						constructorAnnotations.getAnnotationAt( i ), 
						childVerifier );
				}
			}
			
			return true;
		}
		
		public function verifyFields( klass:Klass, childVerifier:DependencyVerifier ):Boolean {
			var fields:Array = klass.fields;
			var field:Field;
			var fieldAnnotation:MetaDataAnnotation;
			
			for ( var j:int=0;j<fields.length; j++ ) {
				field = fields[ j ];
				//Worry about static soon
				fieldAnnotation = field.getMetaData( GuiceAnnotations.INJECT );
				if ( fieldAnnotation ) {
					//If we are annotated with Inject
					var scope:String = "";
					var defaultArgument:MetaDataArgument = fieldAnnotation.defaultArgument; 
					if ( defaultArgument ) {
						scope = defaultArgument.key
					}
					
					childVerifier.recursivelyVerifyDependency( klass, klassFactory.newInstance( field.type, binder.evaluationDomain ), scope, childVerifier );
				}
			}
			
			return true;
		}
		
		public function recursivelyVerifyDependency( parentDependency:Klass, dependency:Klass, annotation:String, verifier:DependencyVerifier ):void {
			//Two types of dependencies we are worried about right now..
			var baseBinding:IBinding = binder.getBindingByName( dependency.name, annotation );
			
			if ( watcher.isInProcess( dependency.name, annotation ) ) {
				//We have an issue. There is a circular dependency in our code
				throwCircularError( dependency, parentDependency );
			}
			
			//If we actually have a ProviderBinding then we don't need to do this work
			//Or if we are decorating a provider bii wnding 
			if ( ( baseBinding is VerifiedProviderBinding ) || 
				 ( ( baseBinding is IBindingDecorator ) &&
				   ( ( baseBinding as IBindingDecorator ).decorating is VerifiedProviderBinding ) )	) {
				return;
			}
			
			watcher.beginResolution( dependency.name, annotation ); 
			
			var constructorAnnotations:ConstructorAnnotations = new ConstructorAnnotations( dependency );
			var constructorVerified:Boolean = verifyConstructor( dependency, constructorAnnotations, verifier );
			var fieldsVerified:Boolean = verifyFields( dependency, verifier );
			
			watcher.completeResolution( dependency.name, annotation );
			
			if ( !( constructorVerified && fieldsVerified ) ) {
				throwNoResolveError( dependency, parentDependency );
			}
		}
		
		private function throwCircularError( dependency:Klass, parentDependency:Klass ):void {
			if ( parentDependency ) {
				throw new Error("Circular dependency found when resolving " + dependency.name + " in class " + parentDependency.name );	
			} else {
				throw new Error("Circular dependency found when resolving for class " + dependency.name  );
			}			
		}
		
		private function throwNoResolveError( dependency:Klass, parentDependency:Klass ):void {
			if ( parentDependency ) {
				throw new Error("Cannot resolve dependencies " + dependency.name + " in class " + parentDependency.name );	
			} else {
				throw new Error("Cannot resolve dependencies for class " + dependency.name  );
			}			
		}
		
		public function DependencyVerifier( binder:IBinder, watcher:CircularResolutionWatcher, klassFactory:KlassFactory ) {
			this.binder = binder;
			this.watcher = watcher;
			this.klassFactory = klassFactory;
		}
	}
}