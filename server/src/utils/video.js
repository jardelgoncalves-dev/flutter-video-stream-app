require("dotenv").config();
const Mux = require("@mux/mux-node");

const { Video } = new Mux(
  process.env.MUX_ACCESS_TOKEN,
  process.env.MUX_SECRET_KEY
)

module.exports = class VideoUtil {
  constructor(video = Video) {
    this.video = video
  }

  async create(videoUrl) {
    return this.video.Assets.create({
      input: videoUrl,
      playback_policy: "public",
    });
  }

  async list() {
    return Video.Assets.list();
  }
}