import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 
    "filter", 
    "filters", 
    "allContacts", 
    "contactCard", 
    "contactSearch",
    "emptySearch"
  ]

  connect() {
    if(typeof localStorage.selectedFilterTab === 'undefined') {
      localStorage.setItem("selectedFilterTab", this.filterTarget.dataset.tab)
    } else {
      if(localStorage.selectedFilterTab === this.filterTarget.dataset.tab) {
        this.showFilters()
      } else {
        this.showContacts()
      }
    }
  }

  search() {
    let searchTerm = this.contactSearchTarget.value.toLowerCase()
    let selectedCards = []
    let rejectedCards = []
    this.contactCardTargets.forEach(card => {

      if(card.dataset.firstName.includes(searchTerm)) {
        selectedCards.push(card)
      }
      if(card.dataset.lastName.includes(searchTerm)) {
        selectedCards.push(card)
      }
      if(card.dataset.fullName.includes(searchTerm)) {
        selectedCards.push(card)
      }
      JSON.parse(card.dataset.groups).forEach(group => {
        if(group.includes(searchTerm)) {
          selectedCards.push(card)
        }
      })
      JSON.parse(card.dataset.tags).forEach(group => {
        if(group.includes(searchTerm)) {
          selectedCards.push(card)
        }
      })
      if(!selectedCards.includes(card)) {
        rejectedCards.push(card)
      }
    })
    rejectedCards.forEach(card => {
      card.classList.add("transition-out-style")
      this.sleep(300).then(()=> {
        card.classList.add("hidden")
        card.classList.remove("transition-out-style")
      })
    })
    selectedCards.forEach(card => {
      card.classList.add("transition-in-style")
      this.sleep(300).then(()=> {
        card.classList.remove("hidden")
        card.classList.remove("transition-in-style")
      })
    })
    this.showOrHideEmptySearchDiv(selectedCards.length)
  }
  sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  showOrHideEmptySearchDiv(resultsLength) {
    if(resultsLength === 0) {
      this.emptySearchTarget.classList.remove("hidden")
    } else {
      this.emptySearchTarget.classList.add("hidden")
    }
  }

  showContacts() {
    this.filterTarget.classList.remove("active")
    this.filtersTarget.classList.add("hidden")
    this.allContactsTarget.classList.add("active")
    localStorage.setItem("selectedFilterTab", this.allContactsTarget.dataset.tab)
    this.contactCardTargets.forEach(card => {
      card.classList.remove("hidden")
      this.contactSearchTarget.value = ''
    })
  }
  showFilters() {
    this.filterTarget.classList.add("active")
    this.filtersTarget.classList.remove("hidden")
    this.allContactsTarget.classList.remove("active")
    localStorage.setItem("selectedFilterTab", this.filterTarget.dataset.tab)
  }

  filterUnique(array) {
    return array.filter(function(item, pos){
      return array.indexOf(item)== pos; 
    });
  }
}