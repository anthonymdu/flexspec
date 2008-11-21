package com.blchq.mock {
	import flash.utils.describeType;
	
	import mx.utils.ObjectUtil;
	
	public class MockUtility {
		public static function methodsOrAccessorsDeclaredBy(object:Object):Array {
			var typeInfo:XML = describeType(object);
			var typeName:String = typeInfo.attribute('name');
			var methods:Array = [];
			
			for each (var methodInfo:XML in typeInfo.method) {
				if (methodInfo.attribute('declaredBy') == typeName) {
					methods.push(methodInfo.attribute('name'));
				}
			}
			for each (methodInfo in typeInfo.accessor) {
				if (methodInfo.attribute('declaredBy') == typeName) {
					methods.push(methodInfo.attribute('name'));
				}
			}
			return methods;
		}
		
		public static function isDeclaredByObject(object:Object, methodName:String):Boolean {
			var matchFound:Boolean = methodsOrAccessorsDeclaredBy(object).some(function(method:String, i:uint, a:Array):Boolean {
				return method == methodName;
			});
			return matchFound;
		}
	}
}