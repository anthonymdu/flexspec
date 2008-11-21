package com.blchq.mock {
	import com.blchq.unit.TestCaseExt; 
	
	import flash.utils.getQualifiedClassName;
	
	import flexunit.framework.Assert;

	public class StubExpectation implements Expectation {
		public var stubbed:*;
		public var method:String;
		public var result:*;
		
		public var expectedArgs:*;
		public var blockToExecute:Function;
		
		public function get executedSuccessfully():Boolean { return true; }
		
		public function StubExpectation(stubbed:*, method:String) {
			this.stubbed = stubbed;
			this.method = method;
			
			// TODO: find a better place for this check, shouldn't be in this class
			if (!MockUtility.isDeclaredByObject(stubbed, method)) raiseMethodNotStubbedError(stubbed, method);
		}
		
		public function returns(result:*):Expectation {
			this.result = result;
			return this;
		}
		
		public function andReturn(result:*):Expectation {
			return returns(result);
		}
		
		public function executes(block:Function):Expectation {
			this.blockToExecute = block;
			return this;
		}
		
		public function withParams(...args):Expectation {
			this.expectedArgs = args;
			return this;
		}
		
		public function invoke(actualArgs:*):* {
			if (expectedArgs) {
				Assert.assertEquals("In " + method + " expected args != actual args (different lengths).",
									expectedArgs.length, actualArgs.length);
	
				// TODO: move this into a custom assert
				for (var i:uint = 0; i < expectedArgs.length; i++) {
					var message:String = "In " + method + " expected args != actual args (differ at " + i + ").";
					var expected:Object = expectedArgs[i];
					if (expected is Array) {
						TestCaseExt.assertArrayEquals(message, expected, actualArgs[i]);
					} else {
						Assert.assertEquals(message, expected, actualArgs[i]);
					}
				}
			}
			if (blockToExecute != null) {
				blockToExecute(actualArgs);
			}
			return this.result;
		}
		
		private function raiseMethodNotStubbedError(stubbed:*, method:String):void {
			throw new Error('method ' + method + ' not defined on ' + getQualifiedClassName(stubbed) + '. If it is not defined with a call to invokeStub, stubbing will not function properly.');
		}
	}
}