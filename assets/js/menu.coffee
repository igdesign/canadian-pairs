this.clickHandler = ->
  event.preventDefault();

menuParents = document.getElementsByClassName('__nav-parent')

for i in [0..menuParents.length - 1] by 1
  link = (menuParents[i].firstElementChild||menuParents[i].firstChild)
  link.addEventListener "click", (event) => this.clickHandler(event)

  (menuParents[i].firstElementChild||menuParents[i].firstChild).addEventListener "click", () ->
    this.parentNode.classList.toggle('sfHover')