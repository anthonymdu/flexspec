package com.blchq.mock {
	import com.blchq.unit.TestCaseExt;

	public class MockUtilityTest extends TestCaseExt {
		public function testShouldBeFalseWhenWhenMethodNotDeclaredByClass():void {
			assertFalse(MockUtility.isDeclaredByObject(new BaseClass(), 'blah'));
		}
		
		public function testShouldBeFalseWhenMethodNotDeclaredOnSubclass():void {
			assertFalse(MockUtility.isDeclaredByObject(new SubClassWithDifferentMethod(), 'baz'));
		}
		
		public function testShouldBeTrueWhenMethodDeclaredBySubClass():void {
			assertTrue(MockUtility.isDeclaredByObject(new SubClassWithOverriddenMethod(), 'foo'));
		}
		
		// If we decide we want the functionality that you can ask a class what methods it defines
		// need to implement this
//		public function testShouldRetrieveOnlyMethodsOnBaseClass():void {
//			assertArrayEquals(['foo', 'baz'], MockUtility.methodsDefinedOn(BaseClass), false);
//		}
		public function testShouldRetrieveOnlyMethodsOnInstanceOfBaseClass():void {
			assertArrayEquals(['foo', 'baz', 'baseProperty'], MockUtility.methodsOrAccessorsDeclaredBy(new BaseClass()), false);
		}
		
		public function testShouldRetrieveOnlyMethodsOnInstanceOfSubClass():void {
			assertArrayEquals(['bar'], MockUtility.methodsOrAccessorsDeclaredBy(new SubClassWithDifferentMethod()));
		}
		
		public function testShouldRetrieveOnlyMethodsOnInstanceOfSubClassWhenOverridden():void {
			assertArrayEquals(['foo'], MockUtility.methodsOrAccessorsDeclaredBy(new SubClassWithOverriddenMethod()));
		}
		
		public function testShouldRetrieveOnlyMethodsOnInstanceOfSubClassWithProperty():void {
			assertArrayEquals(['property'], MockUtility.methodsOrAccessorsDeclaredBy(new SubClassWithGetter()));
		}
	}
}

class BaseClass {
	public function foo():void { }
	public function baz():void { }
	
	public function get baseProperty():String { return ''; }
}

class SubClassWithDifferentMethod extends BaseClass {
	public function bar():void { }
}

class SubClassWithOverriddenMethod extends BaseClass {
	public override function foo():void { }
}

class SubClassWithGetter extends BaseClass {
	public function get property():String { return ''; }
}
