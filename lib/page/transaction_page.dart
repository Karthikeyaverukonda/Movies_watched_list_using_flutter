import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_database_example/boxes.dart';
import 'package:hive_database_example/model/transaction.dart';
import 'package:hive_database_example/widget/transaction_dialog.dart';


class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List _namesugg = [' The Matrix',' Pacific Rim',' Lord of the Rings',' Thor: Ragnarok',' Gravity','Once Upon a Time in Hollywood','Titanic','The Sixth Sense','Inception','Full Metal Jacket '];
  List _direcsugg = ['THE WACHOWSKIS','GUILLERMO DEL TORO','PETER JACKSON','TAIKA WAITITI','ALFONSO CUARÒN','QUENTIN TARANTINO','JAMES CAMERON','M. NIGHT SHYAMALAN','CHRISTOPHER NOLAN','STANLEY KUBRICK'];
  int tc=0;//total transactions count
  int p=0; //user added transactions count
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Movies Watched By User',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          centerTitle: true,
        ),
        body: ValueListenableBuilder<Box<Transaction>>(
          valueListenable: Boxes.getTransactions().listenable(),
          builder: (context, box, _) {
            final transactions = box.values.toList().cast<Transaction>();
            return buildContent(transactions);
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => TransactionDialog(
              onClickedDone: addTransaction,
            ),
          ),
        ),
      );



  Widget buildContent(List<Transaction> transactions) {
      //print(transactions.length);
      //print(tc);
      return Column(
        children: [
          SizedBox(height: 24),
          Text(
            'Movies List',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              //itemCount: transactions.length,
              itemBuilder: (BuildContext context, int index) {
                if (index>=transactions.length || transactions.length==0)
                  {
                    //print('index ');

                    for(var i = 0 ; i <10; i++)
                    {
                      initialTransaction(_namesugg[i], _direcsugg[i]);
                    }

                  }
                final transaction = transactions[index];
                return buildTransaction(context, transaction);
              },
            ),
          ),
        ],
      );

  }




  Widget buildTransaction(
    BuildContext context,
    Transaction transaction,
  ) {


    return Card(
      color: Colors.white,
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text('Movie : '+
          transaction.name,
          maxLines: 2,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),

        trailing: Text('Director :'+
          transaction.director,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        children: [
          buildButtons(context, transaction),
        ],
      ),
    );
  }

  Widget buildButtons(BuildContext context, Transaction transaction) => Row(
        children: [
          Expanded(
            child: TextButton.icon(
              label: Text('Edit',style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold)),
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TransactionDialog(
                    transaction: transaction,
                    onClickedDone: (name, director) =>
                        editTransaction(transaction, name, director),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: TextButton.icon(
              label: Text('Delete',style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold)),
              icon: Icon(Icons.delete),
              onPressed: () => deleteTransaction(transaction),
            ),
          )
        ],
      );


  Future initialTransaction(String name, String director) async {
    final transaction = Transaction()
      ..name = name
      ..director = director;
    final box = Boxes.getTransactions();
    box.add(transaction);
    tc=tc+1;
  }




  Future addTransaction(String name, String director) async {
    final transaction = Transaction()
      ..name = name
      ..director = director;

    List t1=[name];
    List t2=[director];
    _namesugg=t1+_namesugg;
    _direcsugg=t2+_direcsugg;
    final box = Boxes.getTransactions();
    box.putAt(p, transaction);
    p=p+1;
    tc=tc+1;


    //box.put(0, transaction);
    // final mybox = Boxes.getTransactions();
    // final myTransaction = mybox.get('key');
    // mybox.values;
    // mybox.keys;
  }

  void editTransaction(
    Transaction transaction,
    String name,
    String director,
  ) {
    transaction.name = name;
    transaction.director = director;
    transaction.save();
  }

  void deleteTransaction(Transaction transaction) {
    tc=tc-1;
    transaction.delete();

  }
}
