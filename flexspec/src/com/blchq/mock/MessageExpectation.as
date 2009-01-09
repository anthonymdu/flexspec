package com.blchq.mock {
	import com.blchq.unit.TestCaseExt;
	
	import flash.utils.getQualifiedClassName;
	
	import flexunit.framework.Assert;
	import flexunit.framework.AssertionFailedError;

	public class MessageExpectation implements Expectation {
		protected var _expectedCount:int = -1;

		protected var _executedSuccessfully:Boolean;

		private var _stubbed:*;
		private var _method:String;
		private var _result:*;

		private var _expectedArgs:*;
		private var _blockToExecute:Function;

		private var _actualCount:int = 0;

		private var _values:Array = [];

		public function get executedSuccessfully():Boolean { return _executedSuccessfully; }

		public function MessageExpectation(stubbed:*, method:String, requiresInvocation:Boolean, verifyDeclaration:Boolean=true) {
			_stubbed = stubbed;
			_method = method;
			
			_executedSuccessfully = !requiresInvocation;
			// TODO: find a better place for this check, shouldn't be in this class
			if (verifyDeclaration && !MockUtility.isDeclaredByObject(stubbed, method)) raiseMethodNotStubbedError(stubbed, method);
		}

		public function returns(result:*):Expectation {
			return andReturn(result);
		}

		public function andReturn(...values):Expectation {
			_values = values;
			return this;
		}

		public function executes(block:Function):Expectation {
			_blockToExecute = block;
			return this;
		}

		public function withParams(...args):Expectation {
			_expectedArgs = args;
			return this;
		}

		public function invoke(actualArgs:Array):* {
			_actualCount++;
			if (_expectedCount != -1 && _expectedCount > _actualCount) {
				throw new AssertionFailedError("Expected " + _method + " to be called " + _expectedCount + " times, but was called " + _actualCount + " times");
			}
			
			if (_expectedArgs) {
				Assert.assertEquals("In " + _method + " expected args != actual args (different lengths).",
									_expectedArgs.length, actualArgs.length);
	
				// TODO: move this into a custom assert
				for (var i:uint = 0; i < _expectedArgs.length; i++) {
					var message:String = "In " + _method + " expected args != actual args (differ at " + i + ").";
					var expected:Object = _expectedArgs[i];
					if (expected is Array) {
						TestCaseExt.assertArrayEquals(message, expected, actualArgs[i]);
					} else {
						Assert.assertEquals(message, expected, actualArgs[i]);
					}
				}
			}
			if (_blockToExecute != null) {
				_blockToExecute(actualArgs);
			}
			
			_executedSuccessfully = true;
			return _values[_actualCount - 1];
		}

		private function raiseMethodNotStubbedError(stubbed:*, method:String):void {
			throw new Error('method ' + method + ' not defined on ' + getQualifiedClassName(stubbed) + '. If it is not defined with a call to invokeStub, stubbing will not function properly.');
		}
	}
}