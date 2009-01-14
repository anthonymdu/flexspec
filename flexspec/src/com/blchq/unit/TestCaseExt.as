package com.blchq.unit {
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.blchq.mock.MockTestCase;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import flexunit.framework.AssertionFailedError;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.events.PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;
	import mx.utils.ObjectUtil;

	public class TestCaseExt extends MockTestCase {
		public function TestCaseExt(methodName:String=null) {
			super(methodName);
		}
	}
}