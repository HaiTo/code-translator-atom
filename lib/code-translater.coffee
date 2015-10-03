CodicTranslater = require './translator'
{CompositeDisposable} = require 'atom'

module.exports =
  config:
    token:
      title: 'your-api-secret'
      description: 'Microsoft Translation API secret.
      see: https://datamarket.azure.com/dataset/bing/microsofttranslator#schema'
      type: 'string'
      default: 'awesame_token'

  codicCallerView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'code-translater:translate': => @translate()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @codicCallerView.destroy()

  serialize: ->
    codicCallerViewState: @codicCallerView.serialize()

  translate: ->
    editor = atom.workspace.getActiveTextEditor()
    return unless editor?

    translater = new Translator('5Vh4kzUzgNJ2ILUezimcIMwgnHTDJfCcCjNj6T76/EA=')
    token = translater.translate('認証', 'en', {})

    selected_text = editor.tokenForBufferPosition(editor.getCursorBufferPosition())
