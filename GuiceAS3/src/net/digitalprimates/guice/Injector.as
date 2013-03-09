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
	
	import net.digitalprimates.guice.binder.Binder;
	import net.digitalprimates.guice.binder.IBinder;
	import net.digitalprimates.guice.binding.IBinding;
	import net.digitalprimates.guice.binding.verified.VerifiedBaseBinding;
	import net.digitalprimates.guice.errors.GuiceError;
	import net.digitalprimates.guice.errors.ResolutionError;
	import net.digitalprimates.guice.errors.UnboundInterfaceError;
	import net.digitalprimates.guice.reflect.ConstructorAnnotations;
	
	import reflection.ClassBuilder;
	import reflection.HorribleTypeDefinitionCache;
	import reflection.InjectionPoint;
	import reflection.MethodInjectionPoint;
	import reflection.TypeDescription;

	public class Injector implements IInjector, IBindingResolver, IBindingOwner {
		protected var binder:IBinder;
		
		public function get localBinder():IBinder {
			return binder;
		}

		public function getInstance( type:Class, annotation:String="" ):* {
			return resolveDependency( type, annotation, true );
		}
		
		public function injectMembers( newInstance:* ):void {
			var typeDescription:TypeDescription = HorribleTypeDefinitionCache.getForInstance( newInstance );
			injectMembersType( newInstance, typeDescription );
			injectMembersMethods( newInstance, typeDescription );
		}
		
		public function provideBinding( binding:IBinding ):* {
			throw new Error("TODO DI Refactor");
			return null; //binding.provide( this );
		}

		public function buildClass( dependency:Class ):* {
			var typeDescription:TypeDescription = HorribleTypeDefinitionCache.get( dependency );
			var built:* = buildFromTypeInfo( typeDescription );
			
			injectMembersType( built, typeDescription );
			injectMembersMethods( built, typeDescription );

			return built;
		}

		private function buildFromTypeInfo( typeDescription:TypeDescription ):* {
			var newInstance:*;

			if ( typeDescription.isInterface ) {
				//Okay, this is actually not a class, it is an interface we are being asked to build..
				//can't do that, so return null
				throw new UnboundInterfaceError( typeDescription );
			}

			//First, we need to worry about Constructor dependencies so we can build the class
			var constructorParams:Vector.<InjectionPoint> = typeDescription.constructorPoints;
			var constructorArguments:Array = [];
			var constructorArg:InjectionPoint;
			
			if ( constructorParams ) {
				try {
					for ( var i:int=0; i<constructorParams.length; i++ ) {
						constructorArg = constructorParams[ i ];
		
						constructorArguments[ i ] = 
													resolveDependency( constructorArg.type, 
																	   constructorArg.annotation,
																	   constructorArg.optional );
					}
				}
				
				catch ( e:GuiceError ) {
					if ( typeDescription.requiredConstructorArgCount < i ) {
						//We have reached the end of our resolvable dependencies
						//this means at least one dependency cannot be built.
						//If the constructor has optional arguments this might be okay
						//deal later
						//if ( !type.constructor.canInstantiateWithParams( constructorArguments ) ) { 
						throw e;
						//}
					}
				}
			}
			
			newInstance = ClassBuilder.newInstanceApply( typeDescription, constructorArguments );
			
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
		
		private function resolveDependency( dependency:Class, annotation:String="", optional:Boolean=false ):* {
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

		private function injectMembersMethods( newInstance:*, typeDefinition:TypeDescription ):void {
			var methods:Vector.<MethodInjectionPoint> = typeDefinition.methodPoints;
			var method:MethodInjectionPoint;
			var invocationArgs:Array;
			var paramTypes:Array;

			if ( methods ) {
				for ( var j:int=0;j<methods.length; j++ ) {
					method = methods[ j ];
					
					//If we are annotated with Inject
					invocationArgs = [];
					if ( method.parameters ) {
						for ( var i:int=0; i<method.parameters.length; i++ ) {
							invocationArgs.push( resolveDependency( method.parameters[ i ].type, method.annotation ) );
						}
					}
					
					ClassBuilder.methodApply( newInstance, method.name, invocationArgs );
				}
			}
		}

		private function injectMembersType( newInstance:*, typeDefinition:TypeDescription ):void {
			var fields:Vector.<InjectionPoint> = typeDefinition.fieldPoints;
			var field:InjectionPoint;
			
			if ( fields ) {
				for ( var j:int=0;j<fields.length; j++ ) {
					field = fields[ j ];
	
					newInstance[ field.name ] = resolveDependency( field.type, field.annotation, false );
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