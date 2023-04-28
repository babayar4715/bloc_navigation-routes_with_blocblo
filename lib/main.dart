import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => MyBloc(),
      child: MyApp(),
    ),
  );
}

@immutable
abstract class MyEvent {}

class EventA extends MyEvent {}

class EventB extends MyEvent {}

class EventC extends MyEvent {}

@immutable
abstract class MyState {}

class StateA extends MyState {}

class StateB extends MyState {}

class StateC extends MyState {}

class MyBloc extends Bloc<MyEvent, MyState> {
  MyBloc() : super(StateA()) {
    on<EventA>((event, emit) => emit(StateA()));
    on<EventB>((event, emit) => emit(StateB()));
    on<EventC>((event, emit) => emit(StateC()));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => PageA(),
        '/pageB': (context) => PageB(),
        '/pageC': (context) => PageC(),
      },
      initialRoute: '/',
    );
  }
}

class PageA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<MyBloc, MyState>(
      listener: (context, state) {
        if (state is StateB) {
          Navigator.of(context).pushNamed('/pageB');
        } else if (state is StateC) {
          Navigator.of(context).pushNamed('/pageC');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Page A'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text('Go to PageB'),
                onPressed: () {
                  print('it works A=>B');

                  context.read<MyBloc>().add(EventB());
                },
              ),
              ElevatedButton(
                child: const Text('Go to PageC'),
                onPressed: () {
                  print('it works A=>C');
                  context.read<MyBloc>().add(EventC());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PageB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<MyBloc, MyState>(
      listener: (context, state) {
        if (state is StateA) {
          Navigator.of(context).pushNamed('/');
        } else if (state is StateC) {
          Navigator.of(context).pushNamed('/pageC');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Page B'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text('Go to page A'),
                onPressed: () {
                  print('it works B=>A');

                  context.read<MyBloc>().add(EventA());
                },
              ),
              ElevatedButton(
                child: const Text('Go to page C'),
                onPressed: () {
                  print('it works B=>C');

                  context.read<MyBloc>().add(EventC());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PageC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<MyBloc, MyState>(
      listener: (context, state) {
        if (state is StateA) {
          Navigator.of(context).pushNamed('/');
        } else if (state is StateB) {
          Navigator.of(context).pushNamed('/pageB');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Page C'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text('Go To Page B'),
                onPressed: () {
                  print('it works C=>B');

                  context.read<MyBloc>().add(EventB());
                },
              ),
              ElevatedButton(
                child: const Text('Go To Page A'),
                onPressed: () {
                  print('it works C=>A');

                  context.read<MyBloc>().add(EventA());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
