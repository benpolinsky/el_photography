module.exports = {
  start: function () {
    $('span.loader').addClass('active');      
  },
  
  stop: function () {
    $('span.loader').removeClass('active');
  }
}