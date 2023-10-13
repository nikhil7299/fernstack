const User = require("../models/user");
const jwt = require("jsonwebtoken");
const bcryptjs = require("bcryptjs");

const JWT = process.env.JWT_SECRET;
const { TWILIO_SERVICE_SID, TWILIO_AUTH_TOKEN, TWILIO_ACCOUNT_SID } =
	process.env;

const client = require("twilio")(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, {
	lazyLoading: true,
});

const signUpEmail = async (req, res, next) => {
	try {
		const { name, email, password } = req.body;
		const existingUser = await User.findOne({ email: email });
		if (existingUser) {
			if (!existingUser._doc.password) {

				// sendgrid - send otp to email to generate a password
				// return res.status(403).json({ msg: "Account created with Google, LogIn with Google" });

				// return next(new CustomError(403, "Account created with Google, LogIn with Google"));
				return next([403, "Account created with Google, LogIn with Google"]);
			}
			// return res.status(403).json({ msg: "User already registered" });
			// return next(new CustomError(403, "User already registered"));
			return next([403, "User already registered"]);
		}

		const hashedPassword = await bcryptjs.hash(password, 8);
		let user = new User({ email: email, password: hashedPassword, name: name });
		user = await user.save();
		return res.status(200).json({ msg: "User Registered" });

	} catch (error) {
		console.log(error.message);
		// res.status(500).json({ msg: error.message });
		return next([500, error.message]);
	}
}

const logInEmail = async (req, res, next) => {
	try {

		const { email, password } = req.body;
		const user = await User.findOne({ email: email });
		if (!user) {
			// return res.status(403).json({ msg: "User email not yet registered" });
			return next([403, "User email not yet registered"]);
		}


		const isPasswordMatched = await bcryptjs.compare(password, user.password);
		if (!isPasswordMatched) {
			// return res.status(403).json({ msg: "Invalid password, try again" });
			return next([403, "Invalid password, try again"]);
		}

		const token = jwt.sign({ id: user._id }, JWT, {
			expiresIn: "360 days",
		});

		delete user._doc.password;

		return res.status(200).json({
			msg: "User Logged In Successfully",
			user: user,
			token: token,
			provider: "email",
		});

	} catch (error) {
		console.log(error.message);
		// res.status(500).json({ msg: error.message });
		return next([500, error.message]);
	}
}

const logInGoogle = async (req, res, next) => {
	console.log("logInGoogle");
	try {

		const { email, name } = req.body;
		console.log(email);
		let user = await User.findOne({ email: email });
		if (!user) {
			user = new User({ email, name });
			user = await user.save();
		} else {
			delete user._doc.password;
		}
		console.log(user);
		const token = jwt.sign({ id: user._id }, JWT, {
			expiresIn: "360 days",
		});

		return res.status(200).json({
			msg: "User Logged In Successfully",
			user: user,
			token: token,
			provider: "google",
		});

	} catch (error) {
		console.log(error.message);
		// res.status(500).json({ msg: error.message });
		return next([500, error.message]);
	}
}


const getUser = async (req, res, next) => {
	const user = await User.findById(req.userId);
	if (!user) {
		// return res.status(403).json({ msg: "Log In Expired" });
		return next([403, "Log In Expired"]);
	}
	console.log(user);
	if (user._doc.password) {
		delete user._doc.password;
		return res.json({ msg: "User Details", user: user, token: req.token, provider: "email" });

	}

	// delete user._doc.password;
	return res.json({ msg: "User Details", user: user, token: req.token, provider: "google" });
};

module.exports = { signUpEmail, logInEmail, getUser, logInGoogle };
