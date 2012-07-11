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
	import flash.utils.Dictionary;
	
	import flex.lang.reflect.Field;
	import flex.lang.reflect.InjectionClass;
	import flex.lang.reflect.Klass;
	import flex.lang.reflect.Method;
	import flex.lang.reflect.constructor.ConstructorArg;
	import flex.lang.reflect.metadata.MetaDataAnnotation;
	import flex.lang.reflect.metadata.MetaDataArgument;
	
	import net.digitalprimates.guice.binder.Binder;
	import net.digitalprimates.guice.binder.IBinder;
	import net.digitalprimates.guice.binding.IBinding;
	import net.digitalprimates.guice.binding.verified.VerifiedBaseBinding;
	import net.digitalprimates.guice.errors.GuiceError;
	import net.digitalprimates.guice.errors.ResolutionError;
	import net.digitalprimates.guice.errors.UnboundInterfaceError;
	import net.digitalprimates.guice.reflect.ConstructorAnnotations;

	public class Injector implements IInjector, IBindingResolver, IBindingOwner {
		protected var binder:IBinder;
		
		public function get localBinder():IBinder {
			return binder;
		}

		public function getInstance( type:Class, annotation:String="" ):* {
			return resolveDependency( type, annotation, true );
		}
		
		public function injectMembers( newInstance:* ):void {
			var type:InjectionClass = new InjectionClass( newInstance.constructor, binder.evaluationDomain );
			injectMembersType( newInstance, type );
			injectMembersMethods( newInstance, type );
		}
		
		public function provideBinding( binding:IBinding ):* {
			throw new Error("TODO DI Refactor");
			return null; //binding.provide( this );
		}

		private function buildClass( dependency:Class ):* {
			var type:Klass = new InjectionClass( dependency, binder.evaluationDomain );
			var built:* = buildFromTypeInfo( type );
			
			injectMembersType( built, type );
			injectMembersMethods( built, type );

			return built;
		}

		private function buildFromTypeInfo( type:Klass ):* {
			var newInstance:*;

			if ( type.isInterface ) {
				//Okay, this is actually not a class, it is an interface we are being asked to build..
				//can't do that, so return null
				throw new UnboundInterfaceError( type );
			}

			//First, we need to worry about Constructor dependencies so we can build the class
			var constructorParams:Array = type.constructor.parameterTypes;
			var constructorAnnotations:ConstructorAnnotations = new ConstructorAnnotations( type ); 
			var constructorArguments:Array = [];
			var constructorArg:ConstructorArg;
			
			try {
				for ( var i:int=0; i<constructorParams.length; i++ ) {
					constructorArg = constructorParams[ i ] as ConstructorArg;
	
					constructorArguments[ i ] = 
												resolveDependency( constructorArg.type, 
																   constructorAnnotations.getAnnotationAt( i ),
																   constructorArg.required );
				}
			}
			
			catch ( e:GuiceError ) {
				//We have reached the end of our resolvable dependencies
				//this means at least one dependency cannot be built.
				//If the constructor has optional arguments this might be okay
				if ( !type.constructor.canInstantiateWithParams( constructorArguments ) ) { 
					throw e;
				}
			}
			newInstance = type.constructor.newInstanceApply( constructorArguments );
			
			return newInstance;
		}
		
		public function getBinding( dependency:Class, annotation:String="" ):IBinding {
			var baseBinding:IBinding = binder.getBinding( dependency, annotation );
			
			if ( ( !baseBinding ) && ( annotation != "" ) ) {
				//If we didn't find the one with the annotation, default up to no annotation
				baseBinding = binder.getBinding( dependency );
			}
			
			return baseBinding;
		}
		
		private function resolveDependency( dependency:Class, annotation:String="", required:Boolean=true ):* {
			var baseBinding:IBinding = getBinding( dependency, annotation );
			var newInstance:*;
			
			if ( baseBinding ) {
				newInstance = baseBinding.provide( this );
			} else {
				//well, we didn't find this particular dependency in our map... 
				//so we will try to build it, assuming we have all needed dependencies to do so
				if ( !isSimple( dependency ) ) {
					newInstance = buildClass( dependency );
				} else {
					throw new ResolutionError( dependency );
				}
			}
			
			return newInstance;
		}

		private function injectMembersMethods( newInstance:*, type:Klass ):void {
			var methods:Array = type.methods;
			var method:Method;
			var fieldAnnotation:MetaDataAnnotation;
			var invocationArgs:Array;
			var paramTypes:Array;

			for ( var j:int=0;j<methods.length; j++ ) {
				method = methods[ j ];
				
				//Worry about static soon
				fieldAnnotation = method.getMetaData( GuiceAnnotations.INJECT );
				if ( fieldAnnotation ) {
					//If we are annotated with Inject
					var scope:String = "";
					if ( fieldAnnotation.defaultArgument ) {
						scope = fieldAnnotation.defaultArgument.key
					}

					paramTypes = method.parameterTypes;
					invocationArgs = [];

					if ( paramTypes ) {
						for ( var i:int=0; i<paramTypes.length; i++ ) {
							invocationArgs.push( resolveDependency( paramTypes[ i ], scope ) );
						}
					}
					
					method.apply( newInstance, invocationArgs )
				}
			}

		}

		private function injectMembersType( newInstance:*, type:Klass ):void {
			var fields:Array = type.fields;
			var field:Field;
			var fieldAnnotation:MetaDataAnnotation;
			
			for ( var j:int=0;j<fields.length; j++ ) {
				field = fields[ j ];

				//Worry about static soon
				fieldAnnotation = field.getMetaData( GuiceAnnotations.INJECT );
				if ( fieldAnnotation ) {
					//If we are annotated with Inject
					var annotation:String = "";
					if ( fieldAnnotation.defaultArgument ) {
						annotation = fieldAnnotation.defaultArgument.key
					}
					newInstance[ field.name ] = resolveDependency( field.type, annotation, false );
				}
			}
		}

		/**Move me**/
		public static function isSimple( value:Class ):Boolean
		{
			switch ( value )
			{
				case Number:
				case int:
				case uint:
				case String:
				case Boolean:
				{
					return true;
				}
					
				case Object:
				{
					return (value is Date) || (value is Array);
				}
			}
			
			return false;
		}

		
		public function Injector( binder:IBinder ) {
			this.binder = binder;
		}
	}
}