import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:winner_casino_test/models/tournament.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../common/raised_gradient_button.dart';
import '../models/tournaments_group.dart';

class GroupTournamentsScreen extends StatefulWidget {
  const GroupTournamentsScreen({Key? key}) : super(key: key);

  @override
  State<GroupTournamentsScreen> createState() => _GroupTournamentsScreenState();
}

class _GroupTournamentsScreenState extends State<GroupTournamentsScreen> {
  @override
  void initState() {
    super.initState();

    Provider.of<TournamentGroupProvider>(context,
      listen: false,
    ).getData(context, tenantId: 2);
  }

  @override
  Widget build(BuildContext context) {
    final tournamentGroups = Provider.of<TournamentGroupProvider>(context);

    var opt = OptionBuilder()
        .setTransports(['websocket'])
        .setPath("/ws")
        .disableAutoConnect()
        .setQuery({'tenantId': 2, 'protocol': 'sio1'})
        .build();

    Socket socket = io('https://test-micros1.play-online.com', opt);

    socket.on('tournament_end', (data) {
      debugPrint(data);
      tournamentGroups.models?.forEach((model) {
        for (var tournament in model.tournaments) {
          if (data['id'] != null && tournament.id == data['id']) {
            setState(() {
              tournament.missionGroupId = data['mission_group_id'] ?? '';
            });
          }
        }
      });
    });

    socket.on('tournament_created', (data) {
      debugPrint(data);
    });

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(5.0),
        child: tournamentGroups.loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
            child: ListView.separated(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) {
                  var tournamentGroup = tournamentGroups.models?[index];
                  var vip = tournamentGroup?.name.split(' ')[1];

                  return Column(
                    children: [
                      if (vip == 'non-VIP')
                        _nonVip(tournamentGroups, index)
                      else if (vip == 'VIP-only')
                        _vipOnly(tournamentGroups, index)
                      else
                        _flash(tournamentGroups, index),
                    ],
                  );
                },
                separatorBuilder: (context, _) => const SizedBox(height: 5.0),
                itemCount: tournamentGroups.models?.length ?? 0,
              ),
          ),
      ),
    );
  }

  Widget _nonVip(TournamentGroupProvider tournamentGroups, int idx) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemBuilder: (context, index) {
        final tournament = tournamentGroups.models?[idx].tournaments[index];

        final startDate = DateTime.fromMillisecondsSinceEpoch(
          tournament?.startDate ?? 0,
        );
        final endDate = DateTime.fromMillisecondsSinceEpoch(
          tournament?.endDate ?? 0,
        );

        final startDay = startDate.toString().split(' ')[0].split('-')[2];
        final endDay = endDate.toString().split(' ')[0].split('-')[2];

        final startMonth = DateFormat('MMM').format(startDate);
        final endMonth = DateFormat('MMM').format(endDate);

        final now = DateTime.now();

        bool activeNow = startDate.isBefore(now) && endDate.isAfter(now);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 5.0, bottom: 5.0),
              child: Text('Non VIP', style: TextStyle(fontSize: 20.0)),
            ),
            SizedBox(
              width: double.infinity,
              child: Card(
                color: Colors.indigo,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Card(
                        color: activeNow ? Colors.orangeAccent : Colors.blue,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(activeNow ? 'ACTIV ACUM' : 'VIITOR'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text('$startDay $startMonth - $endDay $endMonth'),
                    ),
                    const SizedBox(height: 10.0),
                    _card(tournament: tournament),
                    Align(
                      alignment: Alignment.centerRight,
                      child: MaterialButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text('DETALII TURNEU',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.arrow_circle_right_outlined,
                              size: 24.0,
                              color: Colors.deepOrangeAccent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      separatorBuilder: (context, _) => const SizedBox(height: 10.0),
      itemCount: tournamentGroups.models?[idx].tournaments.length ?? 0,
    );
  }

  Widget _vipOnly(TournamentGroupProvider tournamentGroups, int idx) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemBuilder: (context, index) {
        final tournament = tournamentGroups.models?[idx].tournaments[index];

        final startDate = DateTime.fromMillisecondsSinceEpoch(
          tournament?.startDate ?? 0,
        );
        final endDate = DateTime.fromMillisecondsSinceEpoch(
          tournament?.endDate ?? 0,
        );

        final startDay = startDate.toString().split(' ')[0].split('-')[2];
        final endDay = endDate.toString().split(' ')[0].split('-')[2];

        final startMonth = DateFormat('MMM').format(startDate);
        final endMonth = DateFormat('MMM').format(endDate);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 5.0, bottom: 5.0),
              child: Text('VIP Only', style: TextStyle(fontSize: 20.0)),
            ),
            SizedBox(
              width: double.infinity,
              child: Card(
                color: Colors.indigo,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.network(
                              tournament?.uiCornerImage.url ?? '',
                              scale: 4.0,
                            ),
                            Text(tournament?.name ?? ''),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Text('$startDay $startMonth - $endDay $endMonth'),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              const SizedBox(height: 14.0),
                              Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  Image.network(
                                    tournament?.uiTopImage.url ?? '',
                                    scale: 4.0,
                                  ),
                                  Column(
                                    children: [
                                      const Text('TOP',
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text('${tournament?.levels ?? "?"}',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14.0),
                              const Text('PREMII'),
                            ],
                          ),
                          Column(
                            children: [
                              Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  Image.network(
                                    tournament?.uiCurrentPlaceImage.url ?? '',
                                    scale: 3.0,
                                  ),
                                  const Text('?',
                                    style: TextStyle(
                                      fontSize: 32.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Text('LOCUL TAU'),
                            ],
                          ),
                          Column(
                            children: [
                              const SizedBox(height: 16.0),
                              Image.network(
                                tournament?.uiScoresImage.url ?? '',
                                scale: 3.0,
                              ),
                              const SizedBox(height: 16.0),
                              const Text('PUNCTAJ'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(MdiIcons.trophyOutline, color: Colors.white),
                        Text(' ${tournament?.uiPrize1.textRo ?? '?'} ${tournament?.uiPrize2.textRo ?? '?'}',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    RaisedGradientButton(
                      width: 200.0,
                      onPressed: (tournament?.enrolled ?? false)
                          ? null
                          : () {},
                      gradient: const LinearGradient(
                        colors: [Colors.redAccent, Colors.indigoAccent],
                      ),
                      child: Text((tournament?.activated ?? false)
                          ? 'PARTICIPA'
                          : 'DEBLOCHEAZA',
                        style: const TextStyle(color: Colors.white),
                      )
                    ),
                    const SizedBox(height: 10.0),
                    _winners(tournament: tournament),
                    const SizedBox(height: 10.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: MaterialButton(
                        onPressed: () {},
                        child: const Text('Vezi detalii',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      separatorBuilder: (context, _) => const SizedBox(height: 5.0),
      itemCount: tournamentGroups.models?[idx].tournaments.length ?? 0,
    );
  }

  Widget _flash(TournamentGroupProvider tournamentGroups, int idx) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemBuilder: (context, index) {
        final tournament = tournamentGroups.models?[idx].tournaments[index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 5.0, bottom: 5.0),
              child: Text('Turneu Flash', style: TextStyle(fontSize: 20.0)),
            ),
            _card(tournament: tournament),
          ],
        );
      },
      separatorBuilder: (context, _) => const SizedBox(height: 5.0),
      itemCount: tournamentGroups.models?[idx].tournaments.length ?? 0,
    );
  }

  Widget _card({
    TournamentModel? tournament,
  }) {
    return SizedBox(
      width: 200.0,
      child: Card(
        color: Colors.purple.withOpacity(0.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.network(
                  tournament?.uiCornerImage.url ?? '',
                  scale: 4.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Column(
                    children: [
                      Text(tournament?.uiPrize1.textRo ?? '?',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                      Text(tournament?.uiPrize2.textRo ?? '?',
                        style: const TextStyle(
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
              ),
              child: Text(tournament?.name ?? 'Unknown',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Divider(
              color: Colors.white,
              thickness: 0.2,
              indent: 10.0,
              endIndent: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Column(
                      children: [
                        Image.network(
                          tournament?.uiGamesImage.url ?? '',
                          scale: 3.0,
                        ),
                        const SizedBox(height: 5.0),
                      ],
                    ),
                    Text('+ ${tournament?.games?.length.toString() ?? "0"} jocuri'),
                  ],
                ),
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Image.network(
                      tournament?.uiTopImage.url ?? '',
                      scale: 5.0,
                    ),
                    Column(
                      children: [
                        const Text('TOP',
                          style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('${tournament?.levels ?? "?"}',
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: Container(
                color: (tournament?.enrolled ?? false)
                    ? Colors.green
                    : Colors.red,
                child: Text((tournament?.enrolled ?? false)
                    ? 'Esti inscris'
                    : 'Nu esti inca inscris',
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            RaisedGradientButton(
              onPressed: (tournament?.enrolled ?? false)
                  ? null
                  : () {},
              gradient: const LinearGradient(
                colors: [Colors.redAccent, Colors.indigoAccent],
              ),
              child: const Text('PARTICIPA',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _winners({
    TournamentModel? tournament,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('LOC', style: TextStyle(color: Colors.white)),
              Text('JUCATOR', style: TextStyle(color: Colors.white)),
              Text('PREMIU', style: TextStyle(color: Colors.white)),
              Text('PCT', style: TextStyle(color: Colors.white)),
            ],
          ),
        )
        // todo. get info about winners
      ],
    );
  }
}