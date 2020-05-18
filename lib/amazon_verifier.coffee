errors = require './errors'
request = require 'request'


AMAZON_SERVER = "https://appstore-sdk.amazon.com/"

class AmazonVerifier
	constructor: (options) ->
		if !options || !options['secret']
			throw errors.getEnhancedError(errors.MissingProperties, { 'properties': 'secret' })

		@secret = options['secret']
		@version = options['version'] || '2'

	verify: (payment, cb) ->
		if !payment['userId']
			return cb(errors.getEnhancedError(errors.MissingProperties, { 'properties': 'userId' }))

		if !payment['receipt']
			return cb(errors.getEnhancedError(errors.MissingProperties, { 'properties': 'receipt' }))

		url = AMAZON_SERVER
		if (@version == '1')
			# Amazon's developers made this a shit...
			# They use '/2.0' for version 1 and '1.0' for version 2...
			url += "version/2.0/verify/developer/"
		else
			url += "version/1.0/verifyReceiptId/developer/"

		url += @secret + "/user/" + payment['userId'] + "/receiptId/" + payment['receipt']
		console.log 'url ' + url
		request url, (error, response, body) ->
			console.log 'request done error ' + JSON.stringify(error)
			console.log 'request done response.statusCode ' + response.statusCode
			if error
				return cb(error)

			switch response.statusCode
				when 200
					try
						b = JSON.parse(body)
						if payment.productId?
							cb null, b.productId == payment.productId
						else
							cb null, true
					catch e
						return cb errors.JSONParseError
				when 400
					return cb errors.AmazonReceiptNotValid
				when 496
					return cb errors.AmazonInvalidSecret
				when 497
					return cb errors.AmazonInvalidUserId
				when 498
					return cb errors.AmazonInvalidPurchaseToken
				when 499
					return cb errors.AmazonCredentialsExpired
				when 500
					return cb errors.AmazonInternalServerError

module.exports = AmazonVerifier

