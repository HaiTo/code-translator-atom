CodicCaller = require '../lib/codic-caller'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "CodicCaller", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('code-translater')

  describe "when the codic-caller:toggle event is triggered", ->
    it "hides and shows the modal panel", ->
      # Before the activation event the view is not on the DOM, and no panel
      # has been created
      expect(workspaceElement.querySelector('.code-translater')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'codic-caller:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(workspaceElement.querySelector('.code-translater')).toExist()

        codicCallerElement = workspaceElement.querySelector('.code-translater')
        expect(codicCallerElement).toExist()

        codicCallerPanel = atom.workspace.panelForItem(codicCallerElement)
        expect(codicCallerPanel.isVisible()).toBe true
        atom.commands.dispatch workspaceElement, 'code-translater:toggle'
        expect(codicCallerPanel.isVisible()).toBe false

    it "hides and shows the view", ->
      # This test shows you an integration test testing at the view level.

      # Attaching the workspaceElement to the DOM is required to allow the
      # `toBeVisible()` matchers to work. Anything testing visibility or focus
      # requires that the workspaceElement is on the DOM. Tests that attach the
      # workspaceElement to the DOM are generally slower than those off DOM.
      jasmine.attachToDOM(workspaceElement)

      expect(workspaceElement.querySelector('.codic-caller')).not.toExist()

      # This is an activation event, triggering it causes the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'codic-caller:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        # Now we can test for view visibility
        codicCallerElement = workspaceElement.querySelector('.codic-caller')
        expect(codicCallerElement).toBeVisible()
        atom.commands.dispatch workspaceElement, 'codic-caller:toggle'
        expect(codicCallerElement).not.toBeVisible()
