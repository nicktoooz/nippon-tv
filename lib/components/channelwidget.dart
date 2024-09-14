import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nippon_tv/models/channel.dart';
import 'package:nippon_tv/utils/devicetype.dart';

class FeaturedChannel extends StatefulWidget {
  final Channel channel;
  const FeaturedChannel({super.key, required this.channel});

  @override
  State<FeaturedChannel> createState() => _FeaturedChannelState();
}

class _FeaturedChannelState extends State<FeaturedChannel> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => GoRouter.of(context)
          .go('/player?url=${widget.channel.url}&title=${widget.channel.title}'),
      child: AnimatedContainer(
        padding: const EdgeInsets.all(20),
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.channel.color,
        ),
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                'assets/images/${widget.channel.imgPath}',
              ),
            ),
            Text(
              widget.channel.title,
              style: TextStyle(
                  fontSize: screenWidth < DeviceType.mobile ? (screenWidth / 18) : 20,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}

class ChannelWidget extends StatefulWidget {
  final Channel channel;
  final double? height;
  final double? width;
  const ChannelWidget({super.key, required this.channel, this.height, this.width});

  @override
  State<ChannelWidget> createState() => _ChannelWidgetState();
}

class _ChannelWidgetState extends State<ChannelWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => GoRouter.of(context)
          .go('/player?url=${widget.channel.url}&title=${widget.channel.title}'),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Card(
          color: widget.channel.color,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color(0x2DFFFFFF), width: 3),
            borderRadius: BorderRadius.circular(4),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Opacity(
                      opacity: 0.8,
                      child: Image.asset(
                        'assets/images/${widget.channel.imgPath}',
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black38,
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      widget.channel.title,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFfF7F7F7),
                      ),
                      textAlign: TextAlign.start,
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
