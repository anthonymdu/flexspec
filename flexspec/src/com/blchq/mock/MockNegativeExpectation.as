package com.blchq.mock {
	public class MockNegativeExpectation extends MessageExpectation {
		public function MockNegativeExpectation(stubbed:*, method:String) {
			super(stubbed, method, false);
			_expectedCount = 0;
		}
	}
}