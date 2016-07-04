jQuery(document).ready(function() {
  $('select.change-photo-size').change(function(event) {
    var prefix = "changed_";
    var classes = $('.changeable-grid')[0].className.split(" ").filter(function(c) {
        return c.lastIndexOf(prefix, 0) !== 0;
    });
    $('.changeable-grid')[0].className = classes.join(" ").trim();
    $('.changeable-grid').addClass('changed_' + $(this).val());
  });
});
