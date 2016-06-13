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
      $('.page-template-code-container').html(data["page_template_code"]);
    }
  }
)

function ready(fn) {
  if (document.readyState != 'loading') {
    fn();
  } else {
    document.addEventListener("DOMContentLoaded", fn);
  }
}

ready(function () {
  var timer = null
  document.querySelector('.live_code_editor').addEventListener("keydown", function () {
    clearTimeout(timer)
    timer = setTimeout(send_off, 1000)
  })
});


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