import 'package:flutter/material.dart';
import 'package:videostreamapp/util/theme_color_custom.dart';

class InfoTile extends StatelessWidget {
  final String name;
  final String data;

  InfoTile({
    @required this.name,
    @required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            color: ThemeColorCustom.muxGray,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          data,
          style: TextStyle(
            color: ThemeColorCustom.muxGray.withOpacity(0.6),
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 8.0),
      ],
    );
  }
}
