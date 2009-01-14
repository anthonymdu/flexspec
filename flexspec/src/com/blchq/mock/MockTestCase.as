package com.blchq.mock {
	import com.blchq.test.SpecTestCase;
	
	import flexunit.framework.AssertionFailedError;
	
	import mx.utils.ObjectUtil;
	
	public class MockTestCase extends SpecTestCase {
		private var _expectations:Array = [];

		public function MockTestCase(methodName:String=null) {
			super(methodName);
		}

		public function verify(expectation:Expectation):void {
			_expectations.push(expectation);
		}

		public override function tearDown():void {
			super.tearDown();
			runVerifications("Running verifications during TearDown");
		}

		public function runVerifications(message:String=''):void {
			var failedExpectation:Expectation = null;
			for each (var expectation:Expectation in _expectations) {
				if (!expectation.executedSuccessfully && !expectation.failedFast) {
					failedExpectation = expectation;
					break;
				}
			}
			
			_expectations = [];
			if (failedExpectation != null) {
				failWithUserMessage(message, "Expectation failed\n" + ObjectUtil.toString(failedExpectation));
			}
		}

		public function stub(stubClass:Class, stubs:Object=null):* {
			if (!stubs) stubs = {};
			
			var stub:* = new stubClass();
			for (var stubMethod:String in stubs) {
				stub.stub(stubMethod).andReturn(stubs[stubMethod]);
			}
			return stub;
		}

		private static function failWithUserMessage( userMessage:String, failMessage:String ):void {
			if (userMessage.length > 0)
				userMessage = userMessage + " - ";
	
			throw new AssertionFailedError(userMessage + failMessage);
		}
	}
}