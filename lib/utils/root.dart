import 'package:flutter/material.dart';
import 'package:isilahtitiktitik/model/user.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:isilahtitiktitik/view/page-home/widgets/home_widget.dart';
import 'package:isilahtitiktitik/view/page-intro/page_onboarding.dart';
import 'package:isilahtitiktitik/view/widgets/delete_account_state_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  RootState createState() => RootState();
}

class RootState extends State<Root> {
  bool isHomeLoading = true;
  bool goingHome = true;
  User? currentUser;

  Widget buildProgressIndicator() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final BaseAuth provider = Provider.of<Auth>(context, listen: false);
    if (!isHomeLoading) {
      if (goingHome) {
        if (currentUser != null) {
          return provider.currentUser!.data!.user!.status == null
              ? const HomeWidget()
              : provider.currentUser!.data!.user!.status! < 1
                  ? const DeleteAccountStateWidget(navigasi: false)
                  : const HomeWidget();
        } else {
          return const OnBoardingPage();
        }
      } else {
        return const OnBoardingPage();
      }
    }
    provider.isLoggedIn().then((value) {
      if (value!) {
        provider.loadUserAuth().then((user) {
          setState(() {
            currentUser = user;
          });
          if (currentUser != null) {
            _writeUserData();
          }
          setState(() {
            isHomeLoading = false;
            goingHome = value;
          });
        });
      } else {
        provider.isOnboardVisited().then((val) => setState(() {
              goingHome = val!;
              isHomeLoading = false;
            }));
      }
    });
    return buildProgressIndicator();
  }

  void _writeUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("visited", false);
    prefs.setString("token", currentUser!.data!.token!);
    prefs.setInt("id", currentUser!.data!.user!.id!);
    prefs.setString("refferalCode", currentUser!.data!.user!.refferalCode!);
    prefs.setString("username", currentUser!.data!.user!.username!);
    prefs.setString("email", currentUser!.data!.user!.email!);
    prefs.setInt("point", currentUser!.data!.user!.point!);
    prefs.setInt("rankPoint", currentUser!.data!.user!.rankPoint!);
    prefs.setInt("rankPointStatus", currentUser!.data!.user!.rankPointStatus!);
    prefs.setInt("experience", currentUser!.data!.user!.experience!);
    prefs.setInt("rankExperience", currentUser!.data!.user!.rankExperience!);
    prefs.setInt(
        "rankExperienceStatus", currentUser!.data!.user!.rankExperienceStatus!);
    prefs.setInt("experienceFrom", currentUser!.data!.user!.experienceFrom!);
    prefs.setInt("experienceTo", currentUser!.data!.user!.experienceTo!);
    prefs.setInt(
        "experiencePercentage", currentUser!.data!.user!.experiencePercentage!);
    prefs.setString("level", currentUser!.data!.user!.level!);
    prefs.setString("levelLogo", currentUser!.data!.user!.levelLogo!);
    prefs.setString("photo", currentUser!.data!.user!.photo!);
    prefs.setString("fullName", currentUser!.data!.user!.fullName!);
    prefs.setString("birthdate", currentUser!.data!.user!.birthdate!);
    prefs.setString("gender", currentUser!.data!.user!.gender!);
    prefs.setString("phone", currentUser!.data!.user!.phone!);
    prefs.setString("address", currentUser!.data!.user!.address!);
    prefs.setInt("urbanVillageId", currentUser!.data!.user!.urbanVillageId!);
    prefs.setString("urbanVillage", currentUser!.data!.user!.urbanVillage!);
    prefs.setInt("subdistrictId", currentUser!.data!.user!.subdistrictId!);
    prefs.setString("subdistrict", currentUser!.data!.user!.subdistrict!);
    prefs.setInt("regencyId", currentUser!.data!.user!.regencyId!);
    prefs.setString("regency", currentUser!.data!.user!.regency!);
    prefs.setInt("provinceId", currentUser!.data!.user!.provinceId!);
    prefs.setString("province", currentUser!.data!.user!.province!);
    prefs.setString("postalCode", currentUser!.data!.user!.postalCode!);
    prefs.setInt("professionId", currentUser!.data!.user!.professionId!);
    prefs.setString("profession", currentUser!.data!.user!.profession!);
    prefs.setString("bio", currentUser!.data!.user!.bio!);
    prefs.setString("socmedFb", currentUser!.data!.user!.socmedFb!);
    prefs.setString("socmedIg", currentUser!.data!.user!.socmedIg!);
    prefs.setString("socmedTw", currentUser!.data!.user!.socmedTw!);
    prefs.setInt(
        "friendshipRequest", currentUser!.data!.user!.friendshipRequest!);
    prefs.setInt("googleLink", currentUser!.data!.user!.googleLink!);
    prefs.setInt("appleLink", currentUser!.data!.user!.appleLink!);
    prefs.setInt(
        "shipmentDefaultId", currentUser!.data!.user!.shipmentDefaultId!);
    prefs.setInt(
        "notificationUnread", currentUser!.data!.user!.notificationUnread!);
  }
}
