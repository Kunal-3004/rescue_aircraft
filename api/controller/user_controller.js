const UserService=require('../services/user_services');
const nodeMailer=require('nodemailer');
const jwt=require('jsonwebtoken');
const bcrypt=require('bcrypt');
require('dotenv').config();


exports.register= async(req,res,next)=>{
    try{
        const {name,email,password} =req.body;

        const successRes=await UserService.registerUser(name,email,password);

        res.json({status:true,success:"User Registerd Successfully"});
    }catch(error){
        throw error
    }
}

exports.login= async(req,res,next)=>{
    try{
        const {email,password} =req.body;

        const user = await UserService.checkuser(email);
        console.log("-----------user--------------",user);
        if(!user){
            throw new Error('User dont exist');
        }

        const isMatch =await user.comparePassword(password);

        if(isMatch==false){
            throw new Error("Password invalid");
        }
        let tokenData = {_id:user._id,email:user.email};

        const token= await UserService.generateToken(tokenData,"secretKey",'1h')

        res.status(200).json({status:true,token:token})
    

    }catch(error){
        throw error
    }
}