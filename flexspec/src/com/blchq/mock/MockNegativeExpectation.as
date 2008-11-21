package com.blchq.mock {
	public class MockNegativeExpectation extends MockExpectation {
		public function MockNegativeExpectation(stubbed:*, method:String) {
			super(stubbed, method);
			_executedSuccessfully = true;
		}
		
		public override function invoke(actualArgs:*):* {
			var result:* = super.invoke(actualArgs);
			_executedSuccessfully = false;
			
			return result;
		}
	}
}