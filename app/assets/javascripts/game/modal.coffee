Game.modal = Game.modal || {}

Game.modal.init = ->
  $("li").bind("click", Game.modal.click)
  Game.modal.changeActive()
  $(document).keyup (e) ->
    if e.keyCode == 27
      Game.modal.hide()

Game.modal.changeActive = ->
  if Game.modal.current
    Game.modal.current.removeClass "active"
  Game.modal.current = $("#navbar a[href='" + window.location.pathname + "']").parent()
  Game.modal.current.addClass "active"

Game.modal.click = (e) ->
  element = $ e.currentTarget
  link = element.find "a:last"
  path = $(link).attr("href")
  if path != "" and path != window.location.pathname
    if not element.hasClass("active")
      Game.modal.fetch path
      window.history.pushState {}, "Title", path
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
  Game.modal.changeActive()
  $("#modal").show()
  $("#modal-overlay").show()

Game.modal.hide = ->
  window.history.pushState {}, "Home", "/"
  Game.modal.changeActive()
  $("#modal").hide()
  $("#modal-overlay").hide()
