package com.blchq.mock {
	public class Proxy {
		private var objectBeingMocked:Object;
		private var stubExpectations:Object = {};

		public function Proxy(objectBeingMocked:Object) {
			this.objectBeingMocked = objectBeingMocked;
		}

		public function buildExpectation(method:String, expectationClass:Class):Expectation {
			if (this.stubExpectations == null) stubExpectations = new Object();	
			
			var expectation:Expectation = new expectationClass(objectBeingMocked, method);
			
			stubExpectations[method] = expectation;
			
			return expectation;
		}

		public function invokeStub(name:String, args:Array):* {
			// TODO: make this return a default expectation?
			if (stubExpectations == null || stubExpectations[name] == null) return invokeStubLocally(name, args);
		
			return stubExpectations[name].invoke(args);
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