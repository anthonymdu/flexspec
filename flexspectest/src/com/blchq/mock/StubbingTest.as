package com.blchq.mock {
	import com.blchq.test.SpecTestCase;
	
	import flexunit.framework.AssertionFailedError;

	public class StubbingTest extends SpecTestCase {
		public override function defineTests():void {
			describe('invoke', function():void {
				it('should expand out arguments when just passed as "arguments"', function():void {
					var stub:BaseStub = new BaseStub();
					assertEquals(1, stub.methodPassingWithArguments(1));
				});

				it('should expand arguments when none given and just passed as "arguments"', function():void {
					var stub:BaseStub = new BaseStub();
					assertEquals("methodPassingWithArgumentsNotTakingAny", stub.methodPassingWithArgumentsNotTakingAny());
				});

				it('should succeed when correct when just passed as "arguments"', function():void {
					var stub:BaseStub = new BaseStub();
					var expectation:Expectation = stub.shouldReceive('methodPassingWithArguments').withParams(1);
					
					stub.methodPassingWithArguments(1);
					assertTrue(expectation.executedSuccessfully);
				});
			});
		}

		public function testShouldGetStubbedPropertyValue():void {
			var stub:BaseStub = new BaseStub();
			var propertyVal:Number = 123
			stub.stubs('propertyToOverride').returns(propertyVal);
			
			assertEquals(propertyVal, stub.propertyToOverride);
		}
		
		public function testShouldGetDifferentValuesForDifferentInstances():void {
			var stub1:BaseStub = new BaseStub();
			stub1.stubs('propertyToOverride').returns(1);
			var stub2:BaseStub = new BaseStub();
			stub2.stubs('propertyToOverride').returns(2);
			
			assertEquals(1, stub1.propertyToOverride);
			assertEquals(2, stub2.propertyToOverride);
		}
		
		public function testShouldDefaultStubbingToNullWhenNoReturn():void {
			var stub:BaseStub = new BaseStub();
			stub.stubs('propertyX');
			assertNull(stub.propertyX);
		}
		
		public function testShouldPassFromValidArgument():void {
			var stub:BaseStub = new BaseStub();
			var param:String = 'abcd';
			stub.shouldReceive('methodWithParams').withParams(param);
			
			stub.methodWithParams(param);
		}
		
		public function testShouldPassFromValidArguments():void {
			var stub:BaseStub = new BaseStub();
			var param1:String = 'abcd';
			var param2:Number = 123;
			var param3:Object = new Object();
			
			stub.shouldReceive('methodWithThreeParams').withParams(param1, param2, param3);
			stub.methodWithThreeParams(param1, param2, param3);
		}
		
		public function testShouldPassFromNoParamExpectations():void {
			var stub:BaseStub = new BaseStub();
			
			stub.shouldReceive('methodWithParams');
			stub.methodWithParams('XYZ');
		}
		
		public function testShouldReturnCorrectValueOnExpectation():void {
			var stub:BaseStub = new BaseStub();
			var param:String = 'abcd';
			var returnValue:Object = new Object();
			stub.shouldReceive('methodWithParams').withParams(param).returns(returnValue);
			
			assertEquals(returnValue, stub.methodWithParams(param));
		}
		
		public function testShouldFailFromInvalidArguments():void {
			var stub:BaseStub = new BaseStub();
			var failed:Boolean = false;
			
			stub.shouldReceive('methodWithParams').withParams('abcd');
			
			try {
				stub.methodWithParams('abc');
			} catch (e:AssertionFailedError) {
				failed = true;
			}
			if (!failed) fail("Should have failed when method called with wrong parameters");
		}
		
		public function testShouldFailFromInvalidIntermediateArgument():void {
			var stub:BaseStub = new BaseStub();
			var failed:Boolean = false;
			
			stub.shouldReceive('methodWithThreeParams').withParams('abcd', 123, 'efg');
			
			try {
				stub.methodWithThreeParams('abc', 987, 'efg');
			} catch (e:AssertionFailedError) {
				failed = true;
			}
			if (!failed) fail("Should have failed when method called with wrong parameters");
		}
		
/* 		public function testShouldPassFromValidVarArgParams():void {
			var stub:BaseStub = new BaseStub();
			var param1:String = 'abcd';
			var param2:Number = 123;
			stub.shouldReceive('methodWithVariableNumberOfParams').withParams([param1, param2]);
			
			stub.methodWithVariableNumberOfParams(param1, param2);
		} */
		
		public function testShouldFailFromTooManyArguments():void {
			var stub:BaseStub = new BaseStub();
			stub.shouldReceive('methodWithVariableNumberOfParams').withParams('abc');
			var failed:Boolean = false;
			try {
				stub.methodWithVariableNumberOfParams('abc', '123');
			} catch (e:AssertionFailedError) {
				failed = true;
			}
			if (!failed) fail("Should have failed when method called with wrong parameters");
		}
		
		public function testShouldRetrieveDefaultValueFromBaseForProperty():void {
			var stub:BaseStub = new BaseStub();
			assertEquals(Base.DEFAULT_VALUE, stub.propertyOverriddenButNotStubbedInTest);
		}
		
		public function testShouldRetrieveDefaultValueFromBaseForMethod():void {
			var stub:BaseStub = new BaseStub();
			assertEquals(Base.DEFAULT_VALUE, stub.methodOverriddenButNotStubbedInTest());
		}
		
		public function testShouldAssertArrayEquals():void {
			var stub:BaseStub = new BaseStub();
			var param:Array = ['abcd'];
			var returnValue:Object = new Object();
			stub.shouldReceive('methodWithArrayParams').withParams(param).returns(returnValue);
			
			assertEquals(returnValue, stub.methodWithArrayParams(param));
		}

		public function testShouldFailAssertArrayEquals():void {
			var stub:BaseStub = new BaseStub();
			var failed:Boolean = false;
			
			stub.shouldReceive('methodWithArrayParams').withParams(['abcd']);
			
			try {
				stub.methodWithArrayParams(['abc']);
			} catch (e:AssertionFailedError) {
				failed = true;
			}
			if (!failed) fail("Should have failed when method called with wrong array parameters");
		}
		
		public function testShouldPassFromDifferentArraysWithSameContents():void {
			var stub:BaseStub = new BaseStub();
			
			stub.shouldReceive('methodWithArrayParams').withParams(['abc', 123]);
			
			stub.methodWithArrayParams(['abc', 123]);
		}

		public function testShouldHaveBeenExecutedProperlyWhenStubCreated():void {
			var baseStub:BaseStub = new BaseStub();
			var expectation:Expectation = baseStub.stubs('propertyX');
			
			assertTrue(expectation.executedSuccessfully);
		}

		public function testShouldNotHaveBeenExecutedSuccessfullyWhenExpectationNotExecuted():void {
			var baseStub:BaseStub = new BaseStub();
			var expectation:Expectation = baseStub.shouldReceive('propertyX');
			
			assertFalse(expectation.executedSuccessfully);
		}

		public function testShouldHaveBeenExecutedSuccessfullyWhenExpectationExecuted():void {
			var baseStub:BaseStub = new BaseStub();
			var expectation:Expectation = baseStub.shouldReceive('propertyX');
			
			baseStub.propertyX;
			assertTrue(expectation.executedSuccessfully);
		}
		
		/*public function testShouldinvokeStubForNonOverridenMethod():void {
			var stub:BaseStub = new BaseStub();
			var propertyVal:Number = 123
			//stub.stubs('nonGetter').returns(propertyVal);
			trace("stub.getPrototype() is " + stub.getPrototype());
			trace("stub.getPrototype()['nonGetter'] is " + stub.getPrototype()['nonGetter']);
			trace("stub.getPrototype().nonGetter is " + stub.getPrototype().nonGetter);
			//stub.getPrototype().nonGetter = function() { return 123; }
			//stub.prototype['nonGetter'] = function() { return 123; }
			
			assertEquals(propertyVal, stub.nonGetter());
		}*/
	}
}

class Base {
	public static const DEFAULT_VALUE:Number = 1;
	
	public function nonGetter():Number { return DEFAULT_VALUE; }
	public function methodOverriddenButNotStubbedInTest():Number { return DEFAULT_VALUE; }
	
	public function get propertyToOverride():Number { return DEFAULT_VALUE; }
	public function get propertyToStubDirectly():Number { return DEFAULT_VALUE; }
	public function get propertyOverriddenButNotStubbedInTest():Number { return DEFAULT_VALUE; }

	public function methodPassingWithArguments(a:int):int { return a; }
	public function methodPassingWithArgumentsNotTakingAny():String { return 'methodPassingWithArgumentsNotTakingAny'; }
}

dynamic class BaseStub extends Base {
	include "../../../../spec/includes/Stubbable.as";
	
	public override function get propertyToOverride():Number { return invokeStub('propertyToOverride'); }
	public function get propertyX():Object { return invokeStub('propertyX'); }
	
	public override function get propertyOverriddenButNotStubbedInTest():Number { return invokeStub('propertyOverriddenButNotStubbedInTest'); }
	
	public function methodWithParams(param:String):Object { return invokeStub('methodWithParams', param); }
	public function methodWithArrayParams(param:Array):Object { return invokeStub('methodWithArrayParams', param); }
	public function methodWithThreeParams(param1:Object, param2:Object, param3:Object):Object { return invokeStub('methodWithThreeParams', param1, param2, param3); }
	
	public function methodWithVariableNumberOfParams(...args):Object { return invokeStub('methodWithVariableNumberOfParams', args); }
	
	public override function methodOverriddenButNotStubbedInTest():Number { return invokeStub('methodOverriddenButNotStubbedInTest'); }

	public override function methodPassingWithArguments(a:int):int { return invokeStub('methodPassingWithArguments', arguments); }
	public override function methodPassingWithArgumentsNotTakingAny():String { return invokeStub('methodPassingWithArgumentsNotTakingAny', arguments); }
	
	// TODO: try this using arguments.caller.something
}