// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: lines_longer_than_80_chars, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcd/counter/counter.dart';
import 'package:mcd/counter/cubit/counter_state.dart';
import 'package:mcd/l10n/l10n.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});
  // Key incrementBotKey = Key('incrementBotkey');

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider(
      create: (_) => CounterCubit(),
      child: BlocConsumer<CounterCubit, CounterState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.counterAppBarTitle)),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const CounterText(),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CounterTab(orderStatus: OrderStatus.pending),
                      CounterTab(orderStatus: OrderStatus.complete)
                    ],
                  ),
                ),
                SizedBox(height: 10,)
              ],
            ),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton.extended(
                  onPressed: () =>
                      context.read<CounterCubit>().createNormalOrder(),
                  label: const Text('New Normal Order'),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.extended(
                  onPressed: () =>
                      context.read<CounterCubit>().createVIPOrder(),
                  label: const Text('New VIP Order'),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.extended(
                  onPressed: () => context.read<CounterCubit>().incrementBot(),
                  icon: const Icon(Icons.add),
                  label: const Text(' Bot'),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.extended(
                  onPressed: () => context.read<CounterCubit>().decrementBot(),
                  icon: const Icon(Icons.remove),
                  label: const Text(' Bot'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CounterText extends StatelessWidget {
  const CounterText({super.key});

  @override
  Widget build(BuildContext context) {
    final count = context.select((CounterCubit cubit) => cubit.bots.length);
    return Text('Number of Bot: $count');
  }
}

class CounterTab extends StatelessWidget {
  const CounterTab({super.key, required this.orderStatus});

  final OrderStatus orderStatus;

  @override
  Widget build(BuildContext context) {
    final order = context
        .select((CounterCubit cubit) => cubit.orders)
        .where(
          (element) => orderStatus == OrderStatus.complete
              ? element.orderStatus == orderStatus
              : element.orderStatus != OrderStatus.complete,
        )
        .toList();
    return Container(
      width: 300,
      decoration: BoxDecoration(
        // color: Colors.blue,
        border: Border.all(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(orderStatus.name.toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              itemCount: order.length,
              controller: ScrollController(),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    'Order #${order[index].id} ${order[index].orderStatus.name}',
                  ),
                  subtitle: Text(order[index].orderType.name),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
