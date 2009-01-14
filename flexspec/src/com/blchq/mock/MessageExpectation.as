package com.blchq.mock {
	import flexunit.framework.AssertionFailedError;
	
	import mx.utils.ObjectUtil;

	public class MessageExpectation implements Expectation {
		protected var _expectedCount:int = -1;

		protected var _executedSuccessfully:Boolean;

		private var _stubbed:*;
		private var _method:String;
		private var _result:*;

		private var _expectedArgs:*;
		private var _blockToExecute:Function;

		private var _actualCount:int = 0;

		private var _values:Array = [];
		private var _failedFast:Boolean = false;

		private var _errorGenerator:ErrorGenerator;

		public function get executedSuccessfully():Boolean { return _executedSuccessfully; }
		public function get failedFast():Boolean { return _failedFast; }

		public function get failureMessage():String { return ObjectUtil.toString(this); }

		public function MessageExpectation(stubbed:*, method:String, requiresInvocation:Boolean) {
			_stubbed = stubbed;
			_method = method;
			
			_executedSuccessfully = !requiresInvocation;
			
			_errorGenerator = new ErrorGenerator(stubbed, null);
		}

		public function returns(result:*):Expectation {
			return andReturn(result);
		}

		public function andReturn(...values):Expectation {
			_values = _values.concat(values);
			return this;
		}

		public function executes(block:Function):Expectation {
			_blockToExecute = block;
			return this;
		}

		public function withParams(...args):Expectation {
			_expectedArgs = args;
			return this;
		}

		public function invoke(actualArgs:Array):* {
			try {
				_actualCount++;
				if (_expectedCount != -1 && _expectedCount > _actualCount) {
					_errorGenerator.raise_expectation_error(_method, _expectedCount, _actualCount, actualArgs);
				}
				
				if (_expectedArgs && ObjectUtil.compare(_expectedArgs, actualArgs) != 0) {
					_errorGenerator.raise_unexpected_message_args_error(_method, _expectedArgs, actualArgs);
				}
				if (_blockToExecute != null) {
					_blockToExecute(actualArgs);
				}
				
				_executedSuccessfully = true;
				
				if (_values.length == 1) {
					return _values[0];
				} else {
					return _values[_actualCount - 1];
				}
			} catch (error:AssertionFailedError) {
				_failedFast = true;
				throw error;
			}
		}

		public function verifyMessagesReceived():void {
			if (!failedFast && !executedSuccessfully) {
				_errorGenerator.raise_expectation_error(_method, _expectedCount, _actualCount, []);
			}
		}
	}
}

import mx.utils.ObjectUtil;
import flexunit.framework.AssertionFailedError;	

/* Grabbed directly from RSpec 1.1.11 */
class ErrorGenerator {
	private var _target:*;
	private var _name:String;

	private var _opts:Object;

	public function ErrorGenerator(target:*, name:String) {
		_target = target
		_name = name
	}

	public function get opts():Object {
		if (!_opts) _opts = {}
		return _opts;
	}

	public function raise_unexpected_message_error(sym:String, args:Array):void {
		__raise(i(intro, " received unexpected message :", sym, arg_message(args)))
	}

	public function raise_unexpected_message_args_error(method:String, expectedArgs:Array, actualArgs:Array):void {
		var expected_args:String = format_args(expectedArgs)
		var actual_args:String = actualArgs.length == 0 ? "(no args)" : format_args(actualArgs)
		__raise(i(intro, " expected ", method, " with ", expected_args, " but received it with ", actual_args))
	}

	public function raise_expectation_error(sym:String, expected_received_count:int, actual_received_count:int, args:Array):void {
		__raise(i(intro, " expected :", sym, arg_message(args), count_message(expected_received_count), ", but received it ", count_message(actual_received_count)))
	}

	public function raise_out_of_order_error(sym:String):void {
		__raise(i(intro, " received :", sym, " out of order"))
	}

	private function get intro():String {
		if (_name) {
			return i("Mock ", _name)
		} else if (_target is Class) {
			return i("<", ObjectUtil.toString(_target), "> (class)>");
		} else if (_target == null) {
			return "null";	
		} else {
			return _target.toString();
		}
	}

	private function __raise(message:String):void {
		if (opts['message']) message = opts['message']
		throw new AssertionFailedError(message);
	}

	private function arg_message(args:Array):String {
		return i(" with ", format_args(args))
	}

	private function format_args(args:Array):String {
		if (args.length == 0 || args[0] == 'no_args') return "(no args)"
		if (args[0] == 'any_args') return "(any args)"
		return "(" + arg_list(args) + ")"
	}

	private function arg_list(args:Array):String {
		return args.map(function(arg:*, ...a):String {
			return arg.hasOwnProperty('description') ? arg.description : ObjectUtil.toString(arg)
		}).join(", ");
	}

	private function count_message(count:int):String {
		if (count < 0) return i("at least ", pretty_print(Math.abs(count)))
		return pretty_print(count)
	}

	private function pretty_print(count:int):String {
		if (count == 1) return "once"
		if (count == 2) return "twice"
		return i(count, " times")
	}

	/* interpolate */
	private function i(...args):String {
		return args.join("");
	}
}
