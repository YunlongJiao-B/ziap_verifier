
_ = require 'lodash'

errors = {
    'JSONParseError': { message: "JSON parse error." }
    'MissingProperties': { message: "Missing properties." }
    'AmazonReceiptNotValid': { message: "Amazon: The transaction represented by this Purchase Token is no longer valid." }
    'AmazonInvalidSecret': { message: "Amazon: Invalid sharedSecret." }
    'AmazonInvalidUserId': { message: "Amazon: Invalid User ID." }
    'AmazonInvalidPurchaseToken': { message: "Amazon: Invalid Purchase Token." }
    'AmazonCredentialsExpired': { message: "Amazon: The Purchase Token was created with credentials that have expired." }
    'AmazonInternalServerError': { message: "Amazon: There was an Internal Server Error." }

    getEnhancedError: (error, info) ->
        _.assign(_.clone(error), info)
}

for e of errors
    errors[e]['type'] = e

module.exports = errors