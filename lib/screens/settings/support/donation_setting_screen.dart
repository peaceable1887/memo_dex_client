import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/bottom_navigation_screen.dart';
import '../../../widgets/text/headlines/headline_large.dart';
import '../../../widgets/header/top_navigation_bar.dart';

class DonationSettingScreen extends StatefulWidget
{
  const DonationSettingScreen({super.key});

  @override
  State<DonationSettingScreen> createState() => _DonationSettingScreenState();
}

class _DonationSettingScreenState extends State<DonationSettingScreen>
{
  @override
  void initState()
  {
    super.initState();
  }
  @override
  void dispose()
  {
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.deepOrange[100],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            leading: Padding(
              padding: const EdgeInsets.fromLTRB(0,5,0,0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  WillPopScope(
                    onWillPop: () async => false,
                    child: Flexible(
                      child: TopNavigationBar(
                        btnText: "Settings",
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BottomNavigationScreen(index: 2),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            expandedHeight: 350,
            backgroundColor: Colors.blueAccent,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                  color: Colors.red,
              ),
              titlePadding: EdgeInsets.only(bottom: 5),
              centerTitle: true,
              title: const HeadlineLarge(text: "Donation"),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.deepOrange,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.deepOrange,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.deepOrange,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
