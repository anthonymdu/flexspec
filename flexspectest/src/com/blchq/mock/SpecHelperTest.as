package com.blchq.mock {
	import com.blchq.test.SpecTestCase;

	public class SpecHelperTest extends SpecTestCase {
		public override function defineTests():void {
			describe('stub', function():void {
				// TODO: hopefully at some point auto-discover the stub class based on the real class
				it('should return a stub of the specified class', function():void {
					assertTrue(stub(RealStub) is RealStub);
				});

				it('should have the specified methods stubbed', function():void {
					var stub:RealStub = stub(RealStub, {method1: 'stubValue'});
					assertEquals('stubValue', stub.method1());
				});
			});
		}
	}
}
class Real {
	public function method1():String {
		return "real value";
	}
}

class RealStub extends Real {
	include "../../../../spec/includes/Stubbable.as"

	public override function method1():String { return invokeStub('method1'); }
}