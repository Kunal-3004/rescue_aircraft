const router=require('express').Router();
const USerController=require('../controller/user_controller');
const UserService = require('../services/user_services');
const { calcSquareJson ,calcCircleJson} = require('../area');

router.post('/calculate-square', (req, res) => {
  const { newLatLon, side, direction, cellSide } = req.body;

  try {
    const result = calcSquareJson(newLatLon, side, direction, cellSide);
    res.status(200).json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.post('/calculate-circle', (req, res) => {
  const { newLatLon, side, direction, cellSide } = req.body;

  try {
    const result = calcCircleJson(newLatLon, side, direction, cellSide);
    res.status(200).json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.post('/registeration',USerController.register);
router.post('/login',USerController.login);


module.exports=router;