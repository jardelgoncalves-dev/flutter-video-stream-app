const Video = require("../utils/video");

class AssetsService {
  static async create(videoUrl) {
    return new Video().create(videoUrl)
  }

  static async list() {
    return new Video().list()
  }
}

module.exports = AssetsService