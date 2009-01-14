package com.blchq.mock {
	
	import com.blchq.test.SpecTestCase;
	
	import flexunit.framework.AssertionFailedError;

	public class MessageExpectationTest extends SpecTestCase {
		public override function defineTests():void {
			describe('verifyMessagesReceived', function():void {
				it('should fail when never called and should have been', function():void {
					var failed:Boolean = false;
					
					try {
						var expectation:MessageExpectation = new MessageExpectation({}, 'method', true);
						expectation.verifyMessagesReceived();
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it('should pass when not called and did not need to be', function():void {
					var expectation:MessageExpectation = new MessageExpectation({}, 'method', false);
					expectation.verifyMessagesReceived();
				});

				it('should not raise again when it already failed fast', function():void {
					var expectation:MessageExpectation = new MessageExpectation({}, 'method', true);
					expectation.withParams([1]);
					try {
						expectation.invoke([]);
					} catch(e:Error) { }

					expectation.verifyMessagesReceived();
				});
			});

			describe('invoke', function():void {
				it('should set failFast to true when it failed', function():void {
					var expectation:MessageExpectation = new MessageExpectation({}, 'method', true);
					expectation.withParams([1]);
					try {
						expectation.invoke([]);
					} catch(e:Error) { }

					assertTrue(expectation.failedFast);
				});

				it('should have failFast as false when it succeeded', function():void {
					var expectation:MessageExpectation = new MessageExpectation({}, 'method', true);
					expectation.invoke([]);

					assertFalse(expectation.failedFast);
				});
			});

			describe('addReturn', function():void {
				it('should return given values on multiple invocations', function():void {
					var expectation:MessageExpectation = new MessageExpectation({}, 'method', true);
					expectation.andReturn(1, 2);
					
					assertEquals(1, expectation.invoke([]));
					assertEquals(2, expectation.invoke([]));
				});

				it('should return given array', function():void {
					var expectation:MessageExpectation = new MessageExpectation({}, 'method', true);
					var array:Array = [1, 2];
					expectation.andReturn(array);
					
					assertEquals(array, expectation.invoke([]));
				});

				it('should return given item repeatedly if only one andReturn', function():void {
					var expectation:MessageExpectation = new MessageExpectation({}, 'method', true);
					expectation.andReturn(1);
					
					assertEquals(1, expectation.invoke([]));
					assertEquals(1, expectation.invoke([]));
				});

				it('should return given values when andReturn called multiple times', function():void {
					var expectation:MessageExpectation = new MessageExpectation({}, 'method', true);
					expectation.andReturn(1);
					expectation.andReturn(2);
					
					assertEquals(1, expectation.invoke([]));
					assertEquals(2, expectation.invoke([]));
				});

				// TODO: should it do this or blow up
				it('should return null on invocations after the set amount', function():void {
					var expectation:MessageExpectation = new MessageExpectation({}, 'method', true);
					expectation.andReturn(1, 2);
					
					expectation.invoke([]);
					expectation.invoke([]);
					assertNull(expectation.invoke([]));
				});
			});
		}
	}
}