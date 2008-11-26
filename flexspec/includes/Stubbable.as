import com.blchq.mock.Expectation;
import com.blchq.mock.MockExpectation;
import com.blchq.mock.MockInfo;
import com.blchq.mock.MockNegativeExpectation;
import com.blchq.mock.StubExpectation;

public var mockInfo:MockInfo = new MockInfo(this);

public function superMethodOrProp(method:String):* {
	return super[method];
}

public function stubs(method:String):Expectation {
	return mockInfo.buildExpectation(method, StubExpectation);
}

public function stub(method:String):Expectation {
	return stubs(method);
}

public function expects(method:String):Expectation {
	return mockInfo.buildExpectation(method, MockExpectation);
}

public function shouldReceive(method:String):Expectation {
	return expects(method);
}

public function shouldNotReceive(method:String):Expectation {
	return mockInfo.buildExpectation(method, MockNegativeExpectation);
}

private function invokeStub(name:String, ...args):* {
	return mockInfo.invokeStub(name, args);
}