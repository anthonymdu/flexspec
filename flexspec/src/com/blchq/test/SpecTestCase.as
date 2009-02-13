package com.blchq.test {
	import com.blchq.unit.TestCaseWithMoreAssertions;
	
	public class SpecTestCase extends TestCaseWithMoreAssertions {
		private var dynamicTests:Object = {};
		private var describeStack:Array = [];
		private var _setupContexts:Array = [];
		private var _tearDownContexts:Array = [];
		
		public function SpecTestCase(methodName:String=null) {
			super(methodName);
			defineTests();
		}
		
		public function defineTests():void { }
		
		public override function getTestMethodNames():Array {
			var methodNames:Array = super.getTestMethodNames();
			
			for (var name:String in dynamicTests) {
				methodNames.push(name);
			}
			
			return methodNames.sort();
		}
		
		public override function runStart():void {
			super.runStart();
			if (methodName && dynamicTests[methodName]) {
	    		dynamicTests[methodName].setUp();
	    	}
		}
		
	    public override function runMiddle():void {
	    	if (methodName && dynamicTests[methodName]) {
	    		dynamicTests[methodName].run();
	    	} else {
	    		super.runMiddle();
	    	}
	    }
		
		public override function runFinish():void {
			if (methodName && dynamicTests[methodName]) {
	    		dynamicTests[methodName].tearDown();
	    	}
			super.runFinish();
		}

		protected function describe(description:String, block:Function):void {
			describeStack.push(description);
			
			var setupContext:Array = _setupContexts;
			var tearDownContext:Array = _tearDownContexts;
			
			block();
			
			_tearDownContexts = tearDownContext;
			_setupContexts = setupContext;
			
			describeStack.pop();
		}
		
		protected function before(block:Function):void {
			_setupContexts = _setupContexts.concat(block);
		}
		
		protected function after(block:Function):void {
			_tearDownContexts = _tearDownContexts.concat(block);
		}
		
		protected function it(description:String, ...rest):void {
			if (rest.length > 1) throw new ArgumentError("Must specify a description and (optionally) a testing function");
			
			if (rest.length == 1) {
				var test:Function = rest[0];
				var name:String = testNameFor(description);
				dynamicTests[name] = new ItStyleTestMethod(name, test, _setupContexts, _tearDownContexts);
			}
		}
		
		private function testNameFor(description:String):String {
			var name:String = describeText;
			if (name != '') {
				name += ' ';
			}
			
			return name + description;
		}

		private function get describeText():String {
			var text:String = '';
			for each (var description:String in describeStack) {
				// prepend a space if this isn't the first part of the description
				if (text != '') text += ' ';
				
				text += description;
			}
			
			return text;
		}
	}
}

class ItStyleTestMethod {
	private var _name:String;
	private var _test:Function;
	private var _setupContexts:Array;
	private var _tearDownContexts:Array;
	
	public function ItStyleTestMethod(name:String, test:Function, setupContexts:Array, tearDownContexts:Array) {
		_name = name;
		_test = test;
		_setupContexts = setupContexts;
		_tearDownContexts = tearDownContexts;
	}
	
	public function get name():String {
		return _name;
	}
	
	public function setUp():void {
		runChain(_setupContexts);
	}
	
	public function tearDown():void {
		runChain(_tearDownContexts.reverse());
	}
	
	public function run():void {
		_test();
	}
	
	private function runChain(chain:Array):void {
		for each (var method:Function in chain) {
			method();
		}
	}
}