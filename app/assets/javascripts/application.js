// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require common
//= require live-comment-preview
//= require js-sdk-pro.min
//= require headroom
//= require jQuery.headroom
//= require_self

$(document).ready(function() {
  // headroom初始化: http://wicky.nillia.ms/headroom.js/
  $(".navbar").headroom({
    "offset": 35,
    "tolerance": {
      "up": 30,
      "down": 0
    },
    "classes": {
      "initial": "animated",
      "pinned": "slideDown",
      "unpinned": "slideUp"
    }
  });
});
