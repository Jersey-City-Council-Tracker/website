import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["councilMember", "voteFilterWrapper", "votePosition"]

  connect() {
    this.toggleVoteFilter()
  }

  toggleVoteFilter() {
    const hasSelection = this.councilMemberTarget.value !== ""

    if (hasSelection) {
      this.voteFilterWrapperTarget.style.display = ""
    } else {
      this.voteFilterWrapperTarget.style.display = "none"
      this.votePositionTarget.value = ""
    }
  }
}
