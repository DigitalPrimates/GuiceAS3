package reflection {
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	
	import net.digitalprimates.guice.GuiceAnnotations;

	public class TypeDescription {
		
		public var constructorPoints:Vector.<InjectionPoint>;
		public var methodPoints:Vector.<MethodInjectionPoint>;
		public var fieldPoints:Vector.<InjectionPoint>;
		public var type:Class;
		public var name:String;
		public var isInterface:Boolean;
		public var requiredConstructorArgCount:int = 0;
		
		private function parseMe():void {
			var jsonDef:Object = HorribleJSONCache.get( type );
	
			this.name =  jsonDef.name;
			
			if ( jsonDef.traits.bases.length > 0 ) {
				isInterface = false;
			} else {
				isInterface = true;
				//dont do this work
				return;
			}
						
			var constructor : Array = jsonDef.traits.constructor;
			var methods : Array = jsonDef.traits.methods;
			var method : Object;
			var variables : Array = jsonDef.traits.variables;
			var accessors : Array = jsonDef.traits.accessors;
			var i:int = 0;
			var j:int = 0;
			var k:int = 0;
			var metadata:Array;
			const INJECT:String = GuiceAnnotations.INJECT;
			const READWRITE:String = "readwrite";
			const WRITEONLY:String = "writeonly";
			
			if ( constructor ) {
				this.constructorPoints = new Vector.<InjectionPoint>( constructor.length, true ) ;
				for ( i = 0; i<constructor.length; i++ ) {
					if ( !constructor[i].optional ) {
						requiredConstructorArgCount++;
					}
					constructorPoints[i] = new InjectionPoint( getDefinitionByName(constructor[i].type) as Class, constructor[i].optional );
				}
			}

			if ( methods ) {
				this.methodPoints = new Vector.<MethodInjectionPoint>();
				for ( i = 0; i<methods.length; i++ ) {
					
					method = methods[i];
					metadata = method.metadata;
					
					if ( metadata ) {
						for ( j = 0; j<metadata.length; j++ ) {
							if ( metadata[j].name == INJECT ) {
								//We now care about this method
								var numParams:int = 0;
								if ( method.parameters ) {
									numParams = method.parameters.length;
								}
								var parameters:Vector.<InjectionPoint> = new Vector.<InjectionPoint>( numParams, true );
								for ( k=0; k<numParams; k++ ) {
									parameters[k] = new InjectionPoint( getDefinitionByName( method.parameters[k].type ) as Class, method.parameters[k].optional ); 
								}
								
								//TODO: we need to put annotation support right here
								this.methodPoints.push( new MethodInjectionPoint( method.name, "", parameters ) );  
								
								break;
							}
						}
					}
				}
			}

			var field:Object;
			if ( variables || accessors ) {
				this.fieldPoints = new Vector.<InjectionPoint>() ;

				if ( variables ) {
					for ( i = 0; i<variables.length; i++ ) {
						field = variables[i];
						metadata = field.metadata;
						
						if ( field.access == READWRITE || field.access == WRITEONLY ) {
							if ( metadata ) {
								for ( j = 0; j<metadata.length; j++ ) {
									if ( metadata[j].name == INJECT ) {
										//We now care about this variable
										this.fieldPoints.push( new InjectionPoint( getDefinitionByName( field.type ) as Class, true, field.name ) ); 
										break;
									}
								}
							}
						}
					}
				}

				if ( accessors ) {
					for ( i = 0; i<accessors.length; i++ ) {
						field = accessors[i];
						metadata = field.metadata;
						
						if ( field.access == READWRITE || field.access == WRITEONLY ) {
							if ( metadata ) {
								for ( j = 0; j<metadata.length; j++ ) {
									if ( metadata[j].name == INJECT ) {
										//We now care about this accessor
										this.fieldPoints.push( new InjectionPoint( getDefinitionByName( field.type ) as Class, true, field.name ) ); 
										break;
									}
								}
							}
						}
					}
				}

			}
		}
		

		public function TypeDescription( type:Class ) {
			this.type = type;
			parseMe();
		}
	}
}