package com.blchq.mock {
	import flash.utils.getQualifiedClassName;
	
	public class Proxy {
		private var objectBeingMocked:Object;
		private var stubExpectations:Object = {};

		public function Proxy(objectBeingMocked:Object) {
			this.objectBeingMocked = objectBeingMocked;
		}

		public function buildExpectation(method:String, expectationClass:Class, verifyDeclaration:Boolean=true):Expectation {
			if (this.stubExpectations == null) stubExpectations = new Object();	
			
			var expectation:Expectation = new expectationClass(objectBeingMocked, method);
			
			stubExpectations[method] = expectation;

			// TODO: find a better place for this check, shouldn't be in this class
			if (verifyDeclaration && !MockUtility.isDeclaredByObject(objectBeingMocked, method)) raiseMethodNotStubbedError(objectBeingMocked, method);
			
			return expectation;
		}

		public function invokeStub(name:String, args:Array):* {
			// TODO: make this return a default expectation?
			if (stubExpectations == null || stubExpectations[name] == null) return invokeStubLocally(name, args);
		
			return stubExpectations[name].invoke(args);
		}

		private function raiseMethodNotStubbedError(stubbed:*, method:String):void {
			throw new Error('method ' + method + ' not defined on ' + getQualifiedClassName(stubbed) + '. If it is not defined with a call to invokeStub, stubbing will not function properly.');
		}

		private function invokeStubLocally(name:String, args:Array):* {
			// if class has get foo(), methodOrProp is the value of that
			// if class has function foo(), methodOrProp is the function
			var methodOrProp:* = objectBeingMocked.superMethodOrProp(name);
			return invokeMethod(methodOrProp, args);
		}

		private function invokeMethod(methodOrProp:*, args:Array):* {
			if (methodOrProp is Function) {
				return methodOrProp.apply(objectBeingMocked, args);
			} else {
				return methodOrProp;
			}
		}
	}
}