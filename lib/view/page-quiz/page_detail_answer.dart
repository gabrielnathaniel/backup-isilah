import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/bloc/quetions-view-bloc/quetions_view_bloc.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/model/quetions_view.dart';
import 'package:isilahtitiktitik/model/result_quiz.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/view/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class DetailAnswerPage extends StatefulWidget {
  final DetailResultQuiz? detailResultQuiz;
  const DetailAnswerPage({super.key, @required this.detailResultQuiz});

  @override
  State<DetailAnswerPage> createState() => _DetailAnswerPageState();
}

class _DetailAnswerPageState extends State<DetailAnswerPage> {
  QuetionsViewBloc quetionsViewBloc = QuetionsViewBloc();
  YoutubePlayerController? _youtubeController;

  @override
  void initState() {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    quetionsViewBloc.add(GetQuetionsView(
        http: chttp, questionId: widget.detailResultQuiz!.questionId));
    if (widget.detailResultQuiz!.questionTypeId == 2) {
      _youtubeController = YoutubePlayerController.fromVideoId(
        videoId: YoutubePlayerController.convertUrlToId(
                widget.detailResultQuiz!.video!)
            .toString(),
        autoPlay: true,
        params: const YoutubePlayerParams(
          showFullscreenButton: false,
          strictRelatedVideos: false,
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const Image(
          image: AssetImage('assets/image/img_background_appbar.png'),
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Detail Jawaban',
          style: TextStyle(
              fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: _buildQuetionsView(),
    );
  }

  Widget _buildQuetionsView() {
    return BlocProvider(
      create: (context) => quetionsViewBloc,
      child: BlocListener<QuetionsViewBloc, QuetionsViewState>(
        listener: (context, state) {},
        child: BlocBuilder<QuetionsViewBloc, QuetionsViewState>(
          builder: (context, state) {
            if (state is QuetionsViewInitial) {
              return const LoadingWidget();
            } else if (state is QuetionsViewLoading) {
              return const LoadingWidget();
            } else if (state is QuetionsViewLoaded) {
              return _buildView(context, state.quetionsViewModel!);
            } else if (state is QuetionsViewError) {
              return Container();
            }

            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildView(BuildContext context, QuetionsViewModel quetionsViewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        children: [
          widget.detailResultQuiz!.questionTypeId == 0 &&
                  widget.detailResultQuiz!.text == null
              ? Container()
              : Container(
                  margin: const EdgeInsets.only(top: 16, bottom: 16),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.27,
                  decoration: BoxDecoration(
                      color: ColorPalette.colorListRanks,
                      borderRadius: BorderRadius.circular(10)),
                  child: widget.detailResultQuiz!.questionTypeId == 0
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                widget.detailResultQuiz!.text ??
                                    "Jawablah pertanyaan dibawah ini",
                                style: const TextStyle(
                                  fontSize: 42,
                                  color: ColorPalette.neutral_90,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        )
                      : widget.detailResultQuiz!.questionTypeId == 1
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: widget.detailResultQuiz!.image ?? '',
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                    child: Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                )),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  "assets/image/default_image.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: YoutubeValueBuilder(
                                  controller: _youtubeController!,
                                  builder: (context, value) {
                                    return YoutubePlayer(
                                      controller: _youtubeController!,
                                      aspectRatio: MediaQuery.of(context)
                                          .size
                                          .aspectRatio,
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .background,
                                    );
                                  }),
                            ),
                ),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    quetionsViewModel.data!.question ?? "",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: ColorPalette.neutral_90,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ColorPalette.success,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.detailResultQuiz!.answerStatus == 1
                            ? 'Jawaban Kamu :'
                            : 'Jawaban Benar : ',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        widget.detailResultQuiz!.answerStatus == 1
                            ? '${widget.detailResultQuiz!.answer}'
                            : '${widget.detailResultQuiz!.correctAnswer}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                widget.detailResultQuiz!.answerStatus == 1
                    ? Container()
                    : Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(top: 16),
                        decoration: BoxDecoration(
                          color: ColorPalette.danger,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Jawaban Kamu : ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              widget.detailResultQuiz!.answer ??
                                  'Tidak Menjawab',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(top: 16, bottom: 16),
                        decoration: BoxDecoration(
                          color: ColorPalette.neutral_20,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Kategori',
                              style: TextStyle(
                                color: ColorPalette.neutral_70,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              '${quetionsViewModel.data!.category}',
                              style: const TextStyle(
                                color: ColorPalette.neutral_90,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(top: 16, bottom: 16),
                        decoration: BoxDecoration(
                          color: ColorPalette.neutral_20,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tingkat Kesulitan',
                              style: TextStyle(
                                color: ColorPalette.neutral_70,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              '${quetionsViewModel.data!.level}',
                              style: const TextStyle(
                                color: ColorPalette.neutral_90,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Sumber Jawaban',
                  style: TextStyle(
                    color: ColorPalette.neutral_90,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () {
                    if (Uri.parse(quetionsViewModel.data!.source ?? '-')
                        .hasAbsolutePath) {
                      _launchInBrowser(
                          Uri.parse(quetionsViewModel.data!.source!));
                    }
                  },
                  child: Text(
                    Uri.parse(quetionsViewModel.data!.source == null
                                ? "-"
                                : quetionsViewModel.data!.source!
                                    .replaceAll(" ", ""))
                            .hasAbsolutePath
                        ? quetionsViewModel.data!.source!
                        : quetionsViewModel.data!.source ?? "-",
                    style: TextStyle(
                      color: Uri.parse(quetionsViewModel.data!.source == null
                                  ? "-"
                                  : quetionsViewModel.data!.source!
                                      .replaceAll(" ", ""))
                              .hasAbsolutePath
                          ? ColorPalette.colorLink
                          : ColorPalette.neutral_70,
                      fontSize: 14,
                      decoration: Uri.parse(
                                  quetionsViewModel.data!.source == null
                                      ? "-"
                                      : quetionsViewModel.data!.source!
                                          .replaceAll(" ", ""))
                              .hasAbsolutePath
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}
