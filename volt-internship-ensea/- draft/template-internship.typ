#import "@preview/glossy:0.8.0": *
#import "@preview/hydra:0.6.2": anchor, hydra

// Global variables
#let HEADING-LVL-1-SPACING = 1.5em
#let HEADING-LVL-2-SPACING = 1.25em
#let HEADING-LVL-3-SPACING = 1em

#let ROSE-ENSEA = rgb("A6004C")

// ============================
// ABSTRACT CONFIGURATION
// ============================

#let abstract-config(language: none, doc) = {
  if language == "FRENCH" {
    block(
      fill: none,
      stroke: rgb("CCCCCC"),
      inset: 8pt,
      outset: 5pt,
      radius: 10pt,
      [#heading(numbering: none, outlined: false)[Résumé]
        #doc],
    )
  } else if language == "ENGLISH" {
    block(
      fill: rgb("EEEEEE"),
      stroke: none,
      inset: 8pt,
      outset: 5pt,
      radius: 10pt,
      [#heading(numbering: none, outlined: false)[Abstract]
        #doc],
    )
  } else {
    panic("Language must be either 'FRENCH' or 'ENGLISH'")
  }
}

// ============================
// APPENDIX CONFIGURATION
// ============================

#let appendices-config(doc) = {
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
    doc
  }
  show: appendix
}

// ============================
// MAIN CONFIGURATION
// ============================

#let internship(
  // Mandatory variables
  COMPANY-LOGO: none,
  AUTHORS: none,
  STUDENT-INFO: none,
  TITLE: none,
  INTERNSHIP-DETAILS: none,
  // Optional variables
  ENABLE-LIST-FIGURES: true,
  ENABLE-LIST-TABLES: false,
  ENABLE-LIST-APPENDICES: false,
  ENABLE-GLOSSARY: false,
  ENABLE-ABSTRACT: true,
  ENABLE-BIBLIOGRAPHY: true,
  ENABLE-APPENDICES: true,
  // File to import
  ABSTRACT: none,
  ACKNOWLEDGEMENTS: none,
  APPENDICES: none,
  REFERENCES: none,
  body,
) = {
  // Check if all mandatory variables are defined.
  if COMPANY-LOGO == none {
    panic(
      "The `COMPANY-LOGO` variable must be defined. It should be a string representing the path to the company logo.",
    )
  }

  if AUTHORS == none {
    panic(
      "The `AUTHORS` variable must be defined. It should be a list of strings representing the authors of the report.",
    )
  }

  if STUDENT-INFO == none {
    panic(
      "The `STUDENT-INFO` variable must be defined. It should be a string with the student's information.",
    )
  }

  if TITLE == none {
    panic(
      "The `TITLE` variable must be defined. It should be a string representing the title of the report.",
    )
  }

  if INTERNSHIP-DETAILS == none {
    panic(
      "The `INTERNSHIP-DETAILS` variable must be defined. It should be a string describing the details of the internship.",
    )
  }

  set document(author: AUTHORS, title: TITLE)

  set page(paper: "a4", margin: auto, number-align: center)

  // if "weak: true", the page break is skipped if the current page is already empty
  set pagebreak(weak: true)

  set text(font: "New Computer Modern", size: 10pt, lang: "fr", region: "fr")
  // for English: lang: 'en' and region: 'us'
  // For other languages/regions, refer to this page:
  // lang: https://en.wikipedia.org/wiki/ISO_639
  // region: https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2

  // Display links in blue.
  show link: set text(fill: blue.darken(40%))

  set heading(numbering: "I.1.a.")
  show heading: set text(hyphenate: false)
  show heading: set par(justify: false)

  show heading.where(level: 1): set text(fill: ROSE-ENSEA)

  // Config. of the spacing after headings
  show heading.where(level: 1): set block(below: HEADING-LVL-1-SPACING)
  show heading.where(level: 2): set block(below: HEADING-LVL-2-SPACING)
  show heading.where(level: 3): set block(below: HEADING-LVL-3-SPACING)

  // Config. of the spacing after the outline
  show outline: it => {
    show heading: it => it + v(HEADING-LVL-1-SPACING, weak: true)
    it
  }

  show heading: set heading(supplement: "Section")
  show heading.where(level: 1): set heading(supplement: "Chapitre")

  show heading: it => [
    #underline()[#it]
  ]

  show underline: set underline(stroke: 1pt, offset: 2pt)

  set list(indent: 15pt, marker: [--]) // config. of lists

  set math.equation(numbering: "(1)")

  show figure.where(kind: image): set figure(supplement: "Figure")

  // Configure the figure caption alignment:
  // if figure caption has more than one line,
  // it makes it left-aligned
  show figure.caption: it => {
    layout(size => [
      #let text-size = measure(it.supplement + it.separator + it.body)
      #let my-align
      #if text-size.width < size.width {
        my-align = center
      } else {
        my-align = left
      }
      #align(my-align, text(size: 8pt)[#emph(it)])
    ])
  }

  // Configure the raw block properties
  show raw.where(block: true): set par(justify: false)

  // // From the INSA Typst Template by SkytAsul:
  // // https://github.com/SkytAsul/INSA-Typst-Template
  // show raw.line: it => if it.count > 1 {
  //   text(fill: luma(150), str(it.number)) + h(2em) + it.body
  // } else { it }

  // Adapted from the Typst forum:
  // https://forum.typst.app/t/how-to-change-numbering-in-appendix/1716/5
  let BACKMATTER(content) = {
    set heading(numbering: "A.1")
    counter(heading).update(0)
    state("BACKMATTER").update(true)
    content
  }

  set figure(
    numbering: n => {
      let appx = state("BACKMATTER", false).get()
      let hdr = counter(heading).get()
      let format = if appx {
        "A.1"
      } else {
        "1.1"
      }
      let h = if appx {
        hdr.at(0)
      } else {
        hdr.first()
      }
      numbering(format, h, n)
    },
  )

  // Reset figure and table counters to 0 at each level-1 heading
  show heading.where(level: 1): hdr => {
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    hdr
  }

  // First page configuration
  align(center + horizon)[
    #block(text(weight: 700, size: 22pt, [*ENSEA*]))

    #block(
      text(
        weight: 700,
        size: 16pt,
        [*École Nationale Supérieure de l'Électronique et de ses Applications*],
      ),
    )

    #block(
      text(
        weight: 400,
        size: 14pt,
        [Établissement public, sous tutelle du ministère de l'Enseignement Supérieur et de la Recherche #linebreak()
          Habilité par la CTI à délivrer le diplôme d'Ingénieur #linebreak()
          Membre de la Conférence des grandes écoles #linebreak()
          Membre de CY-Alliance],
      ),
    )

    #linebreak()
    #set image(height: 40mm)
    #stack(
      dir: ltr, // left-to-right
      spacing: 5em, // space between contents
      image("assets/logo-ENSEA.png"),
      COMPANY-LOGO,
    )

    #linebreak()
    #block(
      text(
        weight: 700,
        size: 22pt,
        [RAPPORT DE STAGE],
      ),
    )

    #linebreak()
    #block(
      text(
        weight: 700,
        size: 16pt,
        [#(
          AUTHORS.map(strong).join(", ", last: " et ")
        )],
      ),
    )

    #block(text(weight: 400, size: 14pt, STUDENT-INFO))

    #linebreak()
    #block(text(weight: 700, size: 20pt, TITLE))
  ]

  linebreak()
  set par(justify: true)
  block(text(weight: 400, size: 12pt, [#INTERNSHIP-DETAILS]))

  pagebreak()
  // Definition of the following pages with different margins
  set page(
    margin: (top: 70pt, bottom: 1.5cm),
    numbering: "1/1",
    header-ascent: 10pt,
    footer-descent: 10pt,
    header: context [
      // to use #hydra outside of the page header, an #anchor must be placed
      #anchor()

      #set image(height: 12mm)
      #stack(
        dir: ltr,

        align(left + horizon, image("assets/logo-ENSEA.png")),

        align(center + horizon)[
          #text(size: 8pt)[
            #box(width: 75%)[
              #(
                AUTHORS.join(", ", last: " et ")
              ) \
              #TITLE
            ]]
        ],

        align(right + horizon, COMPANY-LOGO),
      )

      #box(width: 100%, height: 1pt, fill: black)
    ],

    footer: context [
      #place(top + left, dy: -5pt, box(width: 100%, height: 1pt, fill: black))

      #stack(
        dir: ltr,

        align(left + top)[#text(size: 8pt)[
          #box(width: 85%)[
            #emph(hydra(1))
          ]
        ]],

        align(right + top)[#text(size: 8pt)[
          #box(width: 8%)[
            #counter(page).display(both: true)
          ]
        ]],
      )
    ],
  )

  // From the Typst forum:
  // https://forum.typst.app/t/how-can-i-switch-from-roman-to-arabic-page-numbers-without-breaking-the-total-page-count/4130
  // set page(
  //   numbering: (..n) => context {
  //     numbering("i/i", n.at(0), ..counter(page).at(<LAST-ROMAN-PAGE>))
  //   },
  // )

  // Acknowledgements configuration
  counter(page).update(1)
  heading(numbering: none, outlined: false)[Remerciements]
  // import "template/acknowledgements.typ": acknowledgements
  ACKNOWLEDGEMENTS

  pagebreak()
  // Contents configuration
  show outline.entry.where(
    // make level 1 headings bold
    level: 1,
  ): it => {
    // only apply to entries that are not for figures or tables
    if it.element.func() == heading {
      v(12pt, weak: true)
      strong(it)
    } else {
      v(12pt, weak: true)
      it
    }
  }
  show outline.entry: set text(hyphenate: false)
  show outline: set par(justify: false)

  if not (ENABLE-LIST-APPENDICES) {
    outline(
      title: [Table des matières],
      indent: 1em,
      // depth: 2,
    )
  } else {
    // From Reddit:
    // https://www.reddit.com/r/typst/comments/1kaqxje/comment/mppn4ie/
    context {
      let qrytarget = heading // ou figure, un label, un sélecteur, etc...
      outline(
        title: [Table des matières],
        indent: 1em,
        // depth: 2,
        target: selector.or(
          ..query(qrytarget)
            .filter(it => it.supplement != [showAppendices])
            .map(it => it.func().where(supplement: it.supplement)),
        ),
      )
    }
  }

  // Figure contents configuration
  if (ENABLE-LIST-FIGURES) {
    pagebreak()
    heading(numbering: none)[Liste des figures]
    v(HEADING-LVL-1-SPACING - 0.5em)
    outline(indent: 1em, title: none, target: figure.where(kind: image))
  }

  // Table contents configuration
  if (ENABLE-LIST-TABLES) {
    pagebreak()
    heading(numbering: none)[Liste des tableaux]
    v(HEADING-LVL-1-SPACING - 0.5em)
    outline(indent: 1em, title: none, target: figure.where(kind: table))
  }

  if (ENABLE-LIST-APPENDICES) and (ENABLE-APPENDICES) {
    pagebreak()
    heading(numbering: none)[Liste des annexes]
    v(HEADING-LVL-1-SPACING - 0.5em)
    outline(
      indent: 1em,
      title: none,
      target: heading.where(supplement: [showAppendices]),
    )
  }

  // Glossary configuration
  let my-theme = (
    // Adapted from theme-basic:
    // Renders the main glossary section as a single column
    // Parameters:
    //   title: The glossary section title
    //   body: Content containing all groups and entries
    section: (title, body) => {
      heading(level: 1, title, numbering: none)
      body
    },
    // Renders a group of related glossary terms
    // Parameters:
    //   name: Group name (empty string for ungrouped terms)
    //   index: Zero-based group index
    //   total: Total number of groups
    //   body: Content containing the group's entries
    group: (name, index, total, body) => {
      if name != "" and total > 1 {
        heading(level: 2, name)
      }
      body
    },
    // Renders a single glossary entry with term, definition, and page references
    // Parameters:
    //   entry: Dictionary containing term data:
    //     - short: Short form of term
    //     - long: Long form of term (optional)
    //     - description: Term description (optional)
    //     - label: Term's dictionary label
    //     - pages: Linked page numbers where term appears
    //   index: Zero-based entry index within group
    //   total: Total entries in group
    entry: (entry, index, total) => {
      // Format the term parts
      let term = text(weight: "bold", entry.short)
      let long-form = if entry.long == none {
        [ ]
      } else {
        [ (#entry.long) ]
      }

      // Format the description with proper spacing
      let description = if entry.description == none {
        []
      } else {
        [: #entry.description]
      }

      // Create the complete entry with hanging indent
      block(
        below: 0.5em,
        pad(
          left: 1em,
          bottom: 0.5em,
          block([#term#entry.label#long-form#description]),
        ),
      )
    },
  )

  if (ENABLE-GLOSSARY) {
    pagebreak()
    // From Reddit:
    // https://www.reddit.com/r/typst/comments/18exrv5/comment/kcrdfc3/
    set heading(
      numbering: (..nums) => {
        // Get the position of the title in the hierarchy
        let nums = nums.pos()

        let level = nums.len() - 1

        // Indentation could be calculated based on the level
        // let indent = level * 1em

        // Define the number to display based on the position in the hierarchy
        let num = nums.last()

        let style = ("1.", "a)").at(level)

        numbering(style, num)
      },
    )
    glossary(
      title: "Glossaire",
      theme: my-theme,
      sort: true,
      ignore-case: false,
      // show-all: true,
    )
  }

  if (ENABLE-ABSTRACT) {
    pagebreak()
    heading(outlined: false, numbering: none)[] // to avoid Hydra(1) in the footer
    // import "template/abstract.typ": abstract
    ABSTRACT
  }

  // From the Typst forum:
  // https://forum.typst.app/t/how-can-i-switch-from-roman-to-arabic-page-numbers-without-breaking-the-total-page-count/4130
  [#metadata("LAST-ROMAN-PAGE") <LAST-ROMAN-PAGE>]
  pagebreak()
  // counter(page).update(1)
  set page(numbering: "1/1")

  body

  // Bibliography configuration
  if (ENABLE-BIBLIOGRAPHY) {
    pagebreak()
    set par(justify: false)
    show bibliography: set heading(numbering: "I.1.a.")
    // bibliography("template/references.bib", full: true)
    REFERENCES
  }

  // Appendices configuration
  if (ENABLE-APPENDICES) {
    pagebreak()
    show: BACKMATTER // to change numbering style in Appendix
    // import "template/appendices.typ": annexes
    appendices-config(APPENDICES)
  }
}
