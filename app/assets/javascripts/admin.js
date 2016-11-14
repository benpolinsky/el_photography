// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require best_in_place
//= require jquery_ujs
//= require jquery-ui
//= require sortable
//= require tether
//= require bootstrap
//= require dropzone
//= require admin/dropzone.js
//= require selectize
//= require ace-rails-ap
//= require ace/ext-language_tools.js
//= require ace/theme-twilight
//= require ace/mode-liquid
//= require ace/mode-css
//= require ace/mode-html
//= require admin/update_row_order
//= require flatpickr.min
//= require admin/general
//= require admin/forms
//= require bp_custom_fields
//= require split
//= require tether.min
//= require_tree ./channels
//= require_tree .

$(document).ready(function(){
  $('tbody[data-role=activerecord_sortable]').activerecord_sortable({
      axis: 'y',
      items: '.row-item',
       cursor: 'move',
      handle: '.handle'
  });
  
  $('.big-grid[data-role=activerecord_sortable]').activerecord_sortable({
      axis: '',
      items: '.row-item',
      cursor: 'move'
  });
});