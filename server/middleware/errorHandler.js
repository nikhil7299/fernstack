

const errorHandler = (err, req, res, next) => {

    const error = {
        statusCode: err[0],
        message: err[1],
        status: err[0] >= 400 && err[0] < 500 ? 'failure' : 'error',
    }
    res.status(error.statusCode).json({
        msg: error.message,
        status: error.status
    });

}

module.exports = errorHandler;