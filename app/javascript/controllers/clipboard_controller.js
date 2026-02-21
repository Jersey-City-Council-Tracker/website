import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { text: String }
  static targets = ["button"]

  async copy() {
    await navigator.clipboard.writeText(this.textValue)

    const button = this.buttonTarget
    const original = button.innerHTML
    button.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" class="h-3.5 w-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7" /></svg> Copied!`

    setTimeout(() => { button.innerHTML = original }, 2000)
  }
}
