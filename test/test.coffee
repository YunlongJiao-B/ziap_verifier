assert = require 'assert'
ziap_verifier = require '../index'

describe 'iOS', ->
	it 'should be invalid', (done) ->
		verifier = ziap_verifier.createVerifier('ios')
		verifier.verify { receipt: 'receipt' }, (error, valid) ->
			assert !error
			valid.should.equal false
			done()

describe 'Google Play', ->
	it 'should be invalid', (done) ->
		verifier = ziap_verifier.createVerifier('googleplay', { publicKey: 'public_key' })
		verifier.verify { receipt: 'receipt', receiptSignature: 'sig' }, (error, valid) ->
			assert !error
			valid.should.equal false
			done()

describe 'Google Play', ->
	it 'missing properties', (done) ->
		verifier = ziap_verifier.createVerifier('googleplay', { publicKey: 'public_key' })
		verifier.verify {}, (error, valid) ->
			assert error
			error.type.should.equal 'MissingProperties'
			error.properties.should.equal 'receipt'
			done()

describe 'Amazon', ->
	it 'should be invalid', (done) ->
		verifier = ziap_verifier.createVerifier('amazon',  { secret: 'secret' })
		verifier.verify { userId: 'user_id', receipt: 'receipt' }, (error, valid) ->
			console.log 'error ' + JSON.stringify(error)
			error.should.be.object
			error.type.should.equal 'AmazonReceiptNotValid'
			done()

describe 'Facebook', ->
	it 'should be ok', (done) ->
		receipt = '{"object":"payments","entry":[{"id":"617617415035527","time":1431613346,"changed_fields":["actions"]}]}'
		receiptSignature = 'sha1=bf1c999e736b7e8f4113c8ca5e87ed5cd11627e9'
		verifier = ziap_verifier.createVerifier('facebook',  { secret: '4abc9369a6c3c0350d5a6439d90ae2d9' })
		verifier.verify { receipt: receipt, receiptSignature: receiptSignature }, (error, valid) ->
			assert !error
			valid.should.equal true
			done()

	it 'should be invalid', (done) ->
		verifier = ziap_verifier.createVerifier('facebook',  { secret: 'secret' })
		verifier.verify { receipt: 'receipt', receiptSignature: 'sig' }, (error, valid) ->
			assert !error
			valid.should.equal false
			done()

describe 'iOS Promise', ->
	it 'should be invalid', () ->
		verifier = ziap_verifier.createVerifierP('ios')
		verifier.verifyP({ receipt: 'receipt' }).then (valid) ->
			valid.should.equal false

describe 'Google Play Promise', ->
	it 'should be invalid', () ->
		verifier = ziap_verifier.createVerifierP('googleplay', { publicKey: 'public_key' })
		verifier.verifyP({ receipt: 'receipt', receiptSignature: 'sig' }).then (valid) ->
			valid.should.equal false

describe 'Amazon Promise', ->
	it 'should be invalid', () ->
		verifier = ziap_verifier.createVerifierP('amazon',  { secret: 'secret' })
		verifier.verifyP({ userId: 'user_id', receipt: 'receipt' }).then((valid) ->
			valid.should.equal false
		).catch((error) ->
			error.should.be.object
			error.type.should.equal 'AmazonReceiptNotValid'
		).done()

