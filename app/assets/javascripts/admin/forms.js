$(document).ready(function() {
  var loader = modulejs.require('loader');
  $('form.patience').on('submit', function(event) {
    if (typeof submitting == 'undefined') {
      loader.start();
      submitting = true;
      $(this).submit();
      return false      
    } else {
      delete submitting;
    }
  });
  
  $(".best_in_place").best_in_place();
  
  var photo_id = '';
  var photo_slug = '';
  var new_auth_token = document.head.querySelector("[name=csrf-token]").content;
  var template = function (photo_id, photo_slug, new_auth_token) {
    return '<form data-remote="true" class="patience" id="edit_photo_' + photo_id + '" action="/admin/photos/' + photo_slug + '" accept-charset="UTF-8" method="post" name="edit_photo_'+ photo_id + '"><input name="utf8" type="hidden" value="✓"><input type="hidden" name="_method" value="patch"><input type="hidden" name="authenticity_token" value="' + new_auth_token + '"> <select name="photo[tag_list][]" class="taggable selectized" multiple="multiple" tabindex="-1" style="display: none;"><option value="add" selected="selected">add</option></select><div class="selectize-control taggable multi"><div class="selectize-input items not-full has-options has-items"><div data-value="add" class="item">add</div><input type="text" autocomplete="off" tabindex="" style="width: 4px; opacity: 1; position: relative; left: 0px;"></div><div class="selectize-dropdown multi taggable" style="display: none; visibility: visible; width: 198px; top: 36px; left: 0px;"><div class="selectize-dropdown-content"><div data-value="new tags" data-selectable="" class="option">new tags</div><div data-value="assss" data-selectable="" class="option">assss</div></div></div></div><input type="submit" name="commit" value="update tags" class="btn btn-sm btn-secondary" data-disable-with="update tags"></form>';
  }
  
});
