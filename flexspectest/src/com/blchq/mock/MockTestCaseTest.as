package com.blchq.mock {
	
	import flexunit.framework.AssertionFailedError;
	import flexunit.framework.TestCase;

	public class MockTestCaseTest extends TestCase {
		public function testShouldFailWhenAnExpectationFailed():void {
			var failed:Boolean = false;
			
			var testCase:MockTestCase = new MockTestCase();
			testCase.verify(new TestingExpectation(true));
			testCase.verify(new TestingExpectation(false));
			try {
				testCase.runVerifications();
			} catch (e:AssertionFailedError) {
				failed = true;
			}
			if (!failed) fail('Assertion should have failed');
		}
		
		public function testShouldPassWhenExpectationPassed():void {
			var failed:Boolean = false;
			
			var testCase:MockTestCase = new MockTestCase();
			testCase.verify(new TestingExpectation(true));
			testCase.runVerifications();
		}
		
		public function testShouldPassWhenNoExpectations():void {
			var failed:Boolean = false;
			
			var testCase:MockTestCase = new MockTestCase();
			testCase.runVerifications();
		}
		
		public function testShouldNotCareAboutExpectationsFromEarlierVerifications():void {
			var testCase:MockTestCase = new MockTestCase();
			testCase.verify(new TestingExpectation(false));
			try {
				testCase.runVerifications();
			} catch (e:AssertionFailedError) { }
			
			testCase.verify(new TestingExpectation(true));
			testCase.runVerifications();
		}
		
		public function testShouldRunVerificationsInTearDown():void {
			var failed:Boolean = false;
			
			var testCase:MockTestCase = new MockTestCase();
			testCase.verify(new TestingExpectation(false));
			try {
				testCase.tearDown();
			} catch (e:AssertionFailedError) {
				failed = true;
			}
			if (!failed) fail('Assertion should have failed');
		}
	}
}

import com.blchq.mock.Expectation;

class TestingExpectation implements Expectation {
	public var stubbedExecutedSuccessfully:Boolean = false;
	
	public function TestingExpectation(stubbedExecutedSuccessfully:Boolean) {
		this.stubbedExecutedSuccessfully = stubbedExecutedSuccessfully;
	}
	
	public function returns(result:*):Expectation {
		return this;
	}
	
	public function andReturn(result:*):Expectation {
		return this;
	}
	
	public function invoke(args:*):* {
		return this;
	}
	
	public function executes(block:Function):Expectation {
		return this;
	}
	
	public function withParams(...args):Expectation {
		return this;
	}
	
	public function get executedSuccessfully():Boolean {
		return stubbedExecutedSuccessfully;
	}
}
