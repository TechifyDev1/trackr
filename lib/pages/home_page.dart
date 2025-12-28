import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/widgets/molecules/custom_list_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.darkBackgroundGray,
      navigationBar: CupertinoNavigationBar(
        leading: const Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("assets/images/qudus.png"),
            ),
            SizedBox(width: 10),
            Text("Qudus Yusuf"),
          ],
        ),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                AuthService.instance.logout();
              },
              icon: Icon(CupertinoIcons.settings, color: CupertinoColors.white),
              style: IconButton.styleFrom(
                backgroundColor: CupertinoColors.darkBackgroundGray,
              ),
              iconSize: 16,
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(CupertinoIcons.bell, color: CupertinoColors.white),
              style: IconButton.styleFrom(
                backgroundColor: CupertinoColors.darkBackgroundGray,
              ),
              iconSize: 16,
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: .start,
                  children: const [
                    Text(
                      "Available on Card",
                      style: TextStyle(
                        color: Color.fromARGB(255, 197, 197, 197),
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "\$13,528.31",
                      style: TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 28,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        const Text(
                          "Transfer Limit",
                          style: TextStyle(fontWeight: .w500),
                        ),
                        // SizedBox(width: 10),
                        const Text(
                          "\$12,000",
                          style: TextStyle(fontWeight: .w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        SizedBox(
                          height: 2,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Container(color: CupertinoColors.white),
                        ),
                        SizedBox(
                          height: 2,
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Container(color: Colors.white30),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Spent \$1,244.65",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 197, 197, 197),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: .circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: .center,
                          children: [
                            Text(
                              "Pay",
                              style: TextStyle(
                                color: CupertinoColors.darkBackgroundGray,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              CupertinoIcons.money_dollar_circle_fill,
                              color: CupertinoColors.darkBackgroundGray,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: .circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: .center,
                          children: [
                            Text(
                              "Deposit",
                              style: TextStyle(
                                color: CupertinoColors.darkBackgroundGray,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              CupertinoIcons.plus_circle_fill,
                              color: CupertinoColors.darkBackgroundGray,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: CupertinoColors.darkBackgroundGray,
                ),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Align(
                      alignment: .center,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromARGB(255, 131, 128, 128),
                        ),
                        child: SizedBox(height: 5, width: 25),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        const Text("Operations"),
                        TextButton(
                          onPressed: () {},
                          child: const Text("View all"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text("Today", style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 5),
                    CustomListTile(
                      title: "AT & T",
                      subtitle: "Unlimited Family plan",
                      imgPath: "assets/images/at_t.png",
                      price: "39.99",
                    ),
                    const SizedBox(height: 5),
                    CustomListTile(
                      title: "CC subscription",
                      subtitle: "Unlimited Family plan",
                      imgPath: "assets/images/cc.png",
                      price: "39.99",
                    ),
                    const SizedBox(height: 5),
                    const Text("Yesterday", style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 5),
                    CustomListTile(
                      title: "Bizzard entertainment",
                      subtitle: "6 month subscription",
                      imgPath: "assets/images/at_t.png",
                      price: "39.99",
                    ),
                    const SizedBox(height: 5),
                    CustomListTile(
                      title: "Netflix",
                      subtitle: "Basic plan",
                      imgPath: "assets/images/netflix.jpg",
                      price: "39.99",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
