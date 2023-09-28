import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/bloc/referral-user-bloc/referral_user_bloc.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:provider/provider.dart';

class UserReferralWidget extends StatefulWidget {
  const UserReferralWidget({Key? key}) : super(key: key);

  @override
  State<UserReferralWidget> createState() => _UserReferralWidgetState();
}

class _UserReferralWidgetState extends State<UserReferralWidget> {
  final ReferralUserBloc _referralUserBloc = ReferralUserBloc();
  int pageNumber = 1;
  int? totalReferral = 0;

  Future<void> _loadMoreDataReferral(bool statusLoad) async {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    _referralUserBloc.add(
        GetReferralUser(http: chttp, statusLoad: statusLoad, page: pageNumber));
  }

  @override
  void initState() {
    _loadMoreDataReferral(true);
    super.initState();
  }

  @override
  void dispose() {
    _referralUserBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _referralUserBloc,
      child: BlocBuilder<ReferralUserBloc, ReferralUserState>(
        builder: (context, state) {
          if (state is ReferralUserInitial) {
            return Container();
          } else if (state is ReferralUserLoading) {
            return Container();
          } else if (state is ReferralUserLoaded ||
              state is ReferralUserMoreLoading) {
            if (state is ReferralUserLoaded) {
              totalReferral = state.totalReferral;
            }
            return _buildView();
          } else if (state is ReferralUserError) {
            return Container();
          }

          return Container();
        },
      ),
    );
  }

  Widget _buildView() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/referral');
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.12,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF252C6F),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: ColorPalette.mainColor, shape: BoxShape.circle),
              child: Center(
                child: Image.asset(
                  'assets/icon/ic_home_referral.png',
                  width: 18,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Expanded(
              child: Text(
                'Jumlah Referral',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              "$totalReferral",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 15,
            )
          ],
        ),
      ),
    );
  }
}
