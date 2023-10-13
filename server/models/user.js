const mongoose = require("mongoose");

const userSchema = mongoose.Schema({
	name: {
		required: true,
		type: String,
		trim: true,
	},
	email: {
		required: true,
		type: String,
		trim: true,
		unique: true,
		validate: {
			validator: (value) => {
				const re =
					/^(([^<>()[\].,;:\s@"]+(\.[^<>()[\].,;:\s@"]+)*)|(".+"))@(([^<>()[\].,;:\s@"]+\.)+[^<>()[\].,;:\s@"]{2,})$/i;
				return value.match(re);
			},
			message: "Please enter a valid email address",
		},
	},
	password: {
		type: String,
		trim: true,
	},
	phone: {
		type: String,
		trim: true,
	},
	isPhoneVerified: {
		type: Boolean,
		default: false,
	},
	type: {
		type: String,
		default: "user",
	},

});

const User = mongoose.model("User", userSchema);
module.exports = User;
