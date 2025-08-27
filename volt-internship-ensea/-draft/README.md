# ENSEA - Typst Internship Template (unofficial)

Unofficial template for internship reports at ENSEA, a French engineering school.

## Usage

Either use this template in the Typst web app:
```typst
#import "@preview/volt-internship-ensea:0.1.2": *
```
or use the command line to initialize a new project based on this template:
```typst
typst init @preview/volt-internship-ensea:0.1.2
```

## Default Values

| Parameter                | Default Value  | Description                            | Mandatory  |
|--------------------------|----------------|----------------------------------------|------------|
| `COMPANY-LOGO`            | `none`         | Path to the company logo               | ✅         |
| `AUTHORS`                | `none`         | Name(s) of the report author(s)        | ✅         |
| `STUDENT-INFO`            | `none`         | Information about the student(s)       | ✅         |
| `TITLE`                  | `none`         | Title of the internship report         | ✅         |
| `INTERNSHIP-DETAILS`      | `none`         | Company name, location, duration, etc. | ✅         |
| `ENABLE-LIST-FIGURES`    | `true`         | Enable the list of figures             | ❌         |
| `ENABLE-LIST-TABLES`     | `false`        | Enable the list of tables              | ❌         |
| `ENABLE-GLOSSARY`         | `false`        | Enable the glossary                    | ❌         |
| `ENABLE-ABSTRACT`         | `true`         | Enable the abstract                    | ❌         |
| `ENABLE-BIBLIOGRAPHY`     | `true`         | Enable the bibliography                | ❌         |

## Example

```typst
#import "@preview/glossy:0.8.0": *
#show: init-glossary.with(yaml("glossary.yaml"), term-links: true)
#import "abstract.typ": *
#import "acknowledgements.typ": *
#import "appendices.typ": *

#import "@preview/volt-internship-ensea:0.1.2": *

#show: internship.with(
  ABSTRACT: abstract(),
  ACKNOWLEDGEMENTS: acknowledgements(),
  APPENDICES: annexes(),
  REFERENCES: bibliography("references.bib", full: true),

  COMPANY-LOGO: image("media/logo.png"),
  AUTHORS: (
    "Jean DUPONT",
  ),
  STUDENT-INFO: [*Élève ingénieur en X#super[ème] année* #linebreak()
    Promotion 20XX #linebreak()
    Année 20XX/20XX],
  TITLE: [#lorem(10)],
  INTERNSHIP-DETAILS: [Stage effectué du *1er mars au 30 août 2025*, au sein de la société *TechSolutions*, située à Paris.

    Sous la responsabilité de : #linebreak()
    - M. *Pierre LEFEVRE*, Directeur de la Stratégie #linebreak()
    - Mme *Marie DUBOIS*, Responsable des Opérations #linebreak()
  ],
  ENABLE-LIST-FIGURES: false,
  ENABLE-BIBLIOGRAPHY: false,
)

= Introduction
#lorem(120)
```

<p align="center">
  <img src="thumbnail-internship-1.png" width="250" />
  <img src="thumbnail-internship-2.png" width="250" />
  <br/>
  <img src="thumbnail-internship-3.png" width="250" />
  <img src="thumbnail-internship-4.png" width="250" />
    <br/>
  <img src="thumbnail-internship-5.png" width="250" />
  <img src="thumbnail-internship-6.png" width="250" />
</p>

## Changelog

v- draft :
- Fix groups in glossary  
- Fix heading spacing

v0.1.2 : Fix import issue  
v0.1.1 : Fix import issue  
v0.1.0 : Initial release

## Contributions

If you find any issues or have suggestions for improvements, feel free to open an issue or submit a pull request. 

## License

The Typst template is licensed under the [MIT license](https://github.com/Dawod-G/ENSEA_Typst-Template/blob/main/LICENSE.md). This license does not apply to the ENSEA logo or associated image files, which remain the property of ENSEA.