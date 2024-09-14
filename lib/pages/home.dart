import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:nippon_tv/components/channelwidget.dart';
import 'package:nippon_tv/models/channel.dart';
import 'package:nippon_tv/utils/devicetype.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final List<Channel> _channels;
  final List<String> _categories = [];

  DateTime _currentTime = DateTime.now();

  late final CarouselSlider _carouselSlider;

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });

    _channels = [
      Channel(
        color: Colors.grey.shade50,
        imgPath: 'fujitv.png',
        title: 'Fuji TV',
        url: 'http://cdns.jp-primehome.com:8000/zhongying/live/playlist.m3u8?cid=bs06',
        category: "FEATURED",
      ),
      Channel(
        color: Colors.green.shade50,
        imgPath: 'tvtokyo.png',
        title: 'TV Tokyo',
        url: 'http://cdns.jp-primehome.com:8000/zhongying/live/playlist.m3u8?cid=bs05',
        category: "FEATURED",
      ),
      Channel(
        color: const Color(0xFFEBDFC7),
        imgPath: 'tokyomx.png',
        title: 'Tokyo MX 1',
        url: 'http://r3jx.djtmewibu.com/mx1/index.m3u8',
        category: "FEATURED",
      ),
      Channel(
        color: const Color(0xFFFFDBDB),
        imgPath: 'atx.png',
        title: 'AT-X',
        url: 'http://r3jx.djtmewibu.com/at-x/index.m3u8',
        category: "FEATURED",
      ),
      Channel(
        color: const Color(0xFFc5e1f2),
        imgPath: 'animax.png',
        title: 'Animax',
        url: 'http://cdns.jp-primehome.com:8000/zhongying/live/playlist.m3u8?cid=bs15',
        category: "FEATURED",
      ),
      Channel(
        color: const Color(0xFFE8FFE8),
        imgPath: 'mbs.png',
        title: 'MBS',
        url: 'http://cdns.jp-primehome.com:8000/zhongying/live/playlist.m3u8?cid=gx01',
        category: "FEATURED",
      ),
      Channel(
        color: const Color(0xBD7CFFD8),
        imgPath: 'nhke.png',
        title: 'NHK E',
        url: 'http://cdns.jp-primehome.com:8000/zhongying/live/playlist.m3u8?cid=gd02',
        category: "FAMILY",
      ),
      Channel(
        color: const Color(0xFFFF6666),
        imgPath: 'nhkg.png',
        title: 'NHK G',
        url: 'http://r3jx.djtmewibu.com/nhkg/index.m3u8',
        category: "FAMILY",
      ),
      Channel(
        color: const Color(0xFFFFD1E8),
        imgPath: 'asahi.png',
        title: 'TV Asahi',
        url: 'http://cdns.jp-primehome.com:8000/zhongying/live/playlist.m3u8?cid=gd06',
        category: "FAMILY",
      ),
      Channel(
        color: const Color(0xFFD8E4FF),
        imgPath: 'tbs.png',
        title: 'TBS',
        url: 'http://cdns.jp-primehome.com:8000/zhongying/live/playlist.m3u8?cid=gd04',
        category: "FAMILY",
      ),
      Channel(
        color: const Color(0xFFE8FFE8),
        imgPath: 'mbs.png',
        title: 'MBS',
        url: 'http://cdns.jp-primehome.com:8000/zhongying/live/playlist.m3u8?cid=gx01',
        category: "FAMILY",
      ),
      Channel(
        color: Colors.grey.shade50,
        imgPath: 'toei.png',
        title: 'Toei',
        url: 'http://cdns.jp-primehome.com:8000/zhongying/live/playlist.m3u8?cid=cs27',
        category: "FAMILY",
      ),
      Channel(
        color: const Color(0xFFd9d1c7),
        imgPath: 'bsasahi.png',
        title: 'BS Asahi',
        url: 'http://cdns.jp-primehome.com:8000/zhongying/live/playlist.m3u8?cid=bs03',
        category: "FAMILY",
      ),
      Channel(
        color: Colors.grey.shade50,
        imgPath: 'bsfuji.png',
        title: 'BS Fuji TV',
        url: 'http://cdns.jp-primehome.com:8000/zhongying/live/playlist.m3u8?cid=bs06',
        category: "FAMILY",
      ),
      Channel(
        color: const Color(0xFFE6EFFF),
        imgPath: 'jsports.png',
        title: 'J Sports 1',
        url: 'http://cdns.jp-primehome.com:8000/zhongying/live/playlist.m3u8?cid=bs18',
        category: "SPORTS",
      ),
      Channel(
        color: const Color(0xFFE6EFFF),
        imgPath: 'jsports.png',
        title: 'J Sports 2',
        url: 'http://cdns.jp-primehome.com:8000/zhongying/live/playlist.m3u8?cid=bs19',
        category: "SPORTS",
      ),
      Channel(
        color: const Color(0xFFE6EFFF),
        imgPath: 'jsports.png',
        title: 'J Sports 3',
        url: 'http://cdns.jp-primehome.com:8000/zhongying/live/playlist.m3u8?cid=bs21',
        category: "SPORTS",
      ),
      Channel(
        color: const Color(0xFFE6EFFF),
        imgPath: 'jsports.png',
        title: 'J Sports 4',
        url: 'http://cdns.jp-primehome.com:8000/zhongying/live/playlist.m3u8?cid=bs22',
        category: "SPORTS",
      ),
      Channel(
        color: const Color(0xFF202020),
        imgPath: 'gaora.png',
        title: 'Gaora Sports',
        url: 'http://cdns.jp-primehome.com:8000/zhongying/live/playlist.m3u8?cid=cs17',
        category: "SPORTS",
      ),
      Channel(
        color: Colors.grey.shade50,
        imgPath: 'musicjapantv.png',
        title: 'Music Japan TV',
        url: 'http://cdns.jp-primehome.com:8000/zhongying/live/playlist.m3u8?cid=cs06',
        category: "MUSIC",
      ),
      Channel(
        color: Colors.grey.shade50,
        imgPath: 'mtv.png',
        title: 'MTV Japan',
        url: 'http://cdns.jp-primehome.com:8000/zhongying/live/playlist.m3u8?cid=cs18',
        category: "MUSIC",
      ),
      Channel(
        color: Colors.grey.shade50,
        imgPath: 'movieplus.png',
        title: 'Movie Plus',
        url: 'http://cdns.jp-primehome.com:8000/zhongying/live/playlist.m3u8?cid=cs14',
        category: "MOVIES",
      ),
      Channel(
        color: Colors.grey.shade50,
        imgPath: 'wowowcinema.png',
        title: 'WOWOW Cinema',
        url: 'http://cdns.jp-primehome.com:8000/zhongying/live/playlist.m3u8?cid=bs07',
        category: "MOVIES",
      ),
      Channel(
        color: Colors.grey.shade50,
        imgPath: 'wowowlive.png',
        title: 'WOWOW Live',
        url: 'http://cdns.jp-primehome.com:8000/zhongying/live/playlist.m3u8?cid=bs20',
        category: "MOVIES",
      ),
      Channel(
        color: Colors.grey.shade50,
        imgPath: 'wowowprime.png',
        title: 'WOWOW Prime',
        url: 'http://cdns.jp-primehome.com:8000/zhongying/live/playlist.m3u8?cid=bs12',
        category: "MOVIES",
      ),
      Channel(
        color: const Color(0xFFFF6666),
        imgPath: 'cnnj.png',
        title: 'CNNj',
        url: 'http://cdns.jp-primehome.com:8000/zhongying/live/playlist.m3u8?cid=cs16',
        category: "NEWS",
      ),
      Channel(
        color: const Color(0xFFD8E4FF),
        imgPath: 'tbsnews.png',
        title: 'TBS News',
        url: 'http://cdns.jp-primehome.com:8000/zhongying/live/playlist.m3u8?cid=cs11',
        category: "NEWS",
      ),
      Channel(
        color: const Color(0xFFc5e1f2),
        imgPath: 'animax.png',
        title: 'Animax',
        url: 'http://cdns.jp-primehome.com:8000/zhongying/live/playlist.m3u8?cid=bs15',
        category: "ANIMATION",
      ),
      Channel(
        color: const Color(0xFFEBDFC7),
        imgPath: 'tokyomx.png',
        title: 'Tokyo MX 1',
        url: 'http://r3jx.djtmewibu.com/mx1/index.m3u8',
        category: "ANIMATION",
      ),
      Channel(
        color: const Color(0xFFEBDFC7),
        imgPath: 'tokyomx.png',
        title: 'Tokyo MX 2',
        url: 'http://r3jx.djtmewibu.com/mx2/index.m3u8',
        category: "ANIMATION",
      ),
      Channel(
        color: Colors.grey.shade50,
        imgPath: 'natgeo.png',
        title: 'National Geographic',
        url: 'http://cdns.jp-primehome.com:8000/zhongying/live/playlist.m3u8?cid=cs10',
        category: "DOCUMENTARIES",
      ),
      Channel(
        color: const Color(0xFF202020),
        imgPath: 'history.png',
        title: 'History Channel',
        url: 'http://cdns.jp-primehome.com:8000/zhongying/live/playlist.m3u8?cid=cs09',
        category: "DOCUMENTARIES",
      ),
      Channel(
        color: const Color(0xFFE4FAFF),
        imgPath: 'disneychannel.png',
        title: 'Disney Channel',
        url: 'http://cdns.jp-primehome.com:8000/zhongying/live/playlist.m3u8?cid=bs24',
        category: "KIDS TV",
      ),
      Channel(
        color: Colors.grey.shade50,
        imgPath: 'kidsstation.png',
        title: 'Kids Station',
        url: 'http://cdns.jp-primehome.com:8000/zhongying/live/playlist.m3u8?cid=cs07',
        category: "KIDS TV",
      ),
    ];

    for (var e in _channels) {
      if (!(_categories.contains(e.category))) _categories.add(e.category);
    }

    _carouselSlider = CarouselSlider(
      items: _channels.where((channel) => channel.category == "FEATURED").toList().map(
        (e) {
          return FeaturedChannel(channel: e);
        },
      ).toList(),
      options: CarouselOptions(
        autoPlay: true,
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        viewportFraction: 0.4,
        enlargeFactor: 0.3,
        enableInfiniteScroll: true,
      ),
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    setState(() {
      if (MediaQuery.of(context).orientation == Orientation.landscape) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
      }
    });

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff434343), Color(0xFF000000)],
          stops: [0, 1],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                height: screenWidth < DeviceType.mobile ? 100 : 80,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "日本テレビ",
                      style: TextStyle(
                        color: Color(0xFFF7F7F7),
                        fontSize: 30,
                      ),
                    ),
                    const Spacer(),
                    if (screenWidth > DeviceType.mobile)
                      const Text(
                        "Popular",
                        style: TextStyle(
                            color: Color(0xFFF7F7F7),
                            fontFamily: "Poppins",
                            fontSize: 35,
                            fontWeight: FontWeight.w600),
                      )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: screenWidth < DeviceType.mobile ? 100 : 80),
                child: Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            screenWidth < DeviceType.mobile
                                ? SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                            padding: EdgeInsets.all(20),
                                            child: Text(
                                              "Popular",
                                              style: TextStyle(
                                                  color: Color(0xFFF7F7F7),
                                                  fontFamily: "Poppins",
                                                  fontSize: 40,
                                                  fontWeight: FontWeight.w600),
                                            )),
                                        _carouselSlider
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            ..._categories.map((e) {
                              if (e == "FEATURED") {
                                return const SizedBox();
                              }
                              return _categoryBuilder(screenWidth, e);
                            })
                          ],
                        ),
                      ),
                    ),
                    if (screenWidth > DeviceType.mobile)
                      Container(
                        constraints: const BoxConstraints(maxWidth: kIsWeb ? 600 : 400),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _carouselSlider,
                            const Spacer(),
                            SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    _currentTime
                                        .add(const Duration(hours: 1))
                                        .toLocal()
                                        .toString()
                                        .split(' ')[0],
                                    style: const TextStyle(
                                        fontSize: 40,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    _currentTime
                                        .add(const Duration(hours: 1))
                                        .toLocal()
                                        .toString()
                                        .split(' ')[1]
                                        .split('.')[0],
                                    style: const TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  List<Channel> _getFilteredChannels(String category) {
    return _channels.where((channel) => channel.category == category).toList();
  }

  SizedBox _categoryBuilder(double screenWidth, String category) {
    final List<Channel> channels = _getFilteredChannels(category);

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: (category == "Family") && (screenWidth > DeviceType.mobile) ? 0 : 30,
                left: 20,
                bottom: 10),
            child: Text(
              category,
              style: const TextStyle(
                  color: Color(0xFFF7F7F7),
                  fontFamily: "Poppins",
                  fontSize: 30,
                  fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(
            height: screenWidth < DeviceType.mobile ? 200 : null,
            child: screenWidth < DeviceType.mobile
                ? ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      const SizedBox(width: 10),
                      ...channels.map((channel) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.5),
                          child: ChannelWidget(
                            width: 160,
                            height: 200,
                            channel: channel,
                          ),
                        );
                      }),
                      const SizedBox(width: 10),
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.only(left: 15),
                    width: double.infinity,
                    child: Wrap(
                      spacing: 5.0,
                      runSpacing: 5.0,
                      children: channels.map((channel) {
                        return ChannelWidget(
                          width: 160,
                          height: 200,
                          channel: channel,
                        );
                      }).toList(),
                    ),
                  ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
