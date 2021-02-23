const { Router } = require('express');
const AssetsController = require('./controllers/assets')
const routes = Router();


routes.get('/assets', AssetsController.index);
routes.post('/assets', AssetsController.store);

module.exports = routes