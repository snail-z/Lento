import 'package:flutter/material.dart';

class DynamicItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final int viewCount;
  static const double ITEM_HEIGHT = 100;
  static const double TITLE_HEIGHT = 80;
  static const double MARGIN_SIZE = 10;
  const DynamicItem(this.title, this.imageUrl, this.viewCount, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(MARGIN_SIZE),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _imageWrapper(this.imageUrl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _titleWrapper(context, title),
                _viewCountWrapper(this.viewCount.toString()),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _titleWrapper(BuildContext context, String text) {
    return Container(
      height: TITLE_HEIGHT,
      margin: const EdgeInsets.fromLTRB(MARGIN_SIZE, 0, 0, 0),
      child: Text(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Widget _viewCountWrapper(String text) {
    return Container(
      margin: EdgeInsets.fromLTRB(MARGIN_SIZE, 0, 0, 0),
      height: ITEM_HEIGHT - TITLE_HEIGHT,
      child: Row(children: [
        const Icon(
          Icons.remove_red_eye_outlined,
          size: 14.0,
          color: Colors.grey,
        ),
        const SizedBox(width: 55),
        Text(
          viewCount.toString(),
          style: const TextStyle(color: Colors.grey, fontSize: 14.0),
        ),
      ]),
    );
  }

  Widget _imageWrapper(String imageUrl) {
    return SizedBox(
      width: 150,
      height: ITEM_HEIGHT,
      child: Image.network(imageUrl),
    );
  }
}