function ready(fn) {
  if (document.readyState != 'loading') {
    fn();
  } else {
    document.addEventListener("DOMContentLoaded", fn);
  }
}

ready(function () {
  if (document.querySelector('#ace-editor') !== null) {
    if (document.querySelector('#ace-editor').dataset.mode == "css") {
      var LiquidMode = ace.require("ace/mode/css").Mode;
    } else {
      var LiquidMode = ace.require("ace/mode/liquid").Mode;      
    }

    var editor = ace.edit("ace-editor");
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
      update_text_area(editor.getValue());
    }) 
  }  
});


function update_text_area(text) {
  document.querySelector("textarea#ace-populate").textContent = text;
}