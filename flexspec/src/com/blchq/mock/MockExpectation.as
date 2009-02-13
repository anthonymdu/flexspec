package com.blchq.mock {
	public class MockExpectation extends MessageExpectation {
		public function MockExpectation(stubbed:*, method:String) {
			super(stubbed, method, true)
		}
	}
}