// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require_tree .

_.templateSettings = { interpolate : /\{\{(.+?)\}\}/g };

$(function(){
  console.log("I am js");
  
  if($("#js-chat_content").length){
    $('html, body').animate({scrollTop: $(document).height() - $(window).height()}, 1000);
  }
  
  next_user();
});

var next_user = function(){
  var $el = $("#js-candidacy_user");
  
  if($el.length) {
    next();
    new_match();
    yep();
    nope();
  }
}

var next = function(){
  var $el = $("#js-candidacy_user");

  $.ajax({
    type: "GET",
    url: "/match/next",
    success: function(data){
      if(data) {
        var tpl = $("#tpl-candidacy_user").html();
        var out = _.template(tpl);
        _.each(data, function(d){
          $el.append(out(d));
        });
      }
    },
    error: function(data){
      console.error(data);
    }
  });
}
var new_match = function(){
  $.ajax({
    type: "GET",
    url: "/match/new_match",
    success: function(data){
      if(data && data.length > 0) {
        $("#js-new_match").show();
      }
    },
    error: function(data){
      console.error(data);
    }
  });

  $("#js-new_match").on("click touch", function() {
    $(this).hide();
  });
}
var yep = function(){
  var $el = $("#js-candidacy_user");
  var n;

  $(document).on("click touch", "#js-yep", function(){
    $.ajax({
      type: "POST",
      url: "/match/yep",
      data: {
        authenticity_token: $('meta[name=csrf-token]').attr('content'),
        candidacy_user_id: $(this).data("id"),
      },
      success: function(data){
        $el.children().first().css({"left": "150%"});
        if(n = $el.children().get(1)){
          $(n).addClass("first");
          window.setTimeout(function(){
            $el.children().first().remove()
          }, 500);
        }
        if($el.children().length <= 5){
          next();
        }
      },
      error: function(data){
        console.error(data);
      }
    });
  });
}
var nope = function(){
  var $el = $("#js-candidacy_user");
  var next;

  $(document).on("click touch", "#js-nope", function(){
    $.ajax({
      type: "POST",
      url: "/match/nope",
      data: {
        authenticity_token: $('meta[name=csrf-token]').attr('content'),
        candidacy_user_id: $(this).data("id"),
      },
      success: function(data){
        $el.children().first().css({"left": "-150%"});
        if(n = $el.children().get(1)){
          $(n).addClass("first");
          window.setTimeout(function(){
            $el.children().first().remove()
          }, 500);
        }
        if($el.children().length <= 5){
          next();
        }
      },
      error: function(data){
        console.error(data);
      }
    });    
  });
}