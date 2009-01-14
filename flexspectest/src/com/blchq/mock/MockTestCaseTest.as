package com.blchq.mock {
	
	import com.blchq.test.SpecTestCase;
	
	import flexunit.framework.AssertionFailedError;

	public class MockTestCaseTest extends SpecTestCase {
		public override function defineTests():void {
			describe('runVerifications', function():void {
				it("should ignore expectation that failed fast so tearDown doesn't fail twice", function():void {
					var testCase:MockTestCase = new MockTestCase();
					testCase.verify(new TestingExpectation(false, true));
					testCase.runVerifications();
				});

				it('should fail when an expectation failed', function():void {
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
				});
				
				it('should pass when expectation pass', function():void {
					var failed:Boolean = false;
					
					var testCase:MockTestCase = new MockTestCase();
					testCase.verify(new TestingExpectation(true));
					testCase.runVerifications();
				});

				it('should pass when no expectations', function():void {
					var failed:Boolean = false;
					
					var testCase:MockTestCase = new MockTestCase();
					testCase.runVerifications();
				});
				
				it('should not care about expecatations from earlier verifications', function():void {
					var testCase:MockTestCase = new MockTestCase();
					testCase.verify(new TestingExpectation(false));
					try {
						testCase.runVerifications();
					} catch (e:AssertionFailedError) { }
					
					testCase.verify(new TestingExpectation(true));
					testCase.runVerifications();
				});
			});

			it('should RunVerificationsInTearDown', function():void {
				var failed:Boolean = false;
				
				var testCase:MockTestCase = new MockTestCase();
				testCase.verify(new TestingExpectation(false));
				try {
					testCase.tearDown();
				} catch (e:AssertionFailedError) {
					failed = true;
				}
				if (!failed) fail('Assertion should have failed');
			});

			describe('stub', function():void {
				// TODO: hopefully at some point auto-discover the stub class based on the real class
				it('should return a stub of the specified class', function():void {
					assertTrue(new MockTestCase().stub(RealStub) is RealStub);
				});

				it('should have the specified methods stubbed', function():void {
					var stub:RealStub = new MockTestCase().stub(RealStub, {method1: 'stubValue'});
					assertEquals('stubValue', stub.method1());
				});
			});

		}
	}
}

import com.blchq.mock.Expectation;

class TestingExpectation implements Expectation {
	public var stubbedExecutedSuccessfully:Boolean;
	public var stubbedFailedFast:Boolean;
	
	public function TestingExpectation(stubbedExecutedSuccessfully:Boolean, stubbedFailedFast:Boolean=false) {
		this.stubbedExecutedSuccessfully = stubbedExecutedSuccessfully;
		this.stubbedFailedFast = stubbedFailedFast;
	}
	
	public function returns(result:*):Expectation {
		return this;
	}
	
	public function andReturn(...values):Expectation {
		return this;
	}
	
	public function invoke(args:Array):* {
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
	
	public function get failedFast():Boolean {
		return stubbedFailedFast;
	}

	public function get failureMessage():String {
		return "";
	}
}


class Real {
	public function method1():String {
		return "real value";
	}
}

class RealStub extends Real {
	include "../../../../spec/includes/Stubbable.as"

	public override function method1():String { return invokeStub('method1'); }
}