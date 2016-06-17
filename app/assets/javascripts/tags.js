function ready(fn) {
  if (document.readyState != 'loading') {
    fn();
  } else {
    document.addEventListener("DOMContentLoaded", fn);
  }
}

ready(function () {
  if (document.querySelector('.back-to-top') !== null) {
    document.querySelector('.back-to-top').addEventListener('click', function (e) {
      e.preventDefault();
      scrollToTop(400);
      return false;
    })    
  }

});

// http://stackoverflow.com/a/24559613/791026
function scrollToTop(scrollDuration) {
  var scrollStep = -window.scrollY / (scrollDuration / 15),
      scrollInterval = setInterval(function(){
      if ( window.scrollY != 0 ) {
          window.scrollBy( 0, scrollStep );
      }
      else clearInterval(scrollInterval); 
  },15);
}