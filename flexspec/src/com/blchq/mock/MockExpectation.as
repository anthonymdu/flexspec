package com.blchq.mock {
	public class MockExpectation extends StubExpectation {
		protected var _executedSuccessfully:Boolean;
		
		public function MockExpectation(stubbed:*, method:String) {
			super(stubbed, method);
			_executedSuccessfully = false;
		}
		
		public override function get executedSuccessfully():Boolean { return _executedSuccessfully; }
		
		public override function invoke(actualArgs:*):* {
			var result:* = super.invoke(actualArgs);
			_executedSuccessfully = true;
			
			return result;
		}
	}
}