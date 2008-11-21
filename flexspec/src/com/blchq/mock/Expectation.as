package com.blchq.mock {
	public interface Expectation {
		function returns(result:*):Expectation;
		function andReturn(result:*):Expectation;
		
		function invoke(args:*):*;
		function executes(block:Function):Expectation;
		
		function withParams(...args):Expectation;
		
		function get executedSuccessfully():Boolean;
		// TODO: 
		// function validate():Boolean
	}
}