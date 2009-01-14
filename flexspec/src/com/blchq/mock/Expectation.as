package com.blchq.mock {
	public interface Expectation {
		function returns(result:*):Expectation;
		function andReturn(...values):Expectation;
		
		function invoke(args:Array):*;
		function executes(block:Function):Expectation;
		
		function withParams(...args):Expectation;
		
		function get executedSuccessfully():Boolean;
		function get failedFast():Boolean;

		function get failureMessage():String; 
		// TODO: 
		// function validate():Boolean
	}
}