import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:isilahtitiktitik/bloc/faq-bloc/faq_bloc.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/model/faq.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/content_view.dart';
import 'package:isilahtitiktitik/view/widgets/loading_widget.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class FAQWidget extends StatefulWidget {
  const FAQWidget({super.key});

  @override
  State<FAQWidget> createState() => _FAQWidgetState();
}

class _FAQWidgetState extends State<FAQWidget> {
  final FaqBloc faqBloc = FaqBloc();
  int pageNumber = 1;
  int? _limit = 1;
  int? _currentLenght;
  List<Data> _listDataFaq = [];
  final ScrollController _scFaq = ScrollController();

  @override
  void initState() {
    _loadMoreFaq(true);
    _scFaq.addListener(() {
      if (_scFaq.position.pixels == _scFaq.position.maxScrollExtent) {
        if (_currentLenght != null) {
          if (_currentLenght! < _limit!) {
            pageNumber = pageNumber + 1;
            _loadMoreFaq(false);
          }
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scFaq.dispose();
    faqBloc.close();
  }

  Future<void> _loadMoreFaq(bool statusLoad) async {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    faqBloc.add(GetFaq(http: chttp, statusLoad: statusLoad, page: pageNumber));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => faqBloc,
      child: BlocBuilder<FaqBloc, FaqState>(
        builder: (context, state) {
          if (state is FaqInitial) {
            return const LoadingWidget();
          } else if (state is FaqLoading) {
            return const LoadingWidget();
          } else if (state is FaqLoaded || state is FaqMoreLoading) {
            if (state is FaqLoaded) {
              _listDataFaq = state.list;
              _currentLenght = state.count;
              _limit = state.limit;
            }
            return _buildList();
          } else if (state is FaqError) {
            Logger().d("Error FAQ : ${state.message}");
            return Container();
          }

          return Container();
        },
      ),
    );
  }

  Widget _buildList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._listDataFaq
              .map(
                (data) => Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: ExpandablePanel(
                    theme: ExpandableThemeData(
                        inkWellBorderRadius: BorderRadius.circular(10),
                        iconPadding: const EdgeInsets.all(16),
                        headerAlignment: ExpandablePanelHeaderAlignment.center),
                    header: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        data.title!,
                        style: const TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 14,
                            color: ColorPalette.neutral_90,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    collapsed: const SizedBox(height: 0),
                    expanded: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Html(
                        data: data.content!,
                        style: {
                          'p': Style(
                              color: ColorPalette.neutral_80,
                              textAlign: TextAlign.justify,
                              lineHeight: LineHeight.number(1.2))
                        },
                        onLinkTap: (url, _, __, ___) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyWebview(
                                        url: url,
                                        title: "FAQ",
                                      )));
                        },
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
