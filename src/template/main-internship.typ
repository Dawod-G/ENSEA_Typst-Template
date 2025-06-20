#import "@preview/glossy:0.8.0": *
#show: init-glossary.with(yaml("glossary.yaml"))

#import "../template-internship.typ": *

// ============================
// VARIABLES TO MODIFY
// ============================

#show: internship.with(
  // Path to the company logo
  companyLogo: "template/media/logo.png",

  // Name(s) of the report author(s)
  authors: (
    "Jean DUPONT",
  ),

  // Information about the student(s)
  studentInfo: [*Élève ingénieur en X#super[ème] année* #linebreak()
    Promotion 20XX #linebreak()
    Année 20XX/20XX],

  // Title of the internship report
  title: [#lorem(10)],

  // Company name, location, duration, etc.
  internshipDetails: [Stage effectué du *1er mars au 30 août 2025*, au sein de la société *TechSolutions*, située à Paris.

    Sous la responsabilité de : #linebreak()
    - M. *Pierre LEFEVRE*, Directeur de la Stratégie #linebreak()
    - Mme *Marie DUBOIS*, Responsable des Opérations #linebreak()
  ],

  // Enable the list of figures
  enableListOfFigures: true,
  // Enable the list of tables
  enableListOfTables: true,
  // Enable the list of appendices
  enableListOfAppendices: true,
  // Enable the glossary section
  enableGlossary: true,
  // Enable the bibliography
  enableBibliography: true,
  // Enable the appendix section
  enableAppendices: true,
)

// ============================
// START HERE
// DELETE THE LINES BELOW THIS COMMENT
// ============================

= Introduction
#lorem(70)

== Une figure pour illustrer la "Liste des figures"
#figure(image("media/logo-ENSEA.jpg", width: 25%), caption: [Logo de l'ENSEA])

== Une tableau pour illustrer la "Liste des tableaux"
#figure(
  table(
    columns: 3,
    align: (center, left, right),
    inset: 6pt,
    stroke: 1pt,
    fill: (none, none, none),

    // Header row
    table.header([N°], [Nom de l'étudiant], [Note finale]),

    // Body
    [001], [Alice Dupont], [16,5],
    [002], [Bruno Lefèvre], [14,8],
    [003], [Claire Noël], [12,7],
  ),
  caption: [Résultats des étudiants à l'examen],
)

== Une citation pour illustrer la "Bibliographie"
Dans le traité "*Philosophiæ Naturalis Principia Mathematica*" @newton1833philosophiae, Newton énonce ses célèbres lois du mouvement et la loi de la gravitation universelle, posant ainsi les bases de la mécanique classique.

== Une référence pour illustrer le "Glossaire"
L'@ENSEA est une école d'ingénieurs française, accréditée à délivrer le diplôme d'ingénieur.

Établissement généraliste et public, situé à Cergy (Val-d'Oise), elle est placé sous la tutelle du ministère de l'Enseignement supérieur et de la Recherche.

Depuis 1952, elle forme des ingénieurs en électronique, informatique et télécommunications.

Reconnue pour son ouverture sociale, l'@ENSEA recrute ses étudiants-ingénieurs via :
- le cycle préparatoire (concours commun Centrale-Supélec et concours Arts et Métiers)
- les concours ATS
- la banque d'épreuves DUT-BUT/BTS
- le Pass'Ingénieur
- la sélection sur dossier

// Insert a page break
#pagebreak()

= Titre de niveau 1
#lorem(70)

== Titre de niveau 2
#lorem(50)

=== Titre de niveau 3
#lorem(35)

```java
// HelloWorld.java
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
```

// Insert a page break
#pagebreak()

= Conclusion
#lorem(350)
