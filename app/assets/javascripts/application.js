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

var messageElement = function() {
  var divMessage = document.createElement('div');
  divMessage.textContent = 'You have to select at least one box';
  divMessage.setAttribute('class', 'alert alert-danger message');

  var closeButton = document.createElement('a');
  closeButton.innerHTML= "&#215;";
  closeButton.setAttribute('class', 'close');
  closeButton.setAttribute('data-dismiss', 'alert');

  divMessage.appendChild(closeButton);

  return divMessage;
}

$(function() {
  var divMessage = messageElement();
  var $flashMessage = $('.flash-messages');

  $(".bulk-action input[type='submit']").on('click', function(e) {
    $flashMessage.empty();

    var numberCheckedBox = $("input:checked").length;
    if (!numberCheckedBox) {
      e.preventDefault();
      $flashMessage.append(divMessage);
    } else {
      //fix this.value to this.name after change name for button
      var $submitButton = $('#button_name'),
          dataButtonName = this.getAttribute('data-button-name');
      $submitButton.attr('value', dataButtonName);

      if (dataButtonName === 'deactive') {
        var result = window.confirm('Are you sure?');
        if (!result) {
          e.preventDefault();
        }
      }
    }
  });

});


