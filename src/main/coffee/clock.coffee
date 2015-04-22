resize = (box) ->
  windowWidth = $(window).width()
  windowHeight = $(window).height()
  scaleX = windowWidth / box.width()
  scaleY = windowHeight / box.height()
  scale = Math.min(scaleX, scaleY)
  fitWidth = box.width() * scale
  fitHeight = box.height() * scale
  top  = (windowHeight - fitHeight) / scale / 2
  left = (windowWidth  - fitWidth ) / scale / 2
  box.css(
    zoom: scale
    '-moz-transform': 'translate(-50%,-50%) scale(' + scale + ') translate(50%,50%)'
    marginTop: top
    marginLeft: left
  )

clock = new Vue(
  el: '#demo'
  data: {
    moment: moment()
    lists: null
    pinnedId: null
  }
  computed: {
    hour: {
      get: ->
        this.moment.local().format('HH')
    },
    minute: {
      get: ->
        this.moment.local().format('mm')
    },
    colonVisibility: {
      get: ->
        this.moment.local().second() % 2 == 0 ? 'visible' : 'hidden'
    },
    current: {
      get: ->
        lists = this.lists
        return null if(lists == null)
        return this.pinned() if this.pinnedId != ""
        number = (Math.floor(this.moment.unix() / 60)) % lists.length
        lists[number]
    }
  }
  watch: {
    current: (newValue, oldValue) ->
      return if newValue == undefined
      if oldValue == null
        console.log("new to " + newValue.id)
        return this.refresh(newValue)

      unless oldValue.id == newValue.id
        console.log("change from " + oldValue.id + " to " + newValue.id)
        this.refresh(newValue)
  }
  methods: {
    loadLists: ->
      $data = this.$data
      $.get("/data.json").done (data) ->
        $data.lists = JSON.parse(data)


    refreshMoment: ->
      this.moment = moment()

    refresh: (data) ->
      console.log("refresh!!! " + data.id);
      box = $("#clock-box")
      box.fadeOut()
      $('img.clock-image').remove()

      image = new Image()
      image.src = data.url

      image.onload = ->
        boundingWidth = 1024
        boundingHeight = 1024

        originalWidth = image.width
        originalHeight = image.height

        scaleX = boundingWidth / originalWidth
        scaleY = boundingHeight / originalHeight
        scale = Math.min(scaleX, scaleY)
        fitWidth = originalWidth * scale
        fitHeight = originalHeight * scale

        console.log(fitWidth + "," + fitHeight)

        $(image).css(
          top: 0
          left: 0
          width: fitWidth
          height: fitHeight
        )

        $(image).addClass("clock-image")

        box.append(image)
        box.width(fitWidth).height(fitHeight)
        resize(box)
        box.fadeIn()
  }
)


clock.loadLists()

id = location.hash.replace(/^#/, '')
clock.pinnedId = id

setInterval ->
  clock.refreshMoment();
, 1000

$(window).resize ->
  resize($('#clock-box'))