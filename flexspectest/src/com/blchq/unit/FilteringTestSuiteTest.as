package com.blchq.unit {
	import flexunit.framework.TestSuite;

	public class FilteringTestSuiteTest extends TestCaseExt {
		public override function defineTests():void {
			describe('addTestSuite', function():void {
				it('should add test matching pattern', function():void {
					var suiteClass:Class = FilteringTestSuiteTest;
					var filteringSuite:FilteringTestSuite = new FilteringTestSuite(null, {testPattern: 'Filtering'});

					filteringSuite.addTestSuite(suiteClass);
					assertArrayEquals([], filteringSuite.getTests());
				});

				it('should not add test not matching pattern', function():void {
					var filteringSuite:FilteringTestSuite = new FilteringTestSuite(null, {testPattern: 'SomethingElse'});
					assertArrayEquals([], filteringSuite.getTests());
				});
			});
		}
	}
}