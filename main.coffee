IOSVerifier = require './lib/ios_verifier'
GooglePlayVerifier = require './lib/googleplay_verifier'
AmazonVerifier = require './lib/amazon_verifier'
FacebookVerifier = require './lib/facebook_verifier'

Promise = require 'bluebird'

class ZIAPVerifier
	@createVerifier: (platform, options) ->
		switch platform
			when 'ios'
				return new IOSVerifier(options)
			when 'googleplay'
				return new GooglePlayVerifier(options)
			when 'amazon'
				return new AmazonVerifier(options)
			when 'facebook'
				return new FacebookVerifier(options)

	@createVerifierP: (platform, options) ->
		Promise.promisifyAll(@createVerifier(platform, options), {suffix: "P"})

module.exports = ZIAPVerifier