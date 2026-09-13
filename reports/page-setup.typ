#let report(
  title: none,
  authors: (),
  lab-date: none,
  report-date: none,
  body,
) = {
  set document(
    title: title,
    author: authors,
  )

  set page(
    paper: "a4",
    margin: (x: 2.5cm, y: 2cm),
    // fill: black,
    // numbering: "1",
  )

  show link: underline

  set text(
    font: ("Iosevka NF", "New Computer Modern"),
    // fill: white,
    // size: 11pt,
  )

  show math.equation.where(block: true): set text(size: 12pt)

  set par(
    justify: true,
    leading: 0.65em,
  )

  set heading(
    // numbering: "1.1",
  )
  show heading: set block(below: 1em)

  if title != none {
    align(center)[
      #text(
        size: 20pt,
        weight: "bold",
        title,
      )

      #text(
        size: 13pt,
        fill: luma(15%),
        "ECE2200L Section 04, Fall 2026",
      )

      #if authors.len() > 0 [
        // #v(0.4em)
        #text(size: 11pt)[
          #(authors.join(", "))
        ]
      ]

      #text(size: 10pt, fill: luma(40%))[
        #if lab-date != none and report-date != none [
          #lab-date - #report-date
        ] else if lab-date != none [
          // #v(0.4em)
          #lab-date
        ] else if report-date != none [
          // #v(0.4em)
          #report-date
        ]
      ]
    ]

    v(1.5em)
  }

  body
}
