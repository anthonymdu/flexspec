package com.blchq.mock {
	public class MockInfo {
		private var objectBeingMocked:Object;
		private var stubExpectations:Object = {};
		
		public function MockInfo(objectBeingMocked:Object) {
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
				// this is ugly, but I don't know a way in ActionScript to
				// expand out an array and pass it during a method call. What I want is the
				// ActionScript equivalent of this ruby:
				// def method(methodOrProp, *args)
				//    methodOrProp(*args)
				// end
				switch (args.length) {
					case 0:
						return methodOrProp();
					case 1:
						return methodOrProp(args[0]);
					case 2:
						return methodOrProp(args[0], args[1]);
					case 3:
						return methodOrProp(args[0], args[1], args[2]);
					case 4:
						return methodOrProp(args[0], args[1], args[2], args[3]);
					case 5:
						return methodOrProp(args[0], args[1], args[2], args[3], args[4]);
					case 6:
						return methodOrProp(args[0], args[1], args[2], args[3], args[4], args[5]);
					case 7:
						return methodOrProp(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
					default:
						return methodOrProp(args); // TODO: test this case, probably isn't right
				}
			} else {
				return methodOrProp;
			}
		}
	}
}