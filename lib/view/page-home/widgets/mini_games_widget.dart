import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:isilahtitiktitik/bloc/game-bloc/game_bloc.dart';
import 'package:isilahtitiktitik/constant/color_palette.dart';
import 'package:isilahtitiktitik/constant/constant.dart';
import 'package:isilahtitiktitik/games/engklek/screens/main_menu.dart';
import 'package:isilahtitiktitik/games/lompatkaret/screens/main_menu.dart';
import 'package:isilahtitiktitik/games/tariktambang/screens/main_menu.dart';
import 'package:isilahtitiktitik/model/list_game.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/games/isiboyrun/screens/game_play.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MiniGamesWidget extends StatefulWidget {
  const MiniGamesWidget({Key? key}) : super(key: key);

  @override
  State<MiniGamesWidget> createState() => _MiniGamesWidgetState();
}

class _MiniGamesWidgetState extends State<MiniGamesWidget> {
  final GameBloc gameBloc = GameBloc();

  int pageNumber = 1;
  int? _limit = 1;
  int? _currentLenght;

  List<DataGame> _listDataGame = [];
  final ScrollController _scGame = ScrollController();

  Future<void> _loadMoreDataGame(bool statusLoad) async {
    CHttp chttp = Provider.of<CHttp>(context, listen: false);
    gameBloc.add(
        GetListGame(http: chttp, statusLoad: statusLoad, page: pageNumber));
  }

  @override
  void initState() {
    _loadMoreDataGame(true);
    _scGame.addListener(() {
      if (_scGame.position.pixels == _scGame.position.maxScrollExtent) {
        if (_currentLenght != null) {
          if (_currentLenght! < _limit!) {
            pageNumber = pageNumber + 1;
            _loadMoreDataGame(false);
          }
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    gameBloc.close();
    _scGame.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameBloc>(
      create: (context) => gameBloc,
      child: _buildMiniGames(),
    );
  }

  Widget _buildMiniGames() {
    return BlocBuilder<GameBloc, GameState>(builder: (context, state) {
      if (state is GameInitial) {
        return _loadingMiniGames();
      } else if (state is ListGameLoading) {
        return _loadingMiniGames();
      } else if (state is ListGameLoaded || state is ListGameMoreLoading) {
        if (state is ListGameLoaded) {
          _listDataGame = state.list;
          _currentLenght = state.count;
          _limit = state.limit;
        }
        return _buildListMiniGames();
      } else if (state is ListGameError) {
        return Container();
      }

      return Container();
    });
  }

  Widget _loadingMiniGames() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              width: 100,
              height: 15,
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: StaggeredGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  StaggeredGridTile.fit(
                    crossAxisCellCount: 1,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: double.infinity,
                        height: 118,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  StaggeredGridTile.fit(
                    crossAxisCellCount: 1,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: double.infinity,
                        height: 118,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  StaggeredGridTile.fit(
                    crossAxisCellCount: 1,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: double.infinity,
                        height: 118,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  StaggeredGridTile.fit(
                    crossAxisCellCount: 1,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: double.infinity,
                        height: 118,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ])),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget _buildListMiniGames() {
    if (_listDataGame.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Text(
            'Mini Games',
            style: TextStyle(
              fontSize: 16,
              color: ColorPalette.neutral_90,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: StaggeredGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              ..._listDataGame.map((games) => games.status == 0
                  ? Container()
                  : StaggeredGridTile.fit(
                      crossAxisCellCount: 1,
                      child: GestureDetector(
                        onTap: () {
                          if (games.dailyPlayAvailable == 0) {
                            Flushbar(
                              message:
                                  'Limit bermain anda sudah habis, silahkan main lagi besok',
                              margin: const EdgeInsets.all(16),
                              borderRadius: BorderRadius.circular(8),
                              duration: const Duration(seconds: 2),
                              messageSize: 12,
                              backgroundColor: Colors.red,
                            ).show(context);
                          } else {
                            switch (games.gameId) {
                              case 1:
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        MainMenu(levelGame: games.levels)));
                                break;
                              case 2:
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        GamePlay(levelGame: games.levels)));
                                break;
                              case 3:
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MainMenuLompatKaret(
                                        levelGame: games.levels)));
                                break;
                              case 4:
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MainMenuEngklek(
                                        levelGame: games.levels)));
                                break;
                            }
                          }
                        },
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.18,
                                imageUrl: games.thumbnail == null
                                    ? ""
                                    : imageUrl + games.thumbnail!,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                          width: 1,
                                          color: ColorPalette.greyColor)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      "assets/image/default_image.png",
                                      height: 118,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.12,
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/icon/ic_heart.png',
                                          width: 15,
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          '${games.dailyPlayAvailable}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ))
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
