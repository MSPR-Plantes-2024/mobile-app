import 'package:flutter/material.dart';
import 'package:mobile_app_arosaje/models/plant.dart';

class ImageCarousel extends StatefulWidget {
  final List<Plant> plants;
  const ImageCarousel({super.key, required this.plants});

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {

  late List<Widget> _dots = [];
  @override
  void initState() {
    super.initState();
    _dots = List<Widget>.generate(widget.plants.length, (i) => Container(
      child: Container(
        width: 10.0,
        height: 10.0,
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: i == 0 ? Colors.green : Colors.grey,
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200.0,

          child: PageView.builder(
            onPageChanged: (int index) {
              setState(() {
                _dots = List<Widget>.generate(widget.plants.length, (i) => Container(
                  child: Container(
                    width: 10.0,
                    height: 10.0,
                    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == index ? Colors.green : Colors.grey,
                    ),
                  ),
                ));
              });
            },
            itemCount: widget.plants.length,
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () {
                    showDialog(context: context, builder: (BuildContext context) {
                      return Dialog(
                        child: Image.asset(widget.plants[index].picture!.url),
                      );
                    }
                    );
                  },
                  child: Image.asset(widget.plants[index].picture!.url));
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _dots,
        )
      ],
    );
  }
}