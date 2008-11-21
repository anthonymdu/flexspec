package com.blchq.unit {
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.blchq.mock.MockTestCase;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import flexunit.framework.AssertionFailedError;

	public class TestCaseExtTest extends MockTestCase {
		public override function defineTests():void {
			describe('assertObjectEquals', function():void {
				it("should PassWhenObjectsEmpty", function():void {
					TestCaseExt.assertObjectEquals({}, {});
				});
		
				it("should PassWhenObjectsHaveSameContents", function():void {
					TestCaseExt.assertObjectEquals({hi: 'there', joe: 91}, {hi: 'there', joe: 91});
				});
				
				it("should FailWhenActualNull", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseExt.assertObjectEquals({hi: 'there'}, null);
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
		
				it("should FailWhenActualHasDifferentValue", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseExt.assertObjectEquals({hi: 'there'}, {hi: 'dawg'});
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
		
				it("should FailWhenActualDoesntHaveValue", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseExt.assertObjectEquals({hi: 'there', joe: 9}, {hi: 'there'});
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
		
				it("should FailWhenActualHasExtraValue", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseExt.assertObjectEquals({hi: 'there'}, {hi: 'there', joe: 9});
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
		
				it("should FailWhenObjectDifferentAtDeeperLevel", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseExt.assertObjectEquals({hi: 'there', bye: {
																		under: 'the bridge'}}, 
												  {hi: 'there', bye: {
																		under: 'the sky'}});
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
		
				it("should IncludeUserMessageInErrorMessageForNonEqualObjects", function():void {
					var failed:Boolean = false;
					try {
						TestCaseExt.assertObjectEquals('myUserMessage', {hi: 'there'}, {hi: 'dawg'});
					} catch (e:AssertionFailedError) {
						failed = true;
						assertTrue(e.message + " expected to contain 'myUserMessage'", e.message.match('myUserMessage'));
					}
					if (!failed) fail('Assertion should have failed');
				});
			});
			
			describe('assertNotEquals', function():void {
				it("should PassWhenNotEqual", function():void {
					TestCaseExt.assertNotEquals(1, 2);
				});
		
				it("should FailWhenEqual", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseExt.assertNotEquals(1, 1);
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');			
				});
			});
			
			describe('assertMatch', function():void {
				it("should PassWhenStringMatchesPattern", function():void {
					var failed:Boolean = false;
					
					TestCaseExt.assertMatch(/12/, '12');
				});
		
				it("should PassWhenStringMatchesPatternAndMessageGiven", function():void {
					var failed:Boolean = false;
					
					TestCaseExt.assertMatch('My Message', /12/, '12');
				});
		
				it("should PassWhenStringMatchesPatternAsStringAndMessageGiven", function():void {
					var failed:Boolean = false;
					
					TestCaseExt.assertMatch('12', '12');
				});
		
				it("should FailWhenActualStringNull", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseExt.assertMatch(/Hey/, null);
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
		
				it("should FailWhenPatternDoesNotMatch", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseExt.assertMatch(/Hey/, 'Ho');
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
		
				it("should FailWhenPatternAsStringDoesNotMatch", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseExt.assertMatch('Hey', 'Ho');
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
		
				it("should FailWhenPatternDoesNotMatchAndMessageGivenThatDoesMatch", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseExt.assertMatch('Ho', /Hey/, 'Ho');
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
		
				it("should IncludeUserMessageInErrorMessageForMatch", function():void {
					var failed:Boolean = false;
					try {
						TestCaseExt.assertMatch('myUserMessage', /Hey/, 'Ho');
					} catch (e:AssertionFailedError) {
						failed = true;
						assertTrue(e.message + " expected to contain 'myUserMessage'", e.message.match('myUserMessage'));
					}
					if (!failed) fail('Assertion should have failed');
				});
			});
			
			describe('assertInDelta', function():void {
				it("should FailFromValuesOutsideOfDelta", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseExt.assertInDelta(.2, .71, .5);
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should FailFromValuesBelowDelta", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseExt.assertInDelta(.2, -.31, .5);
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should FailFromValuesOutsideOfDeltaWithMessage", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseExt.assertInDelta('failure message', 2, .71, .5);
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should PassWithValueAtNegativeDelta", function():void {
					TestCaseExt.assertInDelta('failure message', .8, 0, .8);
				});
				
				it("should PassWithValueAtDelta", function():void {
					TestCaseExt.assertInDelta('failure message', .9, 1.4, .5);
				});
				
				it("should PassFromValuesAtDeltaWithMessage", function():void {
					var failed:Boolean = false;
					try {
						TestCaseExt.assertInDelta('failure message', .1, .4, .3);
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should FailFromNoErrorThrown", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseExt.assertInDelta('failure message', .1, .4, .3);
						TestCaseExt.assertRaise(BaseError, function():void { });
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
			});
			
			describe('assertRaise', function():void {
				it("should FailFromWrongErrorThrown", function():void {
					var failed:Boolean = false;
					try {
						TestCaseExt.assertRaise(BaseError, function():void { throw new AssertionFailedError(); });
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should FailFromSuperThrownWhenSubExpected", function():void {
					var failed:Boolean = false;
					try {
						TestCaseExt.assertRaise(SubError, function():void { throw new BaseError(); });
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should IncludeExpectedClassInErrorMessage", function():void {
					var failed:Boolean = false;
					try {
						TestCaseExt.assertRaise(SubError, function():void { throw new BaseError(); });
					} catch (e:AssertionFailedError) {
						failed = true;
						assertTrue(e.message + " expected to contain SubError", e.message.match('SubError'));
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should IncludeUserMessageInErrorMessageForRaise", function():void {
					var failed:Boolean = false;
					try {
						TestCaseExt.assertRaise('myUserMessage', SubError, function():void { throw new BaseError(); });
					} catch (e:AssertionFailedError) {
						failed = true;
						assertTrue(e.message + " expected to contain 'myUserMessage'", e.message.match('myUserMessage'));
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should IncludeActualClassInErrorMessage", function():void {
					var failed:Boolean = false;
					try {
						TestCaseExt.assertRaise(SubError, function():void { throw new BaseError(); });
					} catch (e:AssertionFailedError) {
						failed = true;
						assertTrue(e.message + " expected to contain BaseError", e.message.match('BaseError'));
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should PassFromSpecifiedErrorThrown", function():void {
					var failed:Boolean = false;
					TestCaseExt.assertRaise(BaseError, function():void { throw new BaseError(); });
				});
				
				it("should PassFromSubclassOfSpecifiedErrorThrown", function():void {
					TestCaseExt.assertRaise(SubError, function():void { throw new SubError(); });
		 		});
			});
			
			describe('assertArrayEquals', function():void {
		 		it("should BeEqualsForEmptyArrays", function():void {
		 			TestCaseExt.assertArrayEquals([], []);
		 		});
		 		
		 		it("should BeEqualsForSameArrays", function():void {
		 			var object:Object = new Object();
		 			TestCaseExt.assertArrayEquals([1, 'a', object], [1, 'a', object]);
		 		});
		 		
		 		it("should NotBeEqualsForSimilarOutOfOrderArrays", function():void {
					var failed:Boolean = false;
					try {
						TestCaseExt.assertArrayEquals([1, 'a'], ['a', 1]);
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
		 		});
		 		
		 		it("should BeEqualsForSimilarOutOfOrderArraysWhenNotOrdered", function():void {
		 			var object:Object = new Object();
		 			TestCaseExt.assertArrayEquals([1, 'a', object], ['a', object, 1], false);
		 		});
				
				it("should NotBeEqualsForFirstArrayLonger", function():void {
					var failed:Boolean = false;
					try {
						TestCaseExt.assertArrayEquals([1], []);
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should NotBeEqualsForSecondArrayLonger", function():void {
					var failed:Boolean = false;
					try {
						TestCaseExt.assertArrayEquals([], [1]);
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should IncludeUserMessageInErrorMessageForArray", function():void {
					var failed:Boolean = false;
					try {
						TestCaseExt.assertArrayEquals('myUserMessage', [], [1]);
					} catch (e:AssertionFailedError) {
						failed = true;
						assertTrue(e.message.match('myUserMessage'));
					}
					if (!failed) fail('Assertion should have failed');
				});
			});
			
			describe('assertCallbackFired', function():void {
				it('should pass when callback called', function():void {
					TestCaseExt.assertCallbackFired(function(callback:Function):void {
						callback();
					});
				});

				it('should give a callback that can take arguments', function():void {
					TestCaseExt.assertCallbackFired(function(callback:Function):void {
						callback(1, "", 3, {});
					});
				});

				it('should fail when callback not called', function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseExt.assertCallbackFired(function(callback:Function):void { });
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
			});
			
			describe('assertEventFired', function():void {
				it("should FailWhenNoEventFired", function():void {
					var target:EventDispatcher = new EventDispatcher();
								
					var callback:Function = function():void {};
					var failed:Boolean = false;
					
					try {
						TestCaseExt.assertEventFired(target, "someEvent", callback);
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should PassWithCorrectEventFired", function():void {
					var target:EventDispatcher = new EventDispatcher();
					
					var callback:Function = function():void {
						target.dispatchEvent(new Event("someEvent"));
					};
					
					TestCaseExt.assertEventFired(target, "someEvent", callback);
				});
				
				it("should FailWithIncorrectEventFired", function():void {
					var target:EventDispatcher = new EventDispatcher();
					
					var callback:Function = function():void {
						target.dispatchEvent(new Event("someOtherEvent"));
					};
		
					var failed:Boolean = false;
					
					try {
						TestCaseExt.assertEventFired(target, "someEvent", callback);
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should IncludeUserMessageInErrorMessageForEvent", function():void {
					var target:EventDispatcher = new EventDispatcher();
					var callback:Function = function():void {};
					
					var failed:Boolean = false;
					try {
						TestCaseExt.assertEventFired("myUserMessage", target, "someEvent", callback);
					} catch (e:AssertionFailedError) {
						failed = true;
						assertTrue(e.message.match('myUserMessage'));
					}
					if (!failed) fail('Assertion should have failed');
				});
		
				it("should PassWithEventHavingCorrectConditions", function():void {
					var target:EventDispatcher = new EventDispatcher();
					
					var callback:Function = function():void {
						var event:EventWithProperty = new EventWithProperty();
						event.objectProp = {stringProp: 'b'};
						target.dispatchEvent(event);
					};
					
					var expectedConditions:Object = {objectProp: {stringProp: 'b'}};
					TestCaseExt.assertEventFired(target, EventWithProperty.NAME, callback, expectedConditions);
				});
				
				it("should FailWithEventMissingConditions", function():void {
					var target:EventDispatcher = new EventDispatcher();
					
					var callback:Function = function():void {
						target.dispatchEvent(new EventWithProperty());
					};
		
					var failed:Boolean = false;
					
					try {
						TestCaseExt.assertEventFired(target, EventWithProperty.NAME, callback, {propNotOnEvent: 'Missing Prop'});
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
		
				it("should FailWithEventHavingIncorrectConditions", function():void {
					var target:EventDispatcher = new EventDispatcher();
					
					var callback:Function = function():void {
						var event:EventWithProperty = new EventWithProperty();
						event.objectProp = {a: 'asdf'};
						target.dispatchEvent(event);
					};
		
					var failed:Boolean = false;
					
					try {
						TestCaseExt.assertEventFired(target, EventWithProperty.NAME, callback, { a: 'a' });
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
			});
			
			describe('assertCairngormEventFired', function():void {
				it("should PassWithCorrectCairngormEventFired", function():void {
					var target:CairngormEventDispatcher = CairngormEventDispatcher.getInstance();
					
					var callback:Function = function():void {
						target.dispatchEvent(new CairngormEvent1());
					};
					
					TestCaseExt.assertCairngormEventFired(CairngormEvent1, callback);
				});
				
				it("should FailWithIncorrectCairngormEventFired", function():void {
					var target:CairngormEventDispatcher = CairngormEventDispatcher.getInstance();
					
					var callback:Function = function():void {
						target.dispatchEvent(new CairngormEvent1());
					};
		
					var failed:Boolean = false;
					
					try {
						TestCaseExt.assertCairngormEventFired(CairngormEvent2, callback);
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should PassWithCairngormEventHavingCorrectConditions", function():void {
					var target:CairngormEventDispatcher = CairngormEventDispatcher.getInstance();
					
					var callback:Function = function():void {
						var event:CairngormEventWithProperties = new CairngormEventWithProperties();
						event.stringProp = 'EventProperty';
						event.arrayProp = ['EventProp2Val1', 'EventProp2Val2'];
						target.dispatchEvent(event);
					};
					
					var expectedConditions:Object = { stringProp: 'EventProperty',
													  arrayProp: ['EventProp2Val1', 'EventProp2Val2']};
					TestCaseExt.assertCairngormEventFired(CairngormEventWithProperties, callback, expectedConditions);
				});
				
				it("should FailWithCairngormEventMissingConditions", function():void {
					var target:CairngormEventDispatcher = CairngormEventDispatcher.getInstance();
					
					var callback:Function = function():void {
						target.dispatchEvent(new CairngormEventWithProperties());
					};
		
					var failed:Boolean = false;
					
					try {
						TestCaseExt.assertCairngormEventFired(CairngormEvent2, callback, {prop3: 'Missing Prop'});
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
		
				it("should FailWithCairngormEventHavingIncorrectConditions", function():void {
					var target:CairngormEventDispatcher = CairngormEventDispatcher.getInstance();
					
					var callback:Function = function():void {
						var event:CairngormEventWithProperties = new CairngormEventWithProperties();
						event.stringProp = 'stringProp';
						target.dispatchEvent(event);
					};
		
					var failed:Boolean = false;
					
					try {
						TestCaseExt.assertCairngormEventFired(CairngormEvent2, callback, { stringProp: 'OtherstringPropVal' });
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
			});
			
			describe('assertEventNotFired', function():void {
				it("should PassWhenNoEventFired", function():void {
					var target:EventDispatcher = new EventDispatcher();
								
					var callback:Function = function():void {};
					var failed:Boolean = false;
					
					TestCaseExt.assertEventNotFired(target, "someEvent", callback);
				});
				
				it("should PassWithDifferentEventFired", function():void {
					var target:EventDispatcher = new EventDispatcher();
					
					var callback:Function = function():void {
						target.dispatchEvent(new Event("someEvent"));
					};
					
					TestCaseExt.assertEventNotFired(target, "someOtherEvent", callback);
				});
				
				it("should FailWithSameEventFired", function():void {
					var target:EventDispatcher = new EventDispatcher();
					
					var callback:Function = function():void {
						target.dispatchEvent(new Event("someEvent"));
					};
		
					var failed:Boolean = false;
					
					try {
						TestCaseExt.assertEventNotFired(target, "someEvent", callback);
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should FailWithSameEventFiredAlongWithOtherEvents", function():void {
					var target:EventDispatcher = new EventDispatcher();
					
					// fire multiple events, making sure that as long as the event we asked about
					// was fired, it'll fail
					var callback:Function = function():void {
						target.dispatchEvent(new Event("someOtherEvent"));
						target.dispatchEvent(new Event("someEvent"));
						target.dispatchEvent(new Event("someOtherOtherEvent"));
					};
		
					var failed:Boolean = false;
					
					try {
						TestCaseExt.assertEventNotFired(target, "someEvent", callback);
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should IncludeUserMessageInErrorMessageForNotEvent", function():void {
					var target:EventDispatcher = new EventDispatcher();
					var callback:Function = function():void {
						target.dispatchEvent(new Event("someEvent"));
					};
					
					var failed:Boolean = false;
					try {
						TestCaseExt.assertEventNotFired("myUserMessage", target, "someEvent", callback);
					} catch (e:AssertionFailedError) {
						failed = true;
						assertTrue(e.message.match('myUserMessage'));
					}
					if (!failed) fail('Assertion should have failed');
				});
			});
			
			describe('assertCairngormEventNotFired', function():void {
				it("should FailWithGivenCairngormEventFired", function():void {
					var target:CairngormEventDispatcher = CairngormEventDispatcher.getInstance();
					
					var callback:Function = function():void {
						target.dispatchEvent(new CairngormEvent1());
					};
		
					var failed:Boolean = false;
					
					try {
						TestCaseExt.assertCairngormEventNotFired(CairngormEvent1, callback);
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should PassWithDifferentCairngormEventFired", function():void {
					var target:CairngormEventDispatcher = CairngormEventDispatcher.getInstance();
					
					var callback:Function = function():void {
						target.dispatchEvent(new CairngormEvent2());
					};
					
					TestCaseExt.assertCairngormEventNotFired(CairngormEvent1, callback);
				});
				
				it("should PassWithNoCairngormEventFired", function():void {
					var target:CairngormEventDispatcher = CairngormEventDispatcher.getInstance();
					
					var callback:Function = function():void {};
					
					TestCaseExt.assertCairngormEventNotFired(CairngormEvent1, callback);
				});
			});
			
			describe('assertDateEquals', function():void {
				it("should AssertDatesEqual", function():void {
					TestCaseExt.assertDateEquals(new Date(2008, 0, 1), new Date(2008, 0, 1));
				});
				
				it("should AssertDatesNotEqual", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseExt.assertDateEquals(new Date(2008, 0, 1, 12, 5, 1), new Date(2008, 0, 1, 12, 5, 2));
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
			});
			
			describe('assertBindable', function():void {
				it("should PassWhenVarBindingIsTriggeredByDefaultPropertyChangeEvent", function():void {
					TestCaseExt.assertBindable(new ClassWithBindings(), 'bindableVar');
				});
				
				it("should FailWhenVarBindingIsNotTriggered", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseExt.assertBindable(new ClassWithBindings(), 'bindableVar', 'eventThatDoesNotTriggerBinding');
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should PassWhenGetterBindingIsTriggeredByCustomEvent", function():void {
					TestCaseExt.assertBindable(new ClassWithBindings(), 'bindableGetter', 'eventThatTriggersBinding');
				});
				
				it("should FailWhenGetterBindingIsNotTriggered", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseExt.assertBindable(new ClassWithBindings(), 'bindableGetter', 'eventThatDoesNotTriggerBinding');
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should FailWhenGetterBindingIsNotTriggeredByDefaultPropertyChangeEvent", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseExt.assertBindable(new ClassWithBindings(), 'bindableGetter');
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});

				it("should IncludeUserMessageInErrorMessageForBindingFailureUsingDefaultEvent", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseExt.assertBindable("myUserMessage", new ClassWithBindings(), 'bindableGetter');
					} catch (e:AssertionFailedError) {
						failed = true;
						assertTrue(e.message.match('myUserMessage'));
					}
					if (!failed) fail('Assertion should have failed');
				});				
				
				it("should IncludeUserMessageInErrorMessageForBindingFailureUsingCustomEvent", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseExt.assertBindable("myUserMessage", new ClassWithBindings(), 'bindableGetter', 'eventThatDoesNotTriggerBinding');
					} catch (e:AssertionFailedError) {
						failed = true;
						assertTrue(e.message.match('myUserMessage'));
					}
					if (!failed) fail('Assertion should have failed');
				});				
				
			});
		}
	}
}

import com.adobe.cairngorm.control.CairngormEvent;
import flash.events.Event;
import flash.events.EventDispatcher;

class CairngormEvent1 extends CairngormEvent {
	public function CairngormEvent1() {
		super("EVENT1");
	}
}
class CairngormEvent2 extends CairngormEvent {
	public function CairngormEvent2() {
		super("EVENT2");
	}
}

class CairngormEventWithProperties extends CairngormEvent {
	public var stringProp:String = 'EventProperty';
	public var arrayProp:Array = ['EventProp2Val1', 'EventProp2Val2'];
	
	public function CairngormEventWithProperties() {
		super("EVENT_WITH_PROPERTIES");
	}
}

class BaseError extends Error {
	
}

class SubError extends BaseError {
	
}

class EventWithProperty extends Event {
	public static const NAME:String = "EVENT_WITH_PROP";
	public var objectProp:Object;

	public function EventWithProperty() {
		super(NAME);
	}
}

class ClassWithBindings extends EventDispatcher {
	
	[Bindable]
	public var bindableVar:String = "";
	
	[Bindable("eventThatTriggersBinding")]
	public function get bindableGetter():String { return ""; }
	
}