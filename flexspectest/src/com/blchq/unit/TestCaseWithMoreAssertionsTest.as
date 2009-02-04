package com.blchq.unit {
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.blchq.test.SpecTestCase;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	import flexunit.framework.AssertionFailedError;

	import mx.controls.Label;

	public class TestCaseWithMoreAssertionsTest extends SpecTestCase {
		public override function defineTests():void {
			describe('assertObjectEquals', function():void {
				it("should PassWhenObjectsEmpty", function():void {
					TestCaseWithMoreAssertions.assertObjectEquals({}, {});
				});

				it("should PassWhenObjectsHaveSameContents", function():void {
					TestCaseWithMoreAssertions.assertObjectEquals({hi: 'there', joe: 91}, {hi: 'there', joe: 91});
				});

				it("should PassWithNestedObjects", function():void {
					TestCaseWithMoreAssertions.assertObjectEquals(
						{hi: 'there', deep: {level3: {level2: 3} } },
						{hi: 'there', deep: {level3: {level2: 3} } }
					);
				});

				it("should FailWhenActualNull", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertObjectEquals({hi: 'there'}, null);
					});
				});

				it("should FailWhenActualHasDifferentValue", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertObjectEquals({hi: 'there'}, {hi: 'dawg'});
					});
				});

				it("should FailWhenActualDoesntHaveValue", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertObjectEquals({hi: 'there', joe: 9}, {hi: 'there'});
					});
				});

				it("should FailWhenActualHasExtraValue", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertObjectEquals({hi: 'there'}, {hi: 'there', joe: 9});
					});
				});

				it("should FailWhenObjectDifferentAtDeeperLevel", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertObjectEquals({hi: 'there', bye: {
																		under: 'the bridge'}},
												  {hi: 'there', bye: {
																		under: 'the sky'}});
					});
				});

				it("should IncludeUserMessageInErrorMessageForNonEqualObjects", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertObjectEquals('myUserMessage', {hi: 'there'}, {hi: 'dawg'});
					}, 'myUserMessage');
				});
			});

			describe('assertNotEquals', function():void {
				it("should PassWhenNotEqual", function():void {
					TestCaseWithMoreAssertions.assertNotEquals(1, 2);
				});

				it("should FailWhenEqual", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertNotEquals(1, 1);
					});
				});
			});

			describe('assertMatch', function():void {
				it("should PassWhenStringMatchesPattern", function():void {
					var failed:Boolean = false;

					TestCaseWithMoreAssertions.assertMatch(/12/, '12');
				});

				it("should PassWhenStringMatchesPatternAndMessageGiven", function():void {
					var failed:Boolean = false;

					TestCaseWithMoreAssertions.assertMatch('My Message', /12/, '12');
				});

				it("should PassWhenStringMatchesPatternAsStringAndMessageGiven", function():void {
					var failed:Boolean = false;

					TestCaseWithMoreAssertions.assertMatch('12', '12');
				});

				it("should FailWhenActualStringNull", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertMatch(/Hey/, null);
					});
				});

				it("should FailWhenPatternDoesNotMatch", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertMatch(/Hey/, 'Ho');
					});
				});

				it("should FailWhenPatternAsStringDoesNotMatch", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertMatch('Hey', 'Ho');
					});
				});

				it("should FailWhenPatternDoesNotMatchAndMessageGivenThatDoesMatch", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertMatch('Ho', /Hey/, 'Ho');
					});
				});

				it("should IncludeUserMessageInErrorMessageForMatch", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertMatch('myUserMessage', /Hey/, 'Ho');
					}, 'myUserMessage');
				});
			});

			describe('assertInDelta', function():void {
				it("should FailFromValuesOutsideOfDelta", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertInDelta(.2, .71, .5);
					});
				});

				it("should FailFromValuesBelowDelta", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertInDelta(.2, -.31, .5);
					});
				});

				it("should FailFromValuesOutsideOfDeltaWithMessage", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertInDelta('failure message', 2, .71, .5);
					});
				});

				it("should PassWithValueAtNegativeDelta", function():void {
					TestCaseWithMoreAssertions.assertInDelta('failure message', .8, 0, .8);
				});

				it("should PassWithValueAtDelta", function():void {
					TestCaseWithMoreAssertions.assertInDelta('failure message', .9, 1.4, .5);
				});

				it("should PassFromValuesAtDeltaWithMessage", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertInDelta('failure message', .1, .4, .3);

					}, 'failure message');
				});
			});

			describe('assertRaise', function():void {
				it("should FailFromNoErrorThrown", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertRaise(BaseError, function():void { });
					});
				});

				it("should FailFromWrongErrorThrown", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertRaise(BaseError, function():void { throw new AssertionFailedError(); });
					});
				});

				it("should FailFromSuperThrownWhenSubExpected", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertRaise(SubError, function():void { throw new BaseError(); });
					});
				});

				it("should IncludeExpectedClassInErrorMessage", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertRaise(SubError, function():void { throw new BaseError(); });
					}, 'SubError');
				});

				it("should IncludeUserMessageInErrorMessageForRaise", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertRaise('myUserMessage', SubError, function():void { throw new BaseError(); });
					}, 'myUserMessage');
				});

				it("should IncludeActualClassInErrorMessage", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertRaise(SubError, function():void { throw new BaseError(); });
					}, 'BaseError');
				});

				it("should PassFromSpecifiedErrorThrown", function():void {
					TestCaseWithMoreAssertions.assertRaise(BaseError, function():void { throw new BaseError(); });
				});

				it("should PassFromSubclassOfSpecifiedErrorThrown", function():void {
					TestCaseWithMoreAssertions.assertRaise(SubError, function():void { throw new SubError(); });
				});
			});

			describe('assertArrayEquals', function():void {
				it("should BeEqualForEmptyArrays", function():void {
					TestCaseWithMoreAssertions.assertArrayEquals([], []);
				});

				it("should BeEqualForSameArrays", function():void {
					var object:Object = new Object();
					TestCaseWithMoreAssertions.assertArrayEquals([1, 'a', object], [1, 'a', object]);
				});

				it("should BeEqualForNestedArrays", function():void {
					TestCaseWithMoreAssertions.assertArrayEquals([1, [2], [[3]], {'a': 4}], [1, [2], [[3]], {'a': 4}]);
				});

				it("should BeEqualForSameObject", function():void {
					var a:Object = new IncrementingGetter();
					TestCaseWithMoreAssertions.assertArrayEquals([a], [a]);
				});

				it("should BeEqualsForSimilarOutOfOrderArraysWhenNotOrdered", function():void {
					var object:Object = new Object();
					TestCaseWithMoreAssertions.assertArrayEquals([1, 'a', object], ['a', object, 1], false);
				});

		 		it("should NotBeEqualsForSimilarOutOfOrderArrays", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertArrayEquals([1, 'a'], ['a', 1]);
					});
		 		});
		 		
				it("should NotBeEqualsForFirstArrayLonger", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertArrayEquals([1], []);
					});
				});

				it("should NotBeEqualsForSecondArrayLonger", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertArrayEquals([], [1]);
					});
				});

				it("should IncludeUserMessageInErrorMessageForArray", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertArrayEquals('myUserMessage', [], [1]);
					}, 'myUserMessage');
				});
			});

			describe('assertCallbackFired', function():void {
				it('should pass when callback called', function():void {
					TestCaseWithMoreAssertions.assertCallbackFired(function(callback:Function):void {
						callback();
					});
				});

				it('should give a callback that can take arguments', function():void {
					TestCaseWithMoreAssertions.assertCallbackFired(function(callback:Function):void {
						callback(1, "", 3, {});
					});
				});

				it('should fail when callback not called', function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertCallbackFired(function(callback:Function):void { });
					});
				});
			});

			describe('assertEventFired', function():void {
				it("should FailWhenNoEventFired", function():void {
					var target:EventDispatcher = new EventDispatcher();

					var callback:Function = function():void {};
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertEventFired(target, "someEvent", callback);
					});
				});

				it("should PassWithCorrectEventFired", function():void {
					var target:EventDispatcher = new EventDispatcher();

					var callback:Function = function():void {
						target.dispatchEvent(new Event("someEvent"));
					};

					TestCaseWithMoreAssertions.assertEventFired(target, "someEvent", callback);
				});

				it("should FailWithIncorrectEventFired", function():void {
					var target:EventDispatcher = new EventDispatcher();

					var callback:Function = function():void {
						target.dispatchEvent(new Event("someOtherEvent"));
					};

					assertFails(function():void {
						TestCaseWithMoreAssertions.assertEventFired(target, "someEvent", callback);
					});
				});

				it("should IncludeUserMessageInErrorMessageForEvent", function():void {
					var target:EventDispatcher = new EventDispatcher();
					var callback:Function = function():void {};

					assertFails(function():void {
						TestCaseWithMoreAssertions.assertEventFired("myUserMessage", target, "someEvent", callback);
					});
				});

				it("should PassWithEventHavingCorrectConditions", function():void {
					var target:EventDispatcher = new EventDispatcher();

					var callback:Function = function():void {
						var event:EventWithProperty = new EventWithProperty();
						event.objectProp = {stringProp: 'b'};
						target.dispatchEvent(event);
					};

					var expectedConditions:Object = {objectProp: {stringProp: 'b'}};
					TestCaseWithMoreAssertions.assertEventFired(target, EventWithProperty.NAME, callback, expectedConditions);
				});

				it("should FailWithEventMissingConditions", function():void {
					var target:EventDispatcher = new EventDispatcher();

					var callback:Function = function():void {
						target.dispatchEvent(new EventWithProperty());
					};

					assertFails(function():void {
						TestCaseWithMoreAssertions.assertEventFired(target, EventWithProperty.NAME, callback, {propNotOnEvent: 'Missing Prop'});
					});
				});

				it("should FailWithEventHavingIncorrectConditions", function():void {
					var target:EventDispatcher = new EventDispatcher();

					var callback:Function = function():void {
						var event:EventWithProperty = new EventWithProperty();
						event.objectProp = {a: 'asdf'};
						target.dispatchEvent(event);
					};

					assertFails(function():void {
						TestCaseWithMoreAssertions.assertEventFired(target, EventWithProperty.NAME, callback, { a: 'a' });
					});
				});
			});

			describe('assertCairngormEventFired', function():void {
				it("should PassWithCorrectCairngormEventFired", function():void {
					var target:CairngormEventDispatcher = CairngormEventDispatcher.getInstance();

					var callback:Function = function():void {
						target.dispatchEvent(new CairngormEvent1());
					};

					TestCaseWithMoreAssertions.assertCairngormEventFired(CairngormEvent1, callback);
				});

				it("should FailWithIncorrectCairngormEventFired", function():void {
					var target:CairngormEventDispatcher = CairngormEventDispatcher.getInstance();

					var callback:Function = function():void {
						target.dispatchEvent(new CairngormEvent1());
					};

					assertFails(function():void {
						TestCaseWithMoreAssertions.assertCairngormEventFired(CairngormEvent2, callback);
					});
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
					TestCaseWithMoreAssertions.assertCairngormEventFired(CairngormEventWithProperties, callback, expectedConditions);
				});

				it("should FailWithCairngormEventMissingConditions", function():void {
					var target:CairngormEventDispatcher = CairngormEventDispatcher.getInstance();

					var callback:Function = function():void {
						target.dispatchEvent(new CairngormEventWithProperties());
					};

					assertFails(function():void {
						TestCaseWithMoreAssertions.assertCairngormEventFired(CairngormEvent2, callback, {prop3: 'Missing Prop'});
					});
				});

				it("should FailWithCairngormEventHavingIncorrectConditions", function():void {
					var target:CairngormEventDispatcher = CairngormEventDispatcher.getInstance();

					var callback:Function = function():void {
						var event:CairngormEventWithProperties = new CairngormEventWithProperties();
						event.stringProp = 'stringProp';
						target.dispatchEvent(event);
					};

					assertFails(function():void {
						TestCaseWithMoreAssertions.assertCairngormEventFired(CairngormEvent2, callback, { stringProp: 'OtherstringPropVal' });
					});
				});
			});

			describe('assertEventNotFired', function():void {
				it("should PassWhenNoEventFired", function():void {
					var target:EventDispatcher = new EventDispatcher();

					var callback:Function = function():void {};
					TestCaseWithMoreAssertions.assertEventNotFired(target, "someEvent", callback);
				});

				it("should PassWithDifferentEventFired", function():void {
					var target:EventDispatcher = new EventDispatcher();

					var callback:Function = function():void {
						target.dispatchEvent(new Event("someEvent"));
					};

					TestCaseWithMoreAssertions.assertEventNotFired(target, "someOtherEvent", callback);
				});

				it("should FailWithSameEventFired", function():void {
					var target:EventDispatcher = new EventDispatcher();

					var callback:Function = function():void {
						target.dispatchEvent(new Event("someEvent"));
					};

					assertFails(function():void {
						TestCaseWithMoreAssertions.assertEventNotFired(target, "someEvent", callback);
					});
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

					assertFails(function():void {
						TestCaseWithMoreAssertions.assertEventNotFired(target, "someEvent", callback);
					});
				});

				it("should IncludeUserMessageInErrorMessageForNotEvent", function():void {
					var target:EventDispatcher = new EventDispatcher();
					var callback:Function = function():void {
						target.dispatchEvent(new Event("someEvent"));
					};
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertEventNotFired("myUserMessage", target, "someEvent", callback
						);
					}, 'myUserMessage');
				});
			});

			describe('assertCairngormEventNotFired', function():void {
				it("should FailWithGivenCairngormEventFired", function():void {
					var target:CairngormEventDispatcher = CairngormEventDispatcher.getInstance();

					var callback:Function = function():void {
						target.dispatchEvent(new CairngormEvent1());
					};
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertCairngormEventNotFired(CairngormEvent1, callback);
					});
				});

				it("should PassWithDifferentCairngormEventFired", function():void {
					var target:CairngormEventDispatcher = CairngormEventDispatcher.getInstance();

					var callback:Function = function():void {
						target.dispatchEvent(new CairngormEvent2());
					};

					TestCaseWithMoreAssertions.assertCairngormEventNotFired(CairngormEvent1, callback);
				});

				it("should PassWithNoCairngormEventFired", function():void {
					var target:CairngormEventDispatcher = CairngormEventDispatcher.getInstance();

					var callback:Function = function():void {};

					TestCaseWithMoreAssertions.assertCairngormEventNotFired(CairngormEvent1, callback);
				});
			});

			describe('assertDateEquals', function():void {
				it("should AssertDatesEqual", function():void {
					TestCaseWithMoreAssertions.assertDateEquals(new Date(2008, 0, 1), new Date(2008, 0, 1));
				});

				it("should AssertDatesNotEqual", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertDateEquals(new Date(2008, 0, 1, 12, 5, 1), new Date(2008, 0, 1, 12, 5, 2));
					});
				});
			});

			describe('assertBindable', function():void {
				it("should PassWhenVarBindingIsTriggeredByDefaultPropertyChangeEvent", function():void {
					assertPasses(function():void {
						TestCaseWithMoreAssertions.assertBindable(new ClassWithBindings(), 'bindableVar');
					});
				});

				it("should FailWhenVarBindingIsNotTriggered", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertBindable(new ClassWithBindings(), 'bindableVar', 'eventThatDoesNotTriggerBinding');
					});
				});

				it("should PassWhenGetterBindingIsTriggeredByCustomEvent", function():void {
					assertPasses(function():void {
						TestCaseWithMoreAssertions.assertBindable(new ClassWithBindings(), 'bindableGetter', 'eventThatTriggersBinding');
					});
				});

				it("should FailWhenGetterBindingIsNotTriggered", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertBindable(new ClassWithBindings(), 'bindableGetter', 'eventThatDoesNotTriggerBinding');
					});
				});

				it("should FailWhenGetterBindingIsNotTriggeredByDefaultPropertyChangeEvent", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertBindable(new ClassWithBindings(), 'bindableGetter');
					});
				});

				it("should IncludeUserMessageInErrorMessageForBindingFailureUsingDefaultEvent", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertBindable("myUserMessage", new ClassWithBindings(), 'bindableGetter');
					}, 'myUserMessage');
				});				
				
				it("should IncludeUserMessageInErrorMessageForBindingFailureUsingCustomEvent", function():void {
					assertFails(function():void {
						TestCaseWithMoreAssertions.assertBindable("myUserMessage", new ClassWithBindings(), 'bindableGetter', 'eventThatDoesNotTriggerBinding');
					}, 'myUserMessage');
				});
			});
		}

		private function assertPasses(test:Function):void {
			test();
		}

		private function assertFails(test:Function, message:String=null):void {
			var failed:Boolean = false;
			
			try {
				test();
			} catch (e:AssertionFailedError) {
				failed = true;
				if (message != null) {
					assertTrue(e.message + " expected to contain '" + message + "'", e.message.match(message));
				}
			}
			if (!failed) fail('Assertion should have failed');
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

class IncrementingGetter {
	public var aNumber:int = 0;
	public function get incr():int {
		aNumber += 1;
		return aNumber;
	}
}