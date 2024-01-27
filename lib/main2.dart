import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

/// Flutter code sample for [AppBar].
///
/// ================== GLOBALS =====================
class Person {
  String name;
  String lastName;
  Person({required this.name, required this.lastName});
}

/// SCOPE
// We are using globals in this example, so this is logical to place here
// variables that relate to the state of the AppBarExample widget.
// The state persist for the duration of the app. When the app ends
// the state variables used by signal will be released.

// This signal is for the counter. Every time you click on the bell,
// the snack bar will show a message indicating the count (how many times you have clicked it), and the name that was changed.

Signal<int> counterSignal = signal(0);

Person person = Person(name: 'John', lastName: 'Doe');

// This personSignal takes an object for tracking. It will NOT update if you
// update the name or lastName because they are components and the pointer
// to the object has not changed.
Signal personSignal = signal<Person>(person);

// This is an example of a computed (compounded) signal: the result is a signal, and to create it we use
// some component signals. This process forces a subscription to any signal used.
final fullNameSignal = computed(
    () => '${personSignal.value.name}, ${personSignal.value.lastName}');

// =========================================

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppBarExample(),
    );
  }
}

class AppBarExample extends StatelessWidget {
  const AppBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    // final personSignal = signal(person);

    setName(String name) {
      final person = Person(name: name, lastName: 'Doe');
      personSignal.value = person;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBar Demo'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: () {
              setName('Mike');
              counterSignal.value++;
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('This is a snackbar: $counterSignal  Mike')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            tooltip: 'Go to the next page',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Next page'),
                    ),
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('This is the next page',
                              style: TextStyle(fontSize: 24)),
                          // Because this is read when the user navigates to this page
                          // this text shows the updated name. But since it is not watched,
                          // if the name changed in the background it would not display an update.
                          Text(fullNameSignal.value,
                              style: const TextStyle(fontSize: 24)),
                        ],
                      ),
                    ),
                  );
                },
              ));
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // This one is not watched and will not update
            Text('Not watched: ${fullNameSignal.value}'),
            Watch((context) {
              return Text('Watched: ${fullNameSignal.value}');
            }),
            const SizedBox(
              height: 16.0,
            ),
            Watch((context) {
              return Column(
                children: [
                  const Text('Below items are Watched'),
                  Text(personSignal.value.name),
                  Text('You clicked $counterSignal times'),
                ],
              );
            }),
          ],
        ),
      ),

      //  Watch((context) {
      //   return Text(fullName.value);
      // }),
    );
  }
}
