package com.blchq.mock {
	
	import com.blchq.test.SpecTestCase;

	public class MessageExpectationTest extends SpecTestCase {
		public override function defineTests():void {
			describe('addReturn', function():void {
				it('should return given values on multiple invocations', function():void {
					var expectation:MessageExpectation = new MessageExpectation({}, 'method', true, false);
					expectation.andReturn(1, 2);
					
					assertEquals(1, expectation.invoke([]));
					assertEquals(2, expectation.invoke([]));
				});

				it('should return given array', function():void {
					var expectation:MessageExpectation = new MessageExpectation({}, 'method', true, false);
					var array:Array = [1, 2];
					expectation.andReturn(array);
					
					assertEquals(array, expectation.invoke([]));
				});

				it('should return given item repeatedly if only one andReturn', function():void {
					var expectation:MessageExpectation = new MessageExpectation({}, 'method', true, false);
					expectation.andReturn(1);
					
					assertEquals(1, expectation.invoke([]));
					assertEquals(1, expectation.invoke([]));
				});

				it('should return given values when andReturn called multiple times', function():void {
					var expectation:MessageExpectation = new MessageExpectation({}, 'method', true, false);
					expectation.andReturn(1);
					expectation.andReturn(2);
					
					assertEquals(1, expectation.invoke([]));
					assertEquals(2, expectation.invoke([]));
				});

				// TODO: should it do this or blow up
				it('should return null on invocations after the set amount', function():void {
					var expectation:MessageExpectation = new MessageExpectation({}, 'method', true, false);
					expectation.andReturn(1, 2);
					
					expectation.invoke([]);
					expectation.invoke([]);
					assertNull(expectation.invoke([]));
				});
			});
		}
	}
}