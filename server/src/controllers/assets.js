const AssetsService = require("../service/assets");

class AssetsController {
  static async store(req, res) {
    const { videoUrl } = req.body;
    if (!videoUrl) {
      return res.status(400).json({ error: 'videoUrl is required!' })
    }
    const data = await AssetsService.create(videoUrl);
    return res.status(201).json(data);
  }

  static async index(req, res) {
    const data = await AssetsService.list();
    return res.status(200).json(data);
  }
}

module.exports = AssetsController;