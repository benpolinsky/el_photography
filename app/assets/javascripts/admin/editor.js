function ready(fn) {
  if (document.readyState != 'loading') {
    fn();
  } else {
    document.addEventListener("DOMContentLoaded", fn);
  }
}

ready(function () {
  initialize_editor('ace-editor');
  initialize_editor('css-ace-editor');
  if (document.querySelector('#switch-layout') !== null) {
    Split(['.code_editor_container', '.live_window'], {
        gutterSize: 20,
        sizes: [50, 50],
        minSize: 300
    });
    document.querySelector('#switch-layout').addEventListener('click', function (e) {
      e.preventDefault();
      toggle_view_mode();
    })    
  }

});


function update_text_area(textarea, text) {
  console.log(textarea, text)
  textarea.get(0).textContent = text;
}

function initialize_editor(el) {
  if (document.querySelector("#" + el) !== null) {
    if (document.querySelector("#" + el).dataset.mode == "css") {
      var LiquidMode = ace.require("ace/mode/css").Mode;
    } else {
      var LiquidMode = ace.require("ace/mode/html").Mode;      
    }

    var editor = ace.edit(el);
    editor.setTheme('ace/theme/twilight');
    editor.session.setMode(new LiquidMode());
    editor.setShowPrintMargin(false);
    editor.setBehavioursEnabled(true);
    editor.setWrapBehavioursEnabled(true);
    editor.setOptions({
      enableBasicAutocompletion: true,
      enableSnippets: true,
      enableLiveAutocompletion: false
    });
    
    editor.addEventListener("change", function (e) {
      update_text_area($("#" + el).siblings('textarea'), editor.getValue());
    }) 
  }  
}

function toggle_view_mode(){

  var code_container = document.querySelector('#code-container');
  var current_mode = code_container.dataset.view_mode;
  var toggle_to = current_mode == "vertical" ? "horizontal" : "vertical" 
  var editor_window = code_container.querySelector('.code_editor_container');
  var live_window = code_container.querySelector('.live_window');
  
  if (current_mode !== toggle_to) {
    code_container.dataset.view_mode = toggle_to;
    if (toggle_to == "vertical") {  
      $('.gutter').remove();
      $('.split').css('width', '100%');
      Split(['.code_editor_container', '.live_window'], {
          direction: 'vertical',
          gutterSize: 20
      });
    } else {
      $('.gutter').remove();
      $('.split').css('height', '100%');
      Split(['.code_editor_container', '.live_window'], {
          gutterSize: 20,
          sizes: [50, 50],
          minSize: 300
      });
    }

  }
  
}