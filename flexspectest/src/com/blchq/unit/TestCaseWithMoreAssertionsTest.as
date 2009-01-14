package com.blchq.unit {
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.blchq.test.SpecTestCase;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import flexunit.framework.AssertionFailedError;

	public class TestCaseWithMoreAssertionsTest extends SpecTestCase {
		public override function defineTests():void {
			describe('assertObjectEquals', function():void {
				it("should PassWhenObjectsEmpty", function():void {
					TestCaseWithMoreAssertions.assertObjectEquals({}, {});
				});
		
				it("should PassWhenObjectsHaveSameContents", function():void {
					TestCaseWithMoreAssertions.assertObjectEquals({hi: 'there', joe: 91}, {hi: 'there', joe: 91});
				});
				
				it("should FailWhenActualNull", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseWithMoreAssertions.assertObjectEquals({hi: 'there'}, null);
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
		
				it("should FailWhenActualHasDifferentValue", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseWithMoreAssertions.assertObjectEquals({hi: 'there'}, {hi: 'dawg'});
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
		
				it("should FailWhenActualDoesntHaveValue", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseWithMoreAssertions.assertObjectEquals({hi: 'there', joe: 9}, {hi: 'there'});
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
		
				it("should FailWhenActualHasExtraValue", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseWithMoreAssertions.assertObjectEquals({hi: 'there'}, {hi: 'there', joe: 9});
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
		
				it("should FailWhenObjectDifferentAtDeeperLevel", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseWithMoreAssertions.assertObjectEquals({hi: 'there', bye: {
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
						TestCaseWithMoreAssertions.assertObjectEquals('myUserMessage', {hi: 'there'}, {hi: 'dawg'});
					} catch (e:AssertionFailedError) {
						failed = true;
						assertTrue(e.message + " expected to contain 'myUserMessage'", e.message.match('myUserMessage'));
					}
					if (!failed) fail('Assertion should have failed');
				});
			});
			
			describe('assertNotEquals', function():void {
				it("should PassWhenNotEqual", function():void {
					TestCaseWithMoreAssertions.assertNotEquals(1, 2);
				});
		
				it("should FailWhenEqual", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseWithMoreAssertions.assertNotEquals(1, 1);
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');			
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
					var failed:Boolean = false;
					
					try {
						TestCaseWithMoreAssertions.assertMatch(/Hey/, null);
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
		
				it("should FailWhenPatternDoesNotMatch", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseWithMoreAssertions.assertMatch(/Hey/, 'Ho');
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
		
				it("should FailWhenPatternAsStringDoesNotMatch", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseWithMoreAssertions.assertMatch('Hey', 'Ho');
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
		
				it("should FailWhenPatternDoesNotMatchAndMessageGivenThatDoesMatch", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseWithMoreAssertions.assertMatch('Ho', /Hey/, 'Ho');
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
		
				it("should IncludeUserMessageInErrorMessageForMatch", function():void {
					var failed:Boolean = false;
					try {
						TestCaseWithMoreAssertions.assertMatch('myUserMessage', /Hey/, 'Ho');
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
						TestCaseWithMoreAssertions.assertInDelta(.2, .71, .5);
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should FailFromValuesBelowDelta", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseWithMoreAssertions.assertInDelta(.2, -.31, .5);
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should FailFromValuesOutsideOfDeltaWithMessage", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseWithMoreAssertions.assertInDelta('failure message', 2, .71, .5);
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should PassWithValueAtNegativeDelta", function():void {
					TestCaseWithMoreAssertions.assertInDelta('failure message', .8, 0, .8);
				});
				
				it("should PassWithValueAtDelta", function():void {
					TestCaseWithMoreAssertions.assertInDelta('failure message', .9, 1.4, .5);
				});
				
				it("should PassFromValuesAtDeltaWithMessage", function():void {
					var failed:Boolean = false;
					try {
						TestCaseWithMoreAssertions.assertInDelta('failure message', .1, .4, .3);
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should FailFromNoErrorThrown", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseWithMoreAssertions.assertInDelta('failure message', .1, .4, .3);
						TestCaseWithMoreAssertions.assertRaise(BaseError, function():void { });
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
						TestCaseWithMoreAssertions.assertRaise(BaseError, function():void { throw new AssertionFailedError(); });
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should FailFromSuperThrownWhenSubExpected", function():void {
					var failed:Boolean = false;
					try {
						TestCaseWithMoreAssertions.assertRaise(SubError, function():void { throw new BaseError(); });
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should IncludeExpectedClassInErrorMessage", function():void {
					var failed:Boolean = false;
					try {
						TestCaseWithMoreAssertions.assertRaise(SubError, function():void { throw new BaseError(); });
					} catch (e:AssertionFailedError) {
						failed = true;
						assertTrue(e.message + " expected to contain SubError", e.message.match('SubError'));
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should IncludeUserMessageInErrorMessageForRaise", function():void {
					var failed:Boolean = false;
					try {
						TestCaseWithMoreAssertions.assertRaise('myUserMessage', SubError, function():void { throw new BaseError(); });
					} catch (e:AssertionFailedError) {
						failed = true;
						assertTrue(e.message + " expected to contain 'myUserMessage'", e.message.match('myUserMessage'));
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should IncludeActualClassInErrorMessage", function():void {
					var failed:Boolean = false;
					try {
						TestCaseWithMoreAssertions.assertRaise(SubError, function():void { throw new BaseError(); });
					} catch (e:AssertionFailedError) {
						failed = true;
						assertTrue(e.message + " expected to contain BaseError", e.message.match('BaseError'));
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should PassFromSpecifiedErrorThrown", function():void {
					var failed:Boolean = false;
					TestCaseWithMoreAssertions.assertRaise(BaseError, function():void { throw new BaseError(); });
				});
				
				it("should PassFromSubclassOfSpecifiedErrorThrown", function():void {
					TestCaseWithMoreAssertions.assertRaise(SubError, function():void { throw new SubError(); });
		 		});
			});
			
			describe('assertArrayEquals', function():void {
		 		it("should BeEqualsForEmptyArrays", function():void {
		 			TestCaseWithMoreAssertions.assertArrayEquals([], []);
		 		});
		 		
		 		it("should BeEqualsForSameArrays", function():void {
		 			var object:Object = new Object();
		 			TestCaseWithMoreAssertions.assertArrayEquals([1, 'a', object], [1, 'a', object]);
		 		});
		 		
		 		it("should NotBeEqualsForSimilarOutOfOrderArrays", function():void {
					var failed:Boolean = false;
					try {
						TestCaseWithMoreAssertions.assertArrayEquals([1, 'a'], ['a', 1]);
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
		 		});
		 		
		 		it("should BeEqualsForSimilarOutOfOrderArraysWhenNotOrdered", function():void {
		 			var object:Object = new Object();
		 			TestCaseWithMoreAssertions.assertArrayEquals([1, 'a', object], ['a', object, 1], false);
		 		});
				
				it("should NotBeEqualsForFirstArrayLonger", function():void {
					var failed:Boolean = false;
					try {
						TestCaseWithMoreAssertions.assertArrayEquals([1], []);
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should NotBeEqualsForSecondArrayLonger", function():void {
					var failed:Boolean = false;
					try {
						TestCaseWithMoreAssertions.assertArrayEquals([], [1]);
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should IncludeUserMessageInErrorMessageForArray", function():void {
					var failed:Boolean = false;
					try {
						TestCaseWithMoreAssertions.assertArrayEquals('myUserMessage', [], [1]);
					} catch (e:AssertionFailedError) {
						failed = true;
						assertTrue(e.message.match('myUserMessage'));
					}
					if (!failed) fail('Assertion should have failed');
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
					var failed:Boolean = false;
					
					try {
						TestCaseWithMoreAssertions.assertCallbackFired(function(callback:Function):void { });
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
						TestCaseWithMoreAssertions.assertEventFired(target, "someEvent", callback);
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
					
					TestCaseWithMoreAssertions.assertEventFired(target, "someEvent", callback);
				});
				
				it("should FailWithIncorrectEventFired", function():void {
					var target:EventDispatcher = new EventDispatcher();
					
					var callback:Function = function():void {
						target.dispatchEvent(new Event("someOtherEvent"));
					};
		
					var failed:Boolean = false;
					
					try {
						TestCaseWithMoreAssertions.assertEventFired(target, "someEvent", callback);
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
						TestCaseWithMoreAssertions.assertEventFired("myUserMessage", target, "someEvent", callback);
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
					TestCaseWithMoreAssertions.assertEventFired(target, EventWithProperty.NAME, callback, expectedConditions);
				});
				
				it("should FailWithEventMissingConditions", function():void {
					var target:EventDispatcher = new EventDispatcher();
					
					var callback:Function = function():void {
						target.dispatchEvent(new EventWithProperty());
					};
		
					var failed:Boolean = false;
					
					try {
						TestCaseWithMoreAssertions.assertEventFired(target, EventWithProperty.NAME, callback, {propNotOnEvent: 'Missing Prop'});
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
						TestCaseWithMoreAssertions.assertEventFired(target, EventWithProperty.NAME, callback, { a: 'a' });
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
					
					TestCaseWithMoreAssertions.assertCairngormEventFired(CairngormEvent1, callback);
				});
				
				it("should FailWithIncorrectCairngormEventFired", function():void {
					var target:CairngormEventDispatcher = CairngormEventDispatcher.getInstance();
					
					var callback:Function = function():void {
						target.dispatchEvent(new CairngormEvent1());
					};
		
					var failed:Boolean = false;
					
					try {
						TestCaseWithMoreAssertions.assertCairngormEventFired(CairngormEvent2, callback);
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
					TestCaseWithMoreAssertions.assertCairngormEventFired(CairngormEventWithProperties, callback, expectedConditions);
				});
				
				it("should FailWithCairngormEventMissingConditions", function():void {
					var target:CairngormEventDispatcher = CairngormEventDispatcher.getInstance();
					
					var callback:Function = function():void {
						target.dispatchEvent(new CairngormEventWithProperties());
					};
		
					var failed:Boolean = false;
					
					try {
						TestCaseWithMoreAssertions.assertCairngormEventFired(CairngormEvent2, callback, {prop3: 'Missing Prop'});
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
						TestCaseWithMoreAssertions.assertCairngormEventFired(CairngormEvent2, callback, { stringProp: 'OtherstringPropVal' });
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
		
					var failed:Boolean = false;
					
					try {
						TestCaseWithMoreAssertions.assertEventNotFired(target, "someEvent", callback);
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
						TestCaseWithMoreAssertions.assertEventNotFired(target, "someEvent", callback);
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
						TestCaseWithMoreAssertions.assertEventNotFired("myUserMessage", target, "someEvent", callback);
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
						TestCaseWithMoreAssertions.assertCairngormEventNotFired(CairngormEvent1, callback);
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
					var failed:Boolean = false;
					
					try {
						TestCaseWithMoreAssertions.assertDateEquals(new Date(2008, 0, 1, 12, 5, 1), new Date(2008, 0, 1, 12, 5, 2));
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
			});
			
			describe('assertBindable', function():void {
				it("should PassWhenVarBindingIsTriggeredByDefaultPropertyChangeEvent", function():void {
					TestCaseWithMoreAssertions.assertBindable(new ClassWithBindings(), 'bindableVar');
				});
				
				it("should FailWhenVarBindingIsNotTriggered", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseWithMoreAssertions.assertBindable(new ClassWithBindings(), 'bindableVar', 'eventThatDoesNotTriggerBinding');
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should PassWhenGetterBindingIsTriggeredByCustomEvent", function():void {
					TestCaseWithMoreAssertions.assertBindable(new ClassWithBindings(), 'bindableGetter', 'eventThatTriggersBinding');
				});
				
				it("should FailWhenGetterBindingIsNotTriggered", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseWithMoreAssertions.assertBindable(new ClassWithBindings(), 'bindableGetter', 'eventThatDoesNotTriggerBinding');
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});
				
				it("should FailWhenGetterBindingIsNotTriggeredByDefaultPropertyChangeEvent", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseWithMoreAssertions.assertBindable(new ClassWithBindings(), 'bindableGetter');
					} catch (e:AssertionFailedError) {
						failed = true;
					}
					if (!failed) fail('Assertion should have failed');
				});

				it("should IncludeUserMessageInErrorMessageForBindingFailureUsingDefaultEvent", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseWithMoreAssertions.assertBindable("myUserMessage", new ClassWithBindings(), 'bindableGetter');
					} catch (e:AssertionFailedError) {
						failed = true;
						assertTrue(e.message.match('myUserMessage'));
					}
					if (!failed) fail('Assertion should have failed');
				});				
				
				it("should IncludeUserMessageInErrorMessageForBindingFailureUsingCustomEvent", function():void {
					var failed:Boolean = false;
					
					try {
						TestCaseWithMoreAssertions.assertBindable("myUserMessage", new ClassWithBindings(), 'bindableGetter', 'eventThatDoesNotTriggerBinding');
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