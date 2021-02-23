import 'package:flutter/material.dart';
import 'package:videostreamapp/model/asset_data.dart';
import 'package:videostreamapp/util/theme_color_custom.dart';
import 'package:videostreamapp/util/mux_client.dart';
import 'package:videostreamapp/widgets/video_tile.dart';
import 'package:videostreamapp/util/constants.dart';

import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MuxClient _muxClient = MuxClient();

  TextEditingController _textControllerVideoURL;
  FocusNode _textFocusNodeVideoURL;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _muxClient.initializeDio();
    _textControllerVideoURL = TextEditingController(text: demoVideoUrl);
    _textFocusNodeVideoURL = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _textFocusNodeVideoURL.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.dark,
          title: Text('MUX stream'),
          backgroundColor: ThemeColorCustom.muxPink,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {});
              },
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: ThemeColorCustom.muxPink.withOpacity(0.06),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 16.0,
                  left: 16.0,
                  right: 16.0,
                  bottom: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'UPLOAD',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22.0,
                      ),
                    ),
                    TextField(
                      focusNode: _textFocusNodeVideoURL,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      style: TextStyle(
                        color: ThemeColorCustom.muxGray,
                        fontSize: 16.0,
                        letterSpacing: 1.5,
                      ),
                      controller: _textControllerVideoURL,
                      cursorColor: ThemeColorCustom.muxPinkLight,
                      autofocus: false,
                      onSubmitted: (value) {
                        _textFocusNodeVideoURL.unfocus();
                      },
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ThemeColorCustom.muxPink,
                            width: 2,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black26,
                            width: 2,
                          ),
                        ),
                        labelText: 'Video URL',
                        labelStyle: TextStyle(
                          color: Colors.black26,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        hintText: 'Enter the URL of the video to upload',
                        hintStyle: TextStyle(
                          color: Colors.black12,
                          fontSize: 12.0,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    isProcessing
                        ? Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Processing . . .',
                                  style: TextStyle(
                                    color: ThemeColorCustom.muxPink,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    ThemeColorCustom.muxPink,
                                  ),
                                  strokeWidth: 2,
                                )
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: Container(
                              width: double.maxFinite,
                              child: RaisedButton(
                                color: ThemeColorCustom.muxPink,
                                onPressed: () async {
                                  setState(() {
                                    isProcessing = true;
                                  });
                                  await _muxClient.store(
                                      videoUrl: _textControllerVideoURL.text);
                                  setState(() {
                                    isProcessing = false;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: 12.0,
                                    bottom: 12.0,
                                  ),
                                  child: Text(
                                    'send',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<AssetData>(
                future: _muxClient.list(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    AssetData assetData = snapshot.data;
                    int length = assetData.data.length;

                    return ListView.separated(
                      physics: BouncingScrollPhysics(),
                      itemCount: length,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                            int.parse(assetData.data[index].createdAt) * 1000);
                        DateFormat formatter = DateFormat.yMd().add_jm();
                        String dateTimeString = formatter.format(dateTime);

                        String currentStatus = assetData.data[index].status;
                        bool isReady = currentStatus == 'ready';

                        String playbackId = isReady
                            ? assetData.data[index].playbackIds[0].id
                            : null;

                        String thumbnailURL = isReady
                            ? '$muxThumbnailBaseUrl/$playbackId/$imageTypeSize'
                            : null;

                        return VideoTile(
                          assetData: assetData.data[index],
                          thumbnailUrl: thumbnailURL,
                          isReady: isReady,
                          dateTimeString: dateTimeString,
                        );
                      },
                      separatorBuilder: (_, __) => SizedBox(
                        height: 16.0,
                      ),
                    );
                  }
                  return Container(
                    child: Text(
                      'No videos present',
                      style: TextStyle(
                        color: Colors.black45,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
