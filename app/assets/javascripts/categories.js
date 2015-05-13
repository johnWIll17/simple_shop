$(function() {
  $('#selectAll').click(function() {
    $checkBox = $(':checkbox');
    if (this.checked) {
       $checkBox.each(function() {
           this.checked = true;
       });
    } else {
       $checkBox.each(function() {
           this.checked = false;
       });
    }
  });
});


