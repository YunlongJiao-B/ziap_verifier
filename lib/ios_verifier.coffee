IAPVerifier = require 'iap_verifier'
errors = require './errors'


class IOSVerifier
	constructor: (options) ->

	verify: (payment, cb) ->
		if !payment['receipt']
			return cb(errors.getEnhancedError(errors.MissingProperties, { 'properties': 'receipt' }))

		if !payment['productId']
			return cb(errors.getEnhancedError(errors.MissingProperties, { 'properties': 'productId' }))

		verifier = new IAPVerifier(null, null, true)
		verifier.verifyReceipt payment['receipt'], (valid, msg, data) =>
			if valid
				cb null, data.receipt.product_id == payment.productId
			else
				cb null, false

module.exports = IOSVerifier

