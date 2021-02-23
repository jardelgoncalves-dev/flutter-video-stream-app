import 'package:flutter_dotenv/flutter_dotenv.dart';

const muxSendBaseUrl = 'https://api.mux.com';
const apiBaseUrl = 'http://localhost:3333';
const muxThumbnailBaseUrl = 'https://image.mux.com';
const muxStreamBaseUrl = 'https://stream.mux.com';
const videoExtension = 'm3u8';
const imageTypeSize = 'thumbnail.jpg?time=5&width=200';
const contentType = 'application/json';
var authToken = env['MUX_SECRET_KEY'];
const demoVideoUrl =
    'https://storage.googleapis.com/muxdemofiles/mux-video-intro.mp4';
const playbackPolicy = 'public';
