import com.blchq.mock.Expectation;
import com.blchq.mock.MockExpectation;
import com.blchq.mock.MockNegativeExpectation;
import com.blchq.mock.Proxy;
import com.blchq.mock.StubExpectation;

private var __proxy:Proxy = new Proxy(this);

public function superMethodOrProp(method:String):* {
	return super[method];
}

public function stubs(method:String):Expectation {
	return __proxy.buildExpectation(method, StubExpectation);
}

public function stub(method:String):Expectation {
	return stubs(method);
}

public function expects(method:String):Expectation {
	return __proxy.buildExpectation(method, MockExpectation);
}

public function shouldReceive(method:String):Expectation {
	return expects(method);
}

public function shouldNotReceive(method:String):Expectation {
	return __proxy.buildExpectation(method, MockNegativeExpectation);
}

private function invokeStub(name:String, ...args):* {
	return __proxy.invokeStub(name, args);
}