package com.blchq.unit {
        import com.adobe.cairngorm.control.CairngormEventDispatcher;

        import flash.errors.IllegalOperationError;
        import flash.events.Event;
        import flash.utils.getQualifiedClassName;

        import flexunit.framework.AssertionFailedError;
        import flexunit.framework.TestCase;

        import mx.binding.utils.ChangeWatcher;
        import mx.events.PropertyChangeEvent;
        import mx.events.PropertyChangeEventKind;
        import mx.utils.ObjectUtil;

        public class TestCaseWithMoreAssertions extends TestCase {
                public function TestCaseWithMoreAssertions(methodName:String=null) {
                        super(methodName);
                }

                public static function assertCallbackFired(...args):void {
                        var userMessage:String = '';
                        if (args.length == 2) userMessage = args.shift();

                        var testCallback:Function = args.shift();

                        var callbackFired:Boolean = false;
                        var callbackToBeFired:Function = function(...args):void {
                                callbackFired = true;
                        };

                        testCallback(callbackToBeFired);

                        if (!callbackFired) {
                                failWithUserMessage(userMessage, "Expected callback to be fired, but was not");
                        }
                }

                public static function assertObjectEquals(...args):void {
                        var userMessage:String = '';
                        if (args.length == 3) userMessage = args.shift();

                        var expected:Object = args.shift();
                        var actual:Object = args.shift();

                        var match:Boolean;
                        if (!actual) {
                                match = false;
                        } else {
                                match = (ObjectUtil.compare(expected, actual) == 0);
                        }

                        if (!match) {
                                failWithUserMessage(userMessage, "Expected " + ObjectUtil.toString(actual) + " to be equal to " + ObjectUtil.toString(expected));
                        }
                }

                /**
                 * Takes the following arguments and verifies the actual value matches the pattern:
                 *    1 - Optional message to display if the event is fired
                 *    2 - Expected pattern
                 *    3 - Actual value
                 */
                public static function assertMatch(...args):void {
                        var userMessage:String = '';
                        if (args.length == 3) userMessage = args.shift();

                        var expectedPattern:Object = args.shift();
                        var actual:String = args.shift();

                        var match:Boolean;
                        if (!actual) {
                                match = false;
                        } else {
                                match = actual.match(expectedPattern) != null;
                        }

                        if (!match) {
                                failWithUserMessage(userMessage, "Expected " + actual + " to match " + expectedPattern);
                        }
                }

                /**
                 * Takes the following arguments:
                 *
                 *    1 - Optional message to display if the event is fired
                 *    2 - Expected array
                 *    3 - Actual array
                 *        [4 - Compare order? (boolean) default: true]
                 */
                public static function assertArrayEquals(...args):void {
                        var userMessage:String = '';
                        if (args[0] is String) userMessage = args.shift();

                        var expected:Array = args.shift();
                        var actual:Array = args.shift();



                        if (expected.length != actual.length) {
                                failArrayEquals("in length (" + expected.length + " != " + actual.length + ")", userMessage, expected, actual);
                        }

                        var ordered:Boolean = true;
                        if (args.length > 0) ordered = args.shift();

                        var expectedCopy:Array = expected.concat();
                        var actualCopy:Array = actual.concat();

                        if (!ordered) {
                                expectedCopy.sort();
                                actualCopy.sort();
                        }

                        var differedIndex:int = compareArrays(expectedCopy, actualCopy);

                        if (differedIndex >= 0) {
                                failArrayEquals("at " + differedIndex + ", value " + expectedCopy[differedIndex], userMessage, expected, actual);
                        }
                }

                public static function compareArrays(expected:Array, actual:Array):int {
                        for (var i:int = 0; i < expected.length; i++) {
                                if ( ObjectUtil.compare(expected[i], actual[i]) != 0 ) return i
                        }

                        return -1;
                }

                private static function failArrayEquals(differenceTypeMessage:String, userMessage:String, expected:Array, actual:Array):void {
                        failWithUserMessage(userMessage, "Arrays differed " + differenceTypeMessage +
                                                                                         "\nexpected array: " + ObjectUtil.toString(expected) +
                                                                                         "\nactual array: " + ObjectUtil.toString(actual));
                }

                public static function assertInDelta(... args):void {
                        var userMessage:String = '';
                        if (args[0] is String) userMessage = args.shift();
                        var expected:Number = args.shift();
                        var actual:Number = args.shift();
                        var delta:Number = args.shift();

                        var difference:Number = Math.abs(expected - actual);
                        if (difference > delta) {
                                failWithUserMessage(userMessage, actual + " not within " + delta + " of " + expected);
                        }
                }

                public static function assertRaise(... args):void {
                        var userMessage:String = '';
                        if (args[0] is String) userMessage = args.shift();
                        var errorClass:Class = args.shift();
                        var callback:Function = args.shift();

                        var failMessageAddendum:String = null;
                        try {
                                callback();
                                failMessageAddendum = "none was thrown.";
                        } catch (e:Error) {
                                if (!(e is errorClass)) {
                                        failMessageAddendum = "was " + getQualifiedClassName(e);
                                }
                        }
                        if (failMessageAddendum != null) {
                                failWithUserMessage(userMessage, "Expected an exception of " + errorClass + " to be thrown, but " + failMessageAddendum);
                        }
                }

                public static function assertEventFired(... args):void {
                        assertEvent(true, args);
                }

                public static function assertEventNotFired(... args):void {
                        assertEvent(false, args);
                }

                private static function assertEvent(shouldBeFired:Boolean, args:Array):void {
                        var userMessage:String = '';
                        if (args[0] is String) userMessage = args.shift();

                        var eventSource:Object = args.shift();
                        var eventName:String = args.shift();

                        var callback:Function = args.shift();

                        var actualEvent:Event = null;

                        eventSource.addEventListener(eventName, function(event:Event):void {
                                actualEvent = event;
                        });

                        callback();

                        var eventWasFired:Boolean = actualEvent != null && actualEvent.type == eventName;

                        if (eventWasFired && !shouldBeFired) {
                                failWithUserMessage(userMessage, "Expected event " + eventName + " NOT to be fired, but was");
                        } else if (!eventWasFired && shouldBeFired) {
                                var actualType:String = actualEvent ? actualEvent.type : 'not';

                                failWithUserMessage(userMessage, "Expected event " + eventName + " to be fired, but was " + actualType);
                        } else if (eventWasFired && shouldBeFired) {
                                var conditions:Object = args.shift();
                                if (conditions != null) assertEventConditions(actualEvent, conditions);
                        }
                }

                public static function assertDateEquals(... args):void {
                        var userMessage:String = '';
                        if (args[0] is String) userMessage = args.shift();

                        var expected:Date = args.shift() as Date;
                        var actual:Date = args.shift() as Date;

                        if (expected.time != actual.time) {
                                failWithUserMessage(userMessage, "Expected: " + expected + ", but was: "  + actual);
                        }

                }

                /**
                 * Takes the following arguments:
                 *
                 *    1 - Optional message to display if callback not fired
                 *    2 - Event Class that should be fired
                 *    3 - Callback that should fire the event
                 */
                public static function assertCairngormEventFired(... args):void {
                        var userMessage:String = '';
                        if (args[0] is String) userMessage = args.shift();

                        var eventSource:Object = CairngormEventDispatcher.getInstance();

                        var eventClass:Class = args.shift();
                        var eventName:String = new eventClass().type;

                        var callback:Function = args.shift();
                        var conditions:Object = args.shift();

                        assertEventFired(userMessage, eventSource, eventName, callback, conditions);
                }

                /**
                 * Takes the following arguments:
                 *
                 *    1 - Optional message to display if the event is fired
                 *    2 - Event Class that should not be fired
                 *    3 - Callback that should not fire an event
                 */
                public static function assertCairngormEventNotFired(... args):void {
                        var userMessage:String = '';
                        if (args[0] is String) userMessage = args.shift();

                        var eventSource:Object = CairngormEventDispatcher.getInstance();

                        var eventClass:Class = args.shift();
                        var eventName:String = new eventClass().type;

                        var callback:Function = args.shift();

                        assertEventNotFired(userMessage, eventSource, eventName, callback);
                }

                public static function assertNotEquals(...args):void {
                        var userMessage:String = '';
                        if (args.length == 3) userMessage = args.shift();

                        var expected:Object = args.shift();
                        var actual:Object = args.shift();

                        if (expected == actual) {
                                failWithUserMessage(userMessage, "Expected " + ObjectUtil.toString(expected) + " to be != to " + ObjectUtil.toString(actual));
                        }
                }

                /**
                 * Takes the following arguments:
                 *
                 *    1 - Optional: Message to display if assertion fails
                 *    2 - Object where binding takes place
                 *    3 - Attribute or Method name that is being tested
                 *        4 - Optional: Event that triggers binding.  If no event is passed in,
                 *        a new PropertyChangeEvent is fired on the Object, using property
                 *                passed in.
                 *
                 *    Note: When testing a variable's bindability, you are limited to testing
                 *    for the default trigger event: PropertyChangeEvent
                 *
                 **/
                public static function assertBindable(... args):void {
                        var userMessage:String = '';
                        var firstArg:Object = args.shift();
                        var eventSource:Object;

                        if (firstArg is String) {
                                userMessage = String(firstArg);
                                eventSource =  args.shift();
                        } else {
                                eventSource = firstArg;
                        }


                        var bindableAttributeOrGetter:String = args.shift();
                        var eventTriggeringBinding:String = args.shift();

                        if (!ChangeWatcher.canWatch(eventSource, bindableAttributeOrGetter))
                                throw new IllegalOperationError("You cannot watch " + eventSource + " for changes to " + bindableAttributeOrGetter);

                        var bindingTriggered:Boolean = false;

                        ChangeWatcher.watch(eventSource, bindableAttributeOrGetter, function(event:Event):void {
                                bindingTriggered = true;
                        });

                        /**
                         *  If the eventTriggeringBinding is null, it means that the user wants to test the
                         *  default Bindable event
                         **/
                        if (eventTriggeringBinding == null) {
                        eventSource.dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, false, false,
                                                                                PropertyChangeEventKind.UPDATE, bindableAttributeOrGetter));
                    } else {
                                eventSource.dispatchEvent(new Event(eventTriggeringBinding));
                    }

                        if (!bindingTriggered) failWithUserMessage(userMessage, "Expected " + eventSource + "'s " +
                                                                                                                                        bindableAttributeOrGetter + " to trigger bindings when the " +
                                                                                                                                        eventTriggeringBinding + " is fired.");
                }

                private static function failWithUserMessage( userMessage:String, failMessage:String ):void {
                        if (userMessage.length > 0)
                                userMessage = userMessage + " - ";

                        throw new AssertionFailedError(userMessage + failMessage);
                }

                private static function assertEventConditions(event:Event, conditions:Object):void {
                        for (var key:String in conditions) {
                                if (!event.hasOwnProperty(key)) throw new AssertionFailedError("The event does not have a property named: " + key);
                                assertEquals("The event's " + key + " value, " + event[key] + ", does not equal the expectation,  " + conditions[key],
                                                                0, ObjectUtil.compare(conditions[key], event[key]));
                        }
                }
        }
}