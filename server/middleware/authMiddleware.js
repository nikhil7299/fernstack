const jwt = require("jsonwebtoken");

const authMiddleware = async (req, res, next) => {
	try {
		const bearerToken = req.header("Authorization");
		const token = bearerToken.split(" ")[1];
		if (!token)
			// return res.status(401).json({ msg: "No Auth Token, Access Denied" });
			return next([401, "No Auth Token, Access Denied"]);
		const verified = jwt.verify(token, process.env.JWT_SECRET);

		if (!verified)
			// return res.status(401).json({
			// 	msg: "Token verification failed, Authorization Denied",
			// });
			return next([401, "Token verification failed, Authorization Denied"]);

		req.userId = verified.id;
		req.token = token;
		next();
	} catch (error) {
		// res.status(500).json({ error: error.message });
		return next([500, error.message]);

	}
};

module.exports = authMiddleware;
