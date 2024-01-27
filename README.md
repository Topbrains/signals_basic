# Signals Basic

Here we have a few examples on how to use Signals as a state management tool.

So far in this examples, we are only using one function from the signals library (signal). We also use one widget from that library: Watch().

A signal is a container for a value that can change over time. You can read a signal’s value or subscribe to value updates by accessing its ".value"  property.

You control the life of that container by placing it in the correct location for your need:

Like with all variables, functions or classes, the scope is determined by the place where you create the signal:

| Location     | Release time                                |
|--------------|---------------------------------------------|
| function    | Released when the function ends.            |
| Class        | Released when the class object is destroyed.|
| global    | Released when the program ends.             |

## main.dart

Here we have a simple class: Person that has name, and lastName as fields, and inside the application, we create a Signal for the person class called personSignal. Later we will update the name of the person. We also create a fullName, computed signal, and a trivial counterSignal to be used by the application (when you click the bell).

There are comments inside the code, that emphasizes what's happening at each place.

## main2.dart

 In main2.dart the most important thing is that we moved most signals to a global location so that when we navigate to the second page, we have access to the signals and we can display some of the same information.  This is fundamental in most applications. Pay attention to which items are updated and which ones are not.

## main3.dart

In main3.dart we have a full blown data class for Person this time with default values also.

This allows us to eliminate person from the globals and still manipulate and update this object (data = state) using signals. This is more similar to a business application.

We have also added a button on the second page that changes the name so that we can better observe who gets updated when.

A little refactoring was added to combat Flutter's crazy indentation and to improve readability.
