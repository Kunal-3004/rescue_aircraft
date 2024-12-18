const app=require('./api/app');
const db=require('./api/config/db')
const cors = require('cors');
const UserModel=require('./api/model/user_model')

const port=4001;

app.get('/',(req,res)=>{
    res.send("Hello World!!!")
});

app.use(cors());

app.listen(port,()=>{
    console.log('Server listening on port http://localhost:4001');
});