MsTranslator = require('mstranslator')

module.exports =
  class Translator
    constructor: (api_secret)->
      @client_id = 'caller-in-atom'
      @api_secret = api_secret
      @client = new MsTranslator({
              client_id: @client_id,
              client_secret: @api_secret
            }, true)

    translate: (text, to_lang) ->
      @client.translate(
        {text: text, to: to_lang}
        , (err, translated) ->
          atom.notifications.addInfo "#{text} -> #{translated}"
          return translated
      )

    speak: (text) ->
      context = new window.AudioContext()
      source = context.createBufferSource()

      console.log(source)
      console.log(context)

      lang = @detect(text)

      @client.speak(
        {text: text, language: lang, format: 'audio/mp3'}
        ,(err, buffer, los) ->
          context.decodeAudioData(
            buffer,
            (buf) ->
              source.buffer = buf
              source.connect(@context.destination)
              source.start(0)
          )
      )

    detect: (text) ->
      @client.detect(
        {text: text}
        , (err, detected) ->
          detected
      )
