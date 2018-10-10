import 'package:flutter/material.dart';

final pages = [
  PageViewModel(
    color: const Color(0xFF678FB4),
    heroAssetPath: 'images/hotels.png',
    title: 'Hotels',
    body: 'All hotels and hostels are soted by hospatility rating',
    iconAssetPath: 'images/icons/key.png',
  ),
  PageViewModel(
    color: const Color(0xFF65B0B4),
    heroAssetPath: 'images/banks.png',
    title: 'Banks',
    body: 'We carefully verify all banks before adding them into the app',
    iconAssetPath: 'images/icons/wallet.png',
  ),
  PageViewModel(
    color: const Color(0xFF9B90BC),
    heroAssetPath: 'images/stores.png',
    title: 'Stores',
    body: 'All local stores are categorized for your convenience',
    iconAssetPath: 'images/icons/shopping_cart.png',
  ),
];

class Page extends StatelessWidget {
  final PageViewModel viewModel;
  final double percentVisible;

  Page({this.viewModel, this.percentVisible = 1.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: viewModel.color,
      child: Opacity(
        opacity: percentVisible,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Transform(
              transform: Matrix4.translationValues(
                0.0,
                350.0 * (1.0 - percentVisible),
                0.0,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: 25.0,
                ),
                child: Image.asset(
                  viewModel.heroAssetPath,
                  width: 200.0,
                  height: 200.0,
                ),
              ),
            ),
            Transform(
              transform: Matrix4.translationValues(
                0.0,
                400.0 * (1.0 - percentVisible),
                0.0,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10.0,
                ),
                child: Text(
                  viewModel.title,
                  style: TextStyle(
                    fontSize: 34.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Transform(
              transform: Matrix4.translationValues(
                0.0,
                350.0 * (1.0 - percentVisible),
                0.0,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: 75.0,
                  left: 30.0,
                  right: 30.0,
                ),
                child: Text(
                  viewModel.body,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageViewModel {
  final Color color;
  final String heroAssetPath;
  final String title;
  final String body;
  final String iconAssetPath;

  PageViewModel({
    this.color,
    this.heroAssetPath,
    this.title,
    this.body,
    this.iconAssetPath,
  });
}
