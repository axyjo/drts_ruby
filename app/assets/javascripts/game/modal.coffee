Game.modal = Game.modal || {}

Game.modal.init = ->
  $("a").bind("click", Game.modal.click)
  $(document).keyup (e) ->
    if e.keyCode == 27
      Game.modal.hide()
  # TODO: recognize the URL if we need to load a modal for it.

Game.modal.click = (e) ->
  if e.target.href != ""
    Game.modal.fetch e.target.href
    window.history.pushState {}, "Title", e.target.href
  false

Game.modal.fetch = (url) ->
  $.ajax(
    type: "GET"
    url: url
    success: (data) ->
      $("#modal").html(data)
      if data == ' '
        window.location.reload()
      else
        Game.modal.show()
    )

Game.modal.show = ->
  $("#modal").show()
  $("#modal-overlay").show()

Game.modal.hide = ->
  $("#modal").hide()
  $("#modal-overlay").hide()
