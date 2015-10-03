CodicTranslator = require './translator.coffee'
{CompositeDisposable} = require 'atom'

module.exports =
  config:
    token:
      title: 'your-api-secret'
      description: 'Microsoft Translation API secret.
      see: https://datamarket.azure.com/dataset/bing/microsofttranslator#schema'
      type: 'string'
      default: 'awesame_token'
    to_lang:
      title: 'to translation language'
      description: 'en, ja, anything'
      type: 'string'
      default: 'ja'

  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'code-translater:translate': => @translate()

  deactivate: ->
    @subscriptions.dispose()

  serialize: ->

  translate: ->
    editor = atom.workspace.getActiveTextEditor()
    return unless editor?

    selected_text = editor.tokenForBufferPosition(editor.getCursorBufferPosition())

    translator = new CodicTranslator(atom.config.get('code-translater.token'))

    translator.detect(selected_text.value)
    #translator.speak(selected_text.value)
    translated_string = translator.translate(selected_text.value, atom.config.get('code-translater.to_lang'))
