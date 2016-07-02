jQuery(document).ready(function($) {
  var loader = modulejs.require('loader');  
  $(".taggable").selectize({
    delimiter: ",",
    create: true,
    allowEmptyOption: true,
    onBlur: function () {
      var tagList = this.getValue();

      tagList = tagList.length <= 0 ? "" : tagList
      var photo_id = this.$input[0].dataset.id;
      $.ajax({
        method: "PATCH",
        url: getUrl(this),
        dataType: "script",
        data: {
          photo: {
            tag_list: tagList,
            id: photo_id
          }
        }
      })
    }
  });


  

});

function getUrl(el) {
  return el.$input[0].dataset.updateUrl
}