const express = require("express");
const authRouter = express.Router();
const authMiddleware = require("../middleware/authMiddleware");
const {
	getUser,
	signUpEmail,
	logInEmail,
	logInGoogle,
} = require("../controllers/authController");


authRouter.post("/auth/signUpEmail", signUpEmail);
authRouter.post("/auth/logInEmail", logInEmail);
authRouter.post("/auth/logInGoogle", logInGoogle);


authRouter.get("/", authMiddleware, getUser);

module.exports = authRouter;
