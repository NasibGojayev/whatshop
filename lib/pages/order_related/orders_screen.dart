import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../bloc_management/order_cubit.dart';



class MyOrdersPage extends StatefulWidget {


  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {

  @override
  void initState() {
    super.initState();

  }
  @override
  void dispose() {
    super.dispose();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'success':
        return Colors.green;
      case 'failed':
        return Colors.red;
      case 'çatdırılıb':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sifarişlərim')),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context,state) {
          if(state.isLoading){
            return const Center(child: CircularProgressIndicator());
          }
          if(state.error != null){
            return Center(child: Text(state.error!));
          }
          if(state.orderGroups.isEmpty){
            return const Center(child: Text('Sifariş tapılmadı'));
          }
          final orderGroups= state.orderGroups;
          return ListView.builder(
            itemCount: orderGroups.length,
            itemBuilder: (context, index) {
              final OrderGroupItem orderGroupItem = orderGroups[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: Icon(Icons.inventory),
                  title: Text('Sifarişin kodu : ${orderGroupItem.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Text("Satıcı: ${order.sellerId}"),
                      Text("Qiymət: ${orderGroupItem.totalPrice.toStringAsFixed(2)} ₼"),
                      Text(
                        "Status: ${orderGroupItem.paymentStatus=='success'?'Sifariş qəbul olunub':'Sifariş uğursuz oldu'}",
                        style: TextStyle(color: getStatusColor(orderGroupItem.paymentStatus)),
                      ),
                      Text("Tarix: ${DateFormat('dd.MM.yyyy').format(DateTime.now())}"),
                    ],
                  ),
                  trailing: TextButton(
                    child: const Text("Bax"),
                    onPressed: () {
                      context.push('/orderItems', extra: orderGroupItem.id);
                      //Navigator.pushNamed(context, "/orderDetails", arguments: order.id);
                    },
                  ),
                ),
              );
            },
          );
        }
      ),
    );
  }
}
