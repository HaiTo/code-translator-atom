MsTranslator = require('mstranslator')

module.exports =
  class Translator
    constructor: (api_secret)->
      @client_id = 'caller-in-atom'
      @api_secret = api_secret

    translate: (text, to_lang, callback) ->
      client = new MsTranslator({
        client_id: @client_id,
        client_secret: @api_secret
      }, true)

      client.detect(
        {text: text},
        (err, from_lang) ->
          client.translate(
            {text: text, to: to_lang, from: from_lang}
            , (err, translated) ->
              return translated
          )
      )
