IABVerifier = require 'iab_verifier'
errors = require './errors'


class GooglePlayVerifier
	constructor: (options) ->
		if !options || !options['publicKey']
			throw errors.getEnhancedError(errors.MissingProperties, { 'properties': 'publicKey' })

		@publicKey = options['publicKey']

	verify: (payment, cb) ->
		if !payment['receipt']
			return cb(errors.getEnhancedError(errors.MissingProperties, { 'properties': 'receipt' }))

		if !payment['receiptSignature'] && !payment['signature']
			return cb(errors.getEnhancedError(errors.MissingProperties, { 'properties': 'receiptSignature | signature' }))

		if !payment['productId']
			return cb(errors.getEnhancedError(errors.MissingProperties, { 'properties': 'productId' }))
		
		signature = payment['receiptSignature'] || payment['signature']

		verifier = new IABVerifier(@publicKey)
		valid = verifier.verifyReceipt(payment['receipt'], signature)

		if valid
			try
				cb null, JSON.parse(payment.receipt).productId == payment.productId
			catch e
				cb null, false
		else
			cb null, false

module.exports = GooglePlayVerifier