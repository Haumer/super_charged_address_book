import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="color"
export default class extends Controller {
  connect() {
    let colors = document.querySelectorAll(".tag-item")
    colors.forEach(color => {
      let label = color.querySelector("label")
      let input = color.querySelector("input")
      label.style.backgroundColor = input.value
      if(this.shouldInvertColors(input.value)) {
        label.style.color = "white"
      }
    })
  }

  shouldInvertColors(color) {
    let textWhiteColors = [
      "#74121D", 
      "#414770", 
      "#372248", 
      "#345995"
    ]
    return textWhiteColors.includes(color)
  }
}
