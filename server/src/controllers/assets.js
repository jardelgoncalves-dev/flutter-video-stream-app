const AssetsService = require("../service/assets");
const AssetDTO = require("../data-transformation/assets");

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
    const response = AssetDTO.transform({ asset: data })
    return res.status(200).json({ data: response });
  }

  static async findOne(req, res) {
    const {videoId} = req.query;
    const data = await AssetsService.findOne(videoId);
    const [response] = AssetDTO.transform({ asset: data })

    return res.status(200).json({ data: response });
  }
}

module.exports = AssetsController;