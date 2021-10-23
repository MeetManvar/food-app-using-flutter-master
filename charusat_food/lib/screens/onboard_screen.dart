import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';

import 'constants.dart';

class OnBoardScreen extends StatefulWidget {
  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

final _controller = PageController(
  initialPage: 0,
);

int _currentpage = 0;

List<Widget> _pages = [
  Column(
    children: [
      Expanded(child: Image.asset('images/address.png')),
      Text(
        'Self Service',
        style: kPageViewTextStyle,
      )
    ],
  ),
  Column(
    children: [
      Expanded(child: Image.asset('images/payment.png')),
      Text(
        'Easy Payment',
        style: kPageViewTextStyle,
      )
    ],
  ),
  Column(
    children: [
      Expanded(child: Image.asset('images/Charusat.png')),
      Text(
        'Made for charusat',
        style: kPageViewTextStyle,
      )
    ],
  )
];

class _OnBoardScreenState extends State<OnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _controller,
            children: _pages,
            onPageChanged: (index) {
              setState(() {
                _currentpage = index;
              });
            },
          ),
        ),
        SizedBox(height: 20),
        DotsIndicator(
          dotsCount: _pages.length,
          position: _currentpage.toDouble(),
          decorator: DotsDecorator(
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              activeColor: Theme.of(context).primaryColor),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
