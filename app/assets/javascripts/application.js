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
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//require turbolinks
//= require_tree .

$(function() {

  $(".bulk-action input[type='submit']").on('click', function(e) {
    var numberCheckedBox = $("input:checked").length;
    if (!numberCheckedBox) {
      alert('You have to check at least one box');
    } else {
      if (this.value === 'Delete') {
        var result = window.confirm('Are you sure?');
        if (!result) {
          e.preventDefault();
          location.reload();
        }
      }
    }
  });

});
