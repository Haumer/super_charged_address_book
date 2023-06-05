import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";

export default class extends Controller {
  static targets = [ "selectDate" ]

  connect() {
    this.setWidth()
    flatpickr(this.selectDateTarget, {
      minDate: this.formMinDate(),
      inline: this.isNewReminderForm(),
    })
  }
  isNewReminderForm() {
    return location.pathname.includes("/reminders/new")
  }
  formMinDate() {
    return location.pathname.includes("/contacts") ? new Date(1900, 1, 1) : "today"
  }

  setWidth() {
    let inputWidth = this.selectDateTarget.offsetWidth
    document.head.insertAdjacentHTML("beforeend", 
      `<style>
        .flatpickr-calendar,
        .flatpickr-innerContainer,
        .flatpickr-rContainer,
        .flatpickr-weekdays,
        .flatpickr-days,
        .dayContainer {
          max-width: ${inputWidth}px;
          width:  ${inputWidth}px;
        }
        </style>`
    )
  }
}
