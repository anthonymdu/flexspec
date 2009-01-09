package com.blchq.mock {
	public class StubExpectation extends MessageExpectation {
		public function StubExpectation(stubbed:*, method:String) {
			super(stubbed, method, false)
		}
	}
}