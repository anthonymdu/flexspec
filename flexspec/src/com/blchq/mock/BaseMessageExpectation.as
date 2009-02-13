package com.blchq.mock {
	import flash.utils.getQualifiedClassName;

	public class BaseMessageExpectation implements Expectation {
		private var stubbed:*;
		private var method:String;
		private var result:*;

		private var expectedArgs:*;
		private var blockToExecute:Function;
		
		private var _return_block:Function;
		
		public var testPublicVar:String;

		public function get executedSuccessfully():Boolean { return true; }

		public function MessageExpectation(stubbed:*, method:String) {
			this.stubbed = stubbed;
			this.method = method;
			
			// TODO: find a better place for this check, shouldn't be in this class
			if (!MockUtility.isDeclaredByObject(stubbed, method)) raiseMethodNotStubbedError(stubbed, method);
		}

		public function andReturn(...values, return_block:Function=null):Expectation {
//        Kernel::raise AmbiguousReturnError unless @method_block.nil?
        var value:*;
        
        if (values.size == 0) {
        	value = null;
        } else if (values.size == 1) {
        	value = values[0]
  		} else {
          value = values
          _consecutive = true
          if (!ignoring_args? && _expected_received_count < values.size) _expected_received_count = values.size;
        }
        _return_block = return_block ? return_block : function():* { return value; }
//        # Ruby 1.9 - see where this is used below
        _ignore_args = !return_block
			return this;
		}

		public function executes(block:Function):Expectation {
			this.blockToExecute = block;
			return this;
		}

		public function withParams(...args):Expectation {
			this.expectedArgs = args;
			return this;
		}

		public function invoke(actualArgs:Array):* {
			if (_expected_received_count == 0) {
			  _failed_fast = true
			  _actual_received_count += 1
			  _error_generator.raise_expectation_error(method, _expected_received_count, _actual_received_count, actualArgs)
			}
			
			_order_group.handle_order_constraint(self)
	
			try {
				var defaultReturnVal:*;
				
				if (_exception_to_raise) throw _exception_to_raise;
			  	if (blockToExecute) {
			  		defaultReturnVal = blockToExecute(actualArgs);
			  	} else {
			  		default_return_val = null;
			  	}
			 	
//			  if !_method_block.nil?
//				default_return_val = invoke_method_block(args)
//			  elsif _args_to_yield.size > 0
//				default_return_val = invoke_with_yield(block)
//			  else
//				default_return_val = nil
//			  end
			  
			  if (_consecutive) {
				return invoke_consecutive_return_block(actualArgs)
			  } else if (_return_block) {
				return invoke_return_block(actualArgs);
			  } else {
				return default_return_val;
			  }
			} finally {
				_actual_received_count += 1
			}
//			
//			if (expectedArgs) {
//				Assert.assertEquals("In " + method + " expected args != actual args (different lengths).",
//									expectedArgs.length, actualArgs.length);
//	
//				// TODO: move this into a custom assert
//				for (var i:uint = 0; i < expectedArgs.length; i++) {
//					var message:String = "In " + method + " expected args != actual args (differ at " + i + ").";
//					var expected:Object = expectedArgs[i];
//					if (expected is Array) {
//						TestCaseExt.assertArrayEquals(message, expected, actualArgs[i]);
//					} else {
//						Assert.assertEquals(message, expected, actualArgs[i]);
//					}
//				}
//			}
//			if (blockToExecute != null) {
//				blockToExecute(actualArgs);
//			}
//			return this.result;
		}
      
	      private function invoke_consecutive_return_block(actualArgs:Array):*
	        value = _return_block(actualArgs)
	        
	        var index:int = [_actual_received_count, value.size-1].min
	        value[index]
	      end

		private function invoke_return_block(actualArgs:Array):* {
	        if (_ignore_args)
	          _return_block()
	        else
	          _return_block(actualArgs)
		}

		private function raiseError(method:String, expected_received_count:int, actual_received_count:int, actualArgs:Array) {
			
		}


		private function raiseMethodNotStubbedError(stubbed:*, method:String):void {
			throw new Error('method ' + method + ' not defined on ' + getQualifiedClassName(stubbed) + '. If it is not defined with a call to invokeStub, stubbing will not function properly.');
		}
	}
}