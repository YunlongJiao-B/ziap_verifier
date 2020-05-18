crypto = require 'crypto'
errors = require './errors'


class FacebookVerifier
	constructor: (options) ->
		if !options || !options['secret']
			throw errors.getEnhancedError(errors.MissingProperties, { 'properties': 'secret' })

		@secret = options['secret']

	verify: (payment, cb) ->
		if !payment['receipt']
			return cb(errors.getEnhancedError(errors.MissingProperties, { 'properties': 'receipt' }))

		if !payment['receiptSignature']
			return cb(errors.getEnhancedError(errors.MissingProperties, { 'properties': 'receiptSignature' }))
		
		hmac = crypto.createHmac('sha1', @secret);
		hmac.update(payment['receipt']);
		expected = 'sha1' + '=' + hmac.digest('hex');
		if expected == payment['receiptSignature']
			cb null, true
		else
			cb null, false

module.exports = FacebookVerifier

