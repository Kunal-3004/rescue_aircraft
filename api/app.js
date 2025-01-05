const express=require("express");
const body_parser=require('body-parser');
const userRouter=require('./routers/user_router');

const app=express();

app.use(body_parser.json());
app.use('/api',userRouter);

module.exports=app;