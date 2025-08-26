// ============================
// CONFIGURATION
// ============================

#let annexes() = {
  counter(heading).update(0)

  // I hope no one will use the 'supplement' option for appendices ^_^
  show heading.where(level: 1): set heading(supplement: "showAppendices")

  // From the Polytechnique Typst Template by remigerme:
  // https://github.com/remigerme/typst-polytechnique
  let appendix(body, title: "Annexe") = {
    // From https://github.com/typst/typst/discussions/3630
    set heading(
      numbering: (..nums) => {
        let vals = nums.pos()
        let s = ""
        if vals.len() == 1 {
          s += title + " "
        }
        s += numbering("A.1.", ..vals)
        s
      },
    )
    body
  }

  show: appendix

  text[
    // ============================
    // START HERE
    // ============================

    = Une figure pour illustrer les "Annexes"
    #figure(image("media/logo.png", width: 25%), caption: [Logo générique])

    // ============================
    // STOP HERE
    // ============================
  ]
}
