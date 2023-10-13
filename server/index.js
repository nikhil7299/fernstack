if (!process.env.PORT || !process.env.MONGO_URL) require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");
const app = express();
const morgan = require("morgan")

// const adminRouter = require();
const authRouter = require("./routes/authRouter");
const errorHandler = require("./middleware/errorHandler");
// const userRouter = require();
//const productRouter = require();

const PORT = process.env.PORT || 3000;
const DB = process.env.MONGO_URL;


app.use(morgan('dev'));
app.use(express.json());

app.use(authRouter);
app.use(errorHandler);
mongoose.set(`strictQuery`, true);

mongoose
	.connect(DB, {})
	.then(() => console.log("Connected to mongoDB"))
	.catch((e) => console.log(e));

app.listen(PORT, "0.0.0.0", () => console.log(`Connected at port ${PORT}`))