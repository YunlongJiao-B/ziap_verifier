# ZIAP Verifier

Provide a consistent interface for iap verification on iOS/google play/amazon, etc.

## Installation

First of all, you need to login to npm as 'zentertain', please set the email as 'dev@zentertain.net'

```bash
npm login
```

Once you get logged in, do:

```bash
npm install @zentertain/ziap_verifier
```


## Usage

* [To verify a receipt](#verify-a-receipt)
  * [iOS](#ios)
  * [Google Play](#google-play)
  * [Amazon](#amazon)
  * [Facebook](#facebook)
* [If you want a promise](#if-you-want-a-promise)


## To verify a receipt

### iOS

``` js
  var ziap_verifier = require('@zentertain/ziap_verifier');

  var verifier = ziap_verifier.createVerifier('ios');
  var payment = { receipt: 'receipt string' };
  verifier.verify(payment, function(error, valid) {
    if (error) {
      // Some error happened, check the error list in lib/errors.coffee
    }

    if (valid) {
      // the receipt is verified as valid
    }
  });
```

### Google Play

``` js
  var ziap_verifier = require('@zentertain/ziap_verifier');

  var verifier = ziap_verifier.createVerifier('googleplay', { publicKey: 'The public key' });
  var payment = { receipt: 'receipt string', receiptSignature: 'receipt signature string' };
  verifier.verify(payment, function(error, valid) {
    if (error) {
      // Some error happened, check the error list in lib/errors.coffee
    }

    if (valid) {
      // the receipt is verified as valid
    }
  });
```

### Amazon

``` js
  var ziap_verifier = require('@zentertain/ziap_verifier');

  var verifier = ziap_verifier.createVerifier('amazon', { secret: 'The secret string', version: '2' });
  var payment = { userId: 'user_id', receipt: 'receipt' };
  verifier.verify(payment, function(error, valid) {
    if (error) {
      // Some error happened, check the error list in lib/errors.coffee
    }

    if (valid) {
      // the receipt is verified as valid
    }
  });
```

### Facebook

``` js
  var ziap_verifier = require('@zentertain/ziap_verifier');

  var verifier = ziap_verifier.createVerifier('facebook', { secret: 'The secret string' });
  var payment = { receipt: 'receipt string', receiptSignature: 'receipt signature string' };
  verifier.verify(payment, function(error, valid) {
    if (error) {
      // Some error happened, check the error list in lib/errors.coffee
    }

    if (valid) {
      // the receipt is verified as valid
    }
  });
```

## If you want a promise

Just add 'P' as suffix to your calls, take amazon's as an example:

``` js
  var ziap_verifier = require('@zentertain/ziap_verifier');

  var verifier = ziap_verifier.createVerifierP('amazon', { secret: 'The secret string', version: '2' });
  var payment = { userId: 'user_id', receipt: 'receipt' };
  verifier.verifyP(payment).then(function(valid) {
    if (valid) {
      // the receipt is verified as valid
    }
  }).catch(function(e) {
    // Some error happened.
  }).done();
```