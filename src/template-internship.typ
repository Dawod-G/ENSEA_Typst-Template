// edited on 06/07/2025

#import "@preview/glossy:0.8.0": *
#import "@preview/hydra:0.6.1": anchor, hydra

// ============================
// CONFIGURATION
// ============================

#let internship(
  // Mandatory variable
  companyLogo: none,
  authors: none,
  studentInfo: none,
  title: none,
  internshipDetails: none,
  // Optional variable
  enableListOfFigures: true,
  enableListOfTables: false,
  enableListOfAppendices: false,
  enableGlossary: false,
  enableBibliography: true,
  enableAppendices: true,
  body,
) = {
  // Check if all mandatory variables are defined.
  if companyLogo == none {
    panic(
      "The `companyLogo` variable must be defined. It should be a string representing the path to the company logo.",
    )
  }

  if authors == none {
    panic(
      "The `authors` variable must be defined. It should be a list of strings representing the authors of the report.",
    )
  }

  if studentInfo == none {
    panic(
      "The `studentInfo` variable must be defined. It should be a string with the student's information.",
    )
  }

  if title == none {
    panic(
      "The `title` variable must be defined. It should be a string representing the title of the report.",
    )
  }

  if internshipDetails == none {
    panic(
      "The `internshipDetails` variable must be defined. It should be a string describing the details of the internship.",
    )
  }

  set document(author: authors, title: title)

  set page(paper: "a4", margin: auto, number-align: center)

  // if "weak: true", the page break is skipped if the current page is already empty
  set pagebreak(weak: true)

  set text(font: "New Computer Modern", size: 12pt, lang: "fr", region: "fr")
  // for English: lang: 'en' and region: 'us'
  // For other languages/regions, refer to this page:
  // lang: https://en.wikipedia.org/wiki/ISO_639
  // region: https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2

  // Display links in blue
  show link: set text(fill: blue.darken(40%))

  set heading(numbering: "I.1.a.")
  show heading: set text(hyphenate: false)
  show heading: set par(justify: false)

  show heading.where(level: 1): set text(fill: rgb("A6004C"))

  // TEMP
  // Config. of the spacing after headings
  show heading.where(level: 1): set block(spacing: 1.5em)
  show heading.where(level: 2): set block(spacing: 1em)
  show heading.where(level: 3): set block(spacing: 0.75em)

  let outline-spacing = 1em

  set list(indent: 15pt, marker: [--])

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
      #align(my-align, it)
    ])
  }

  // Configure the raw block properties
  show raw.where(block: true): set par(justify: false)

  // From the INSA Typst Template by SkytAsul:
  // https://github.com/SkytAsul/INSA-Typst-Template
  show raw.line: it => if it.count > 1 {
    text(fill: luma(150), str(it.number)) + h(2em) + it.body
  } else { it }

  // Adapted from the Typst forum:
  // https://forum.typst.app/t/how-to-change-numbering-in-appendix/1716/5
  let backmatter(content) = {
    set heading(numbering: "A.1")
    counter(heading).update(0)
    state("backmatter").update(true)
    content
  }

  set figure(numbering: n => {
    let appx = state("backmatter", false).get()
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
  })

  // Reset figure and table counters to 0 at each level-1 heading
  show heading.where(level: 1): hdr => {
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    hdr
  }

  // First page configuration
  align(center + horizon)[
    #block(text(weight: 700, size: 22pt, [*ENSEA*]))

    #block(text(
      weight: 700,
      size: 16pt,
      [*École Nationale Supérieure de l'Électronique et de ses Applications*],
    ))

    #block(
      text(
        weight: 400,
        size: 14pt,
        [Établissement public, sous tutelle du ministère de l'Enseignement Supérieur et de la Recherche #linebreak()
          Habilité par la CTI à délivrer le diplôme d’Ingénieur #linebreak()
          Membre de la Conférence des grandes écoles #linebreak()
          Membre de CY-Alliance],
      ),
    )

    #linebreak()
    #stack(
      dir: ltr, // left-to-right
      spacing: 5em, // space between contents
      image("assets/logo-ENSEA.jpg", height: 42mm),
      image(companyLogo, height: 42mm),
    )

    #linebreak()
    #block(text(
      weight: 700,
      size: 22pt,
      [RAPPORT DE STAGE],
    ))

    #linebreak()
    #block(text(
      weight: 700,
      size: 16pt,
      [#(
          authors.map(strong).join(", ", last: " et ")
        )],
    ))

    #block(text(weight: 400, size: 14pt, studentInfo))

    #linebreak()
    #block(text(weight: 700, size: 19pt, title))
  ]

  linebreak()
  set par(justify: true)
  block(text(weight: 400, [#internshipDetails]))

  pagebreak()
  // Definition of the following pages with different margins
  set page(
    margin: (top: 80pt, bottom: 1.5cm),
    numbering: "1/1",
    header-ascent: 10pt,
    footer-descent: 10pt,
    header: context [
      // to use #hydra outside of the page header, an #anchor must be placed
      #anchor()

      #stack(
        dir: ltr,

        align(left + horizon, image("assets/logo-ENSEA.jpg", height: 14mm)),

        align(center + horizon)[
          #text(size: 10pt)[
            #box(width: 75%)[
              #title
            ]]
        ],

        align(right + horizon, image(companyLogo, height: 14mm)),
      )

      #box(width: 100%, height: 1pt, fill: black)
    ],

    footer: context [
      #place(top + left, dy: -5pt, box(width: 100%, height: 1pt, fill: black))

      // IS NOT alternateFooter
      // margin: (bottom: 2.5cm),
      // footer-descent: 10pt,
      // #show link: set text(fill: luma(0%))
      // #stack(
      //         dir: ltr,

      //         align(left + top)[#text(size: 10pt)[
      //             #box(width: 85%)[
      //               *École Nationale Supérieure de l’Électronique et de ses Applications* #linebreak()
      //               6, avenue du Ponceau • CS20707 Cergy • 95014 Cergy-Pontoise Cedex • France #linebreak()
      //               #link("tel:+33130736666")[+33 (0)1 30 73 66 66] • #link("www.ensea.fr")[www.ensea.fr]
      //             ]
      //           ]],

      //         align(right + top)[#text(size: 10pt)[
      //             #box(width: 8%)[
      //               #counter(page).display(both: true)
      //             ]
      //           ]],
      //       )


      // IS alternateFooter
      // margin: (bottom: 1.5cm),
      // footer-descent: 10pt,

      #stack(
        dir: ltr,

        align(left + top)[#text(size: 10pt)[
            #box(width: 85%)[
              #emph(hydra(1))
            ]
          ]],

        align(right + top)[#text(size: 10pt)[
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
  //     numbering("i/i", n.at(0), ..counter(page).at(<last-roman-page>))
  //   },
  // )

  // Acknowledgements configuration
  counter(page).update(1)
  heading(numbering: none, outlined: false)[Remerciements]
  import "template/acknowledgements.typ": remerciements
  remerciements()

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

  if not (enableListOfAppendices) {
    outline(
      title: [Table des matières #v(outline-spacing)],
      indent: 1em,
      // depth: 2,
    )
  } else {
    // From Reddit:
    // https://www.reddit.com/r/typst/comments/1kaqxje/comment/mppn4ie/
    context {
      let qrytarget = heading // ou figure, un label, un sélecteur, etc...
      outline(
        title: [Table des matières #v(outline-spacing)],
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
  if (enableListOfFigures) {
    pagebreak()
    heading(numbering: none)[Liste des figures]
    v(outline-spacing)
    outline(indent: 1em, title: none, target: figure.where(kind: image))
  }

  // Table contents configuration
  if (enableListOfTables) {
    pagebreak()
    heading(numbering: none)[Liste des tableaux]
    v(outline-spacing)
    outline(indent: 1em, title: none, target: figure.where(kind: table))
  }

  if (enableListOfAppendices) and (enableAppendices) {
    pagebreak()
    heading(numbering: none)[Liste des annexes]
    v(outline-spacing)
    outline(
      indent: 1em,
      title: none,
      target: heading.where(supplement: [showAppendices]),
    )
  }

  // From the Typst forum:
  // https://forum.typst.app/t/how-can-i-switch-from-roman-to-arabic-page-numbers-without-breaking-the-total-page-count/4130
  [#metadata("last-roman-page") <last-roman-page>]
  pagebreak()
  // counter(page).update(1)
  set page(numbering: "1/1")

  body

  // Glossary configuration
  let my-theme = (
    // Adapted from theme-basic:
    // Renders the main glossary section as a single column
    // Parameters:
    //   title: The glossary section title
    //   body: Content containing all groups and entries
    section: (title, body) => {
      heading(level: 1, title)
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
        spacing: 0.5em,
        pad(
          left: 1em,
          bottom: 0.5em,
          block([#term#entry.label#long-form#description]),
        ),
      )
    },
  )

  if (enableGlossary) {
    pagebreak()
    glossary(
      title: "Glossaire",
      theme: my-theme,
      sort: true,
      ignore-case: false,
      // show-all: true,
    )
  }

  // Bibliography configuration
  if (enableBibliography) {
    pagebreak()
    set par(justify: false)
    show bibliography: set heading(numbering: "I.1.a.")
    bibliography("template/references.bib", full: true)
  }

  // Appendices configuration
  if (enableAppendices) {
    pagebreak()
    show: backmatter // to change numbering style in Appendix
    import "template/appendices.typ": annexes
    annexes()
  }
}
