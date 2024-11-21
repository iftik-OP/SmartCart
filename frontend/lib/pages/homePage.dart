import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:provider/provider.dart';
import 'package:smart_cart/classes/product.dart';
import 'package:smart_cart/consts.dart';
import 'package:smart_cart/providers/productProvider.dart';
import 'package:smart_cart/widgets/productCard.dart';
import 'package:smart_cart/widgets/productGrid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  String msg = '';

  List<bool> toggleSelection = [false, true];

  @override
  void initState() {
    // TODO: implement initState
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      final ndef = Ndef.from(tag);
      setState(() {
        msg = 'NFC detected';
      });
      if (ndef != null && ndef.cachedMessage != null) {
        String tempRecord = "";
        for (var record in ndef.cachedMessage!.records) {
          tempRecord =
              "$tempRecord ${String.fromCharCodes(record.payload.sublist(record.payload[0] + 1))}";
        }

        setState(() {
          msg = tempRecord;
        });
      } else {
        // Show a snackbar for example
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _searchController = TextEditingController();
    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;

    // final allProducts = Provider.of<ProductProvider>(context).allProducts;

    @override
    void dispose() {
      NfcManager.instance.stopSession();
      super.dispose();
    }

    Product dummyProduct = Product(
        category: '',
        items: 0,
        id: '123',
        title: 'Macbook Pro',
        price: 99999,
        description: 'laptop',
        imageUrl: 'imageUrl');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryYellow,
        centerTitle: true,
        leading: const Icon(Icons.menu_rounded),
        title: SafeArea(
          child: Image.asset(
            'assets/images/Logos/Square logo.png',
            height: 100,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: h * 0.15,
            decoration: BoxDecoration(
              color: primaryYellow,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(21),
                bottomLeft: Radius.circular(21),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 50,
                    width: double.infinity,
                    child: SearchBar(
                      controller: _searchController,
                      hintText: 'MacBook Pro',
                      hintStyle: const MaterialStatePropertyAll(
                        TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      trailing: const [
                        Icon(Icons.search),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(Icons.mic_rounded),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Text(
                          'Sector 47, Gurgaon',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Icon(
                          Icons.location_on,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ToggleButtons(
              constraints: BoxConstraints(minWidth: w / 2 - 16, minHeight: 40),
              isSelected: toggleSelection,
              selectedColor: Colors.white,
              color: Colors.black,
              fillColor: primaryYellow,
              splashColor: primaryYellow.withOpacity(0.1),
              highlightColor: Colors.orange,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
              renderBorder: true,
              borderWidth: 1.5,
              borderRadius: BorderRadius.circular(10),
              selectedBorderColor: primaryYellow,
              disabledBorderColor: primaryYellow,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('SmartGo', style: TextStyle(fontSize: 14)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('Store', style: TextStyle(fontSize: 14)),
                ),
              ],
              onPressed: (int newIndex) {
                setState(() {
                  for (int index = 0; index < toggleSelection.length; index++) {
                    if (index == newIndex) {
                      toggleSelection[index] = true;
                    } else {
                      toggleSelection[index] = false;
                    }
                  }
                });
              }),
          toggleSelection[0]
              ? Center(
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        msg = 'Reading NFC';
                      });
                      bool isAvailable =
                          await NfcManager.instance.isAvailable();
                      if (isAvailable) {
                        NfcManager.instance.startSession(
                            onDiscovered: (NfcTag tag) async {
                          final data = tag.data;
                          setState(() {
                            msg = 'NFC detected';
                          });
                          print(data);
                          NfcManager.instance.stopSession();
                        });
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        Image.asset(
                          'assets/images/nfc.png',
                          height: 200,
                        ),
                        Text(
                          'Please bring your product close to your device.',
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          msg,
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : ProductGrid(),
        ],
      ),
    );
  }
}
