const router=require('express').Router();
const USerController=require('../controller/user_controller');
const UserService = require('../services/user_services');


router.post('/registeration',USerController.register);
router.post('/login',USerController.login);


module.exports=router;