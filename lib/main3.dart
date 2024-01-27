// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

/// Flutter code sample for [AppBar].
///
/// ================== CLASS and GLOBAL SIGNALS =====================
class Person {
  String name;
  String lastName;
  Person({
    this.name = 'John',
    this.lastName = 'Doe',
  });

  Person copyWith({
    String? name,
    String? lastName,
  }) {
    return Person(
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'lastName': lastName,
    };
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      name: (map['name'] ?? '') as String,
      lastName: (map['lastName'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Person.fromJson(String source) =>
      Person.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Person(name: $name, lastName: $lastName)';

  @override
  bool operator ==(covariant Person other) {
    if (identical(this, other)) return true;

    return other.name == name && other.lastName == lastName;
  }

  @override
  int get hashCode => name.hashCode ^ lastName.hashCode;
}

/// SCOPE:
// We are using globals signals in this example, so this is logical to place here
// variables that relate to the state of the AppBarExample widget.
// The state persists for the duration of the app. When the app ends
// the state variables used by signal will be released.

// This below counterSignal is for the counter. Every time you click on the bell,
// the snack bar will show a message indicating the count
// (how many times you have clicked it), and the name that was changed.

Signal<int> counterSignal = signal(0);

// This personSignal takes an object for tracking. It will NOT update if you
// update the name or lastName because they are components and the pointer
// to the object has not changed.
Signal personSignal = signal<Person>(Person());

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBar Demo'),
        actions: const <Widget>[
          BellWidget(),
          NextPageButton(),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Play around clicking and navigating back and forth. Pay attention to what updates and what doesn\'t',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32.0),
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
    );
  }
}

class NextPageButton extends StatelessWidget {
  const NextPageButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.navigate_next),
      tooltip: 'Go to the next page',
      onPressed: () {
        Navigator.push(context, MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return const NextPage();
          },
        ));
      },
    );
  }
}

class BellWidget extends StatelessWidget {
  const BellWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    setName(String name) {
      // If person is not global we can read it
      Person newPerson = personSignal.value;
      // Update the name only giving a new object
      newPerson = newPerson.copyWith(name: name);
      // update the signal with the new object
      personSignal.value = newPerson;
    }

    return IconButton(
      icon: const Icon(Icons.add_alert),
      tooltip: 'Show Snackbar',
      onPressed: () {
        setName('Mike');
        counterSignal.value++;
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('This is a snackbar: $counterSignal  Mike')));
      },
    );
  }
}

class NextPage extends StatelessWidget {
  const NextPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Next page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('This is the next page', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 32.0),
            const Text(
              'Notice when not-watched text updates.\nThis will help you understant when to use Watch',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            // Because this is read when the user navigates to this page
            // this text shows the updated name. But since it is not watched,
            // if the name changed in the background it would not display an update.
            Text('Not watched: ${fullNameSignal.value}',
                style: const TextStyle(fontSize: 18.0)),
            Watch(
              (context) => Text('Watched: ${fullNameSignal.value}',
                  style: const TextStyle(fontSize: 18.0)),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Change the name
          final person = Person(name: 'Hanna', lastName: 'Bannana');
          personSignal.value = person;
        },
        child: const Icon(Icons.person),
      ),
    );
  }
}
