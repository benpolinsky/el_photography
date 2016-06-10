class Loader {
  constructor(element){
    this.element = document.body;
    this.id = new Date().getTime();
    this.append_template();
  }
  loader_element(){
    this.the_element = document.getElementById(this.id);
  }
  start() {
    this.the_element.classList.add('active');
  }
  stop(){
    loader_element().classList.remove('active');
  }
  append_template(){
    let parent = this.element;
    var template = document.createElement("span");
    template.classList.add('loader', 'fa', 'fa-spinner', 'fa-spin');
    parent.appendChild(template);
  }
}

module.exports = Loader