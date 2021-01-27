import 'package:facts_tdd/domain/usecases/get_random_fact.dart';
import 'package:facts_tdd/presentation/bloc/fact_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FactPage extends StatefulWidget {
  @override
  _FactPageState createState() => _FactPageState();
}

class _FactPageState extends State<FactPage> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BlocBuilder<FactBloc, FactState>(
              builder: (context, state) {
                print(state);
                if (state is FactEmpty) {
                  return Text('Start searching');
                } else if (state is FactLoading) {
                  return CircularProgressIndicator();
                } else if (state is FactLoaded) {
                  return Text(state.fact.trivia);
                }
                return Container(color: Colors.red);
              },
            ),
            TextField(controller: _controller),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      final bloc = BlocProvider.of<FactBloc>(context);
                      bloc.add(GetConcreteFactEvent(_controller.text.trim()));
                    },
                    child: Text('Get Concrete Fact')),
                ElevatedButton(
                  onPressed: () {
                    final bloc = BlocProvider.of<FactBloc>(context);
                    bloc.add(GetRandomFactEvent());
                  },
                  child: Text('Get Random Fact'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
