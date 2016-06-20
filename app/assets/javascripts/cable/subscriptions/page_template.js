  ready(function () {
    if (document.querySelector('.live_code_editor') !== null) {
      
      App.cable.subscriptions.create({
          channel: "PageTemplatesChannel",
          id: 1
        },
        {
          connected: function () {
            console.log('we are connected');
          },
          rejected: function () {
            console.log('rejected?');
          },
          received: function (data) {
            console.log('data received');
            $('#live-code-frame').contents().find('body .container.elp-container.center').html(data["page_template_code"]);
          }
        }
      )  
    
      var timer = null
      document.querySelector('.live_code_editor').addEventListener("keydown", function () {
        clearTimeout(timer)
        timer = setTimeout(send_off, 1000)
      })
    
      document.addEventListener("keydown", function (e) {
        if((event.ctrlKey || event.metaKey) && event.which == 83) {
           // Save Function
         
           console.log('save');
           send_off();  
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
function send_off() {
  $.ajax({
    url: 'http://localhost:3000/admin/page_templates/1/live_update',
    data: {
      page_template: {
        title: $('form.edit_page_template').find('input#page_template_title').val(),
        body: document.querySelector("textarea#ace-populate").textContent
      }
    },
    type: "PATCH",
    complete: function () {

    }
  })

}