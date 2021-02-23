class AssetsDTO {
  static transform({ asset }) {
    if (!asset) return []
    const assets = Array.isArray(asset) ? asset : [asset];

    return assets.map(asset => ({
      id: asset.id,
      status: asset.status,
      playback_ids: asset.playback_ids,
      created_at: asset.created_at,
      duration: asset.duration,
      max_stored_resolution: asset.max_stored_resolution,
      max_stored_frame_rate: asset.max_stored_frame_rate,
      aspect_ratio: asset.aspect_ratio,
    }))
  }
}

module.exports = AssetsDTO