Game.modal = Game.modal || {}

Game.modal.init = ->
  Game.modal._ = $ "#modal"
  Game.modal.overlay = $ "#modal-overlay"
  $("li").bind("click", Game.modal.click)
  Game.modal.overlay.bind 'click', Game.modal.hide
  Game.modal._.on "click", "a", Game.modal.click
  Game.modal.changeActive()
  $(document).keyup (e) ->
    if e.keyCode == 27
      Game.modal.hide()
  default_path = Game.modal._.data('path')
  if !Game.modal._.is(":visible") and default_path
    Game.modal.fetch default_path
    window.history.pushState {}, "Title", default_path
    Game.modal.show()

Game.modal.changeActive = ->
  if Game.modal.current
    Game.modal.current.removeClass "active"
  Game.modal.current = $("#navbar a[href='" + window.location.pathname + "']").parent()
  Game.modal.current.addClass "active"

Game.modal.click = (e) ->
  element = $ e.currentTarget
  if element.is "a"
    link = element
  else
    link = element.find "a:last"
  path = $(link).attr("href")
  if path != "" and path != window.location.pathname
    if link.data("method")
      true
    else if element.hasClass("active")
      false
    else
      Game.modal.fetch path
      Game.modal.show()
      window.history.pushState {}, "Title", path
      false

Game.modal.fetch = (url) ->
  if url
    $.ajax(
      type: "GET"
      url: url
      success: (data) ->
        Game.modal._.html(data)
    )

Game.modal.show = ->
  Game.modal.changeActive()
  Game.modal._.show()
  Game.modal.overlay.show()

Game.modal.hide = ->
  window.history.pushState {}, "Home", "/"
  Game.modal.changeActive()
  Game.modal._.hide()
  Game.modal.overlay.hide()
