package com.blchq.unit {
	import flash.utils.getQualifiedClassName;
	
	import flexunit.framework.TestSuite;
	
	import mx.core.Application;

	public class FilteringTestSuite extends TestSuite {
		private var _testPattern:String;

		public function FilteringTestSuite(param:Object=null, filteringParams:Object=null) {
			super(param);

			filteringParams ||= Application.application.parameters;
			if (filteringParams['testPattern']) {
				_testPattern = filteringParams['testPattern'].toLowerCase();
			}
		}

		public override function addTestSuite(testClass:Class):void {
			if (!_testPattern || getQualifiedClassName(testClass).toLowerCase().match(_testPattern)) {
				super.addTestSuite(testClass);
			}
		}
	}
}