import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

/// Flutter code sample for [AppBar].
class Person {
  String name;
  String lastName;
  Person({required this.name, required this.lastName});
}

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

class AppBarExample extends StatefulWidget {
  const AppBarExample({super.key});

  @override
  State<AppBarExample> createState() => _AppBarExampleState();
}

class _AppBarExampleState extends State<AppBarExample> {
  // Since this is the state class for the AppBarExample it is logical to place here
  // variables that relate to the state of the AppBarExample widget. This way, when we finish using this applet, the state variables used by signal will be released.

  // This signal is for the counter. Every time you click on the bell,
  // the snack bar will show a message indicating the count (how many times you have clicked it), and the name that was changed.
  Signal<int> counterSignal = signal(0);

  static Person person = Person(name: 'John', lastName: 'Doe');

  // This personSignal takes an object for tracking. It will NOT update if you
  // update the name or lastName because they are components and the pointer
  // to the object has not changed.
  static Signal personSignal = signal<Person>(person);

  // This is an example of a computed (compounded) signal: the result is a signal, and to create it we use
  // some component signals. This process forces a subscription to any signal used. 
  final fullName = computed(
      () => '${personSignal.value.name}, ${personSignal.value.lastName}');

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
                    body: const Center(
                      child: Text(
                        'This is the next page',
                        style: TextStyle(fontSize: 24),
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
            Text('Not watched: ${fullName.value}'),
            Watch((context) {
              return Text('Watched: ${fullName.value}');
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
