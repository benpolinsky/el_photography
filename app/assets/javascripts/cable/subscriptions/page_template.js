  ready(function () {
    if (document.querySelector('.live_code_editor') !== null) {
      var page_template_id = $('input#page_template_id').val();
      App.cable.subscriptions.create({
          channel: "PageTemplatesChannel",
          id: page_template_id
        },
        {
          // connected: function () {
          // },
          // rejected: function () {
          // },
          received: function (data) {
            $('#live-code-frame').contents().find('body .container.elp-container.center').html(data["page_template_code"]);
            if ($('#live-code-frame').contents().find('style#live-styles').length > 0) {
              $('#live-code-frame').contents().find('style#live-styles').html(data["css_template_code"]);              
            } else {
              $('#live-code-frame').contents().find('head').append("<style type='text/css' id='live-styles'>"+data['css_template_code']+"</style>");
            }

          }
        }
      )  
    
      var timer = null

      document.querySelectorAll('.live_code_editor').forEach(function (item, i) {
      item.addEventListener("keydown", function () {
        clearTimeout(timer);
        timer = setTimeout(function () {
          send_off(page_template_id);
        }, 1000);
      })
      }) 
    
      document.addEventListener("keydown", function (e) {
        if((event.ctrlKey || event.metaKey) && event.which == 83) {
           // Save Function
         
           console.log('saving!'); // perhaps append saving dealy
           send_off(page_template_id);  
           clearTimeout(timer);
           event.preventDefault();
           return false;
        }
      })      
    }

  });


  



function ready(fn) {
  if (document.readyState != 'loading') {
    fn();
  } else {
    document.addEventListener("DOMContentLoaded", fn);
  }
}


// add page id
function send_off(id) {
  $.ajax({
    url: '/admin/page_templates/' + id + '/live_update',
    data: {
      page_template: {
        title: $('form.edit_page_template').find('input#page_template_title').val(),
        body: document.querySelector("textarea#ace-populate").textContent
      },
      css_template: {
        body: document.querySelector("textarea#css-populate").textContent
      }
    },
    type: "PATCH",
    complete: function () {

    }
  })

}