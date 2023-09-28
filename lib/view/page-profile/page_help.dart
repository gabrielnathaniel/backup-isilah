import 'package:flutter/material.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/view/page-profile/widgets/faq_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  void _launchWhatsapp() async {
    final Uri url = Uri.parse('http://wa.me/6285771400568');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  void _launchInstagram() async {
    final Uri url = Uri.parse('https://www.instagram.com/isilahid/');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).viewPadding.top;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          flexibleSpace: Image(
            image: const AssetImage('assets/image/img_background_appbar.png'),
            fit: BoxFit.cover,
            height: height + kToolbarHeight,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleSpacing: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Pusat Bantuan',
            style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: bodyMedium,
                color: Colors.white,
                fontWeight: FontWeight.w600),
          ),
          bottom: const TabBar(
              indicatorColor: ColorPalette.mainColor,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 3,
              labelPadding: EdgeInsets.symmetric(horizontal: 20),
              labelColor: Color(0xFFEF5696),
              labelStyle: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: bodyMedium,
                  color: Color(0xFFEF5696),
                  fontWeight: FontWeight.w500),
              unselectedLabelColor: ColorPalette.colorTextTabDisable,
              unselectedLabelStyle: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: bodyMedium,
                  fontWeight: FontWeight.w500),
              tabs: [
                Tab(
                  text: 'FAQ',
                ),
                Tab(
                  text: 'Hubungi Kami',
                ),
              ]),
        ),
        body: Column(
          children: [
            const Divider(
              thickness: 1,
              color: Color(0xFFE0E0E0),
            ),
            Expanded(
                child:
                    TabBarView(children: [const FAQWidget(), _buildCallMe()])),
          ],
        ),
      ),
    );
  }

  Widget _buildCallMe() {
    return Column(
      children: [
        Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () {
                String encodeQueryParameters(Map<String, String> params) {
                  return params.entries
                      .map((e) =>
                          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                      .join('&');
                }

                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: 'tolongmas@isilah.com',
                  query: encodeQueryParameters(<String, String>{'subject': ''}),
                );

                launchUrl(emailLaunchUri);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icon/ic_help_email.png',
                            width: 24,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email',
                                style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: bodyLarge,
                                    color: ColorPalette.neutral_90,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Email ke contact@isilah.id',
                                style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: bodySmall,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: ColorPalette.neutral_90,
                      size: 15,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () {
                _launchWhatsapp();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icon/ic_help_whatsapp.png',
                            width: 22,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'WhatsApp',
                                style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: bodyLarge,
                                    color: ColorPalette.neutral_90,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'WhatsApp kami ke +6285771400568',
                                style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: bodySmall,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: ColorPalette.neutral_90,
                      size: 15,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () {
                _launchInstagram();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icon/ic_help_instagram.png',
                            width: 22,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Instagram',
                                style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: bodyLarge,
                                    color: ColorPalette.neutral_90,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Hubungi kami di instagram @isilah.id',
                                style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: bodySmall,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: ColorPalette.neutral_90,
                      size: 15,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
