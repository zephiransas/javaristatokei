var resize = function(box) {
  var windowWidth = $(window).width();
  var windowHeight = $(window).height();
  var scaleX = windowWidth / box.width();
  var scaleY = windowHeight / box.height();
  var scale = Math.min(scaleX, scaleY);
  var fitWidth = box.width() * scale;
  var fitHeight = box.height() * scale;
  var top  = (windowHeight - fitHeight) / scale / 2;
  var left = (windowWidth  - fitWidth ) / scale / 2;
  box.css({
    zoom: scale,
    '-moz-transform': 'translate(-50%,-50%) scale(' + scale + ') translate(50%,50%)',
    marginTop: top,
    marginLeft: left
  })
};

var clock = new Vue({
  el: '#demo',
  data: {
    moment: moment(),
    lists: null,
    pinnedId: null
  },
  computed: {
    hour: {
      get: function(){
        return this.moment.local().format('HH');
      }
    },
    minute: {
      get: function(){
        return this.moment.local().format('mm');
      }
    },
    colonVisibility: {
      get: function() {
        return this.moment.local().second() % 2 === 0 ? 'visible' : 'hidden';
      }
    },
    current: {
      get: function() {
        var lists = this.lists;
        if(lists == null) return null;

        if(this.pinnedId != "") {
          return this.pinned();
        }
        var number = (Math.floor(this.moment.unix() / 60)) % lists.length;
        return lists[number];
      }
    }
  },
  watch: {
    current: function(newValue, oldValue){
      if(newValue == undefined) return;
      if(oldValue == null) {
        console.log("new to " + newValue.id)
        this.refresh(newValue);
        return;
      }
      if(oldValue.id != newValue.id) {
        this.refresh(newValue);
        console.log("change from " + oldValue.id + " to " + newValue.id)
      }
    }
  },
  methods: {
    loadLists: function() {
      var $data = this.$data;
      $.get("/data.json").done(function(data){
        $data.lists = JSON.parse(data);
      });
    },
    refreshMoment: function(){
      this.moment = moment();
    },
    refresh: function(data) {
      console.log("refresh!!! " + data.id);

      var box = $("#clock-box");
      box.fadeOut();
      $('img.clock-image').remove();

      var image = new Image();
      image.src = data.url;

      image.onload = function() {
        var boundingWidth = 1024;
        var boundingHeight = 1024;

        var originalWidth = image.width;
        var originalHeight = image.height;

        var scaleX = boundingWidth / originalWidth;
        var scaleY = boundingHeight / originalHeight;
        var scale = Math.min(scaleX, scaleY);
        var fitWidth = originalWidth * scale;
        var fitHeight = originalHeight * scale;

        console.log(fitWidth + "," + fitHeight);

        $(image).css({
          top: 0,
          left: 0,
          width: fitWidth,
          height: fitHeight
        });

        $(image).addClass("clock-image");

        box.append(image);
        box.width(fitWidth).height(fitHeight);
        resize(box);
        box.fadeIn();
      };
    },
    pinned: function() {
      var lists = this.lists;
      var pinnedId = this.pinnedId;
      for (var i = 0; i < lists.length; i++) {
        if (lists[i].id == pinnedId) return lists[i];
      }
      return null;
    }
  }
})

clock.loadLists();

var id = location.hash.replace(/^#/, '');
clock.pinnedId = id;

setInterval(function(){
  clock.refreshMoment();
}, 1000);

$(window).resize(function() {
  resize($('#clock-box'));
});