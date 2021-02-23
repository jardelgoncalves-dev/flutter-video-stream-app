const { Router } = require('express');
const AssetsController = require('./controllers/assets')
const routes = Router();


routes.get('/assets', AssetsController.index);
routes.post('/assets', AssetsController.store);
routes.get('/asset', AssetsController.findOne);

module.exports = routes