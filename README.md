# Cultural Mobility Yearbook 2021, by On the Move

This repo contains data and analysis on funded mobility opportunities in the arts and culture sector used for [On the Move](https://on-the-move.org)'s 2021 Cultural Mobility Yearbook.

You can download the main, processed dataset and final Yearbook here:

:card_index_dividers: [Download the full dataset](https://on-the-move.org/sites/default/files/library/2022-04/OTM_yearbook-2022-data_2022-04-19.xlsx)\
:blue_book: [Download the Yearbook](https://on-the-move.org/sites/default/files/library/2022-04/OTM_yearbook-2022.pdf) 

For those who want to dig deeper, the `/data` and `/scripts` directories contain the data and code used to create the graphs and statistics that appear in the final publication.

## Datasets

The `/data` directory contains:

| File      | Description |
| ------------- | ------------- |
| `CREATIVE-EUROPE_project-funding`  | Data from the European Commmission on projects awarded under the Creative Europe programme. Source: https://ec.europa.eu/programmes/creative-europe/projects/ce-projects-compendium/  |
| `EU_creative-europe-countries`  |  List of countries and their Creative Europe status. |
| `EU-OTM_project-ids`  | List of calls on the On the Move website that were supported as cooperation projects by Creative Europe with their relevant CE Project Number. |
| `OTM_website-data`  | Main dataset of calls from the On the Move website (2020-2021). See below for information on the variables.  |
| `OTM_website-digital-hybrid-calls`  | Some extra labelling for calls that were either online/remote or that practiced hybrid mobility (mix of in-person and online), looking at programme affordances.  |
| `UN_geoscheme`  | United Nations geoscheme used for grouping countries into regions and subregions. Source: https://unstats.un.org/unsd/methodology/m49 |

## On the Move data - sources and limitations

Data collected by On the Move reflects our [editorial policy](https://on-the-move.org/about/editorial-policy) and focus. In short, we concentrate on funded programmes that cover at least some of the costs of travel (or that offer remuneration in the case of online/remote programmes). The calls that are posted to the website are generally one-off calls or relate to temporary or shifting programmes rather than permanent ones (which are separately listed in our [mobility funding guides](https://on-the-move.org/funding)).

Blank values appear in calls where we weren't able to collect the relevant data or the variable is not applicable. These are generally filtered out in the analysis.

## On the Move data - variables

| Variable      | Description |
| ------------- | ------------- |
| `id`  | A unique ID for the call on the On the Move website.  |
| `authored`  | The date that the call was posted to the On the Move website.  |
| `title`  | The title of the call.  |
| `origin_country`  | The country or countries in which the call's principal organiser(s) were based. |
| `destination_country`  | The country or countries that beneficiaries of the opportunity will travel to.  |
| `mobility_type`  | Whether the opportunity is for in-person mobility (i.e. physical travel), digital mobility, or a mixture of the two.  |
| `opportunity_type`  | The category given to the opportunity on the On the Move website to describe the type of activity (residencies, fellowships, training, etc.).  |
| `artform`  | The art form(s) the call was marked with on the On the Move website.  |
| `target_scope`  | Whether the call addresses individuals, organisations/groups, or is open to either.   |
| `topic`  | A more general tag reflecting the overall 'topic' or 'theme' of a call. Treat with caution, but useful for finding examples.  |
| `funding_source`  | Marks the calls which were supported by the European Union, and under which programme.   |
| `target_type`  | Who the call was addressed to - artists, producers, managers or cultural professionals, researchers, etc.  |
| `deadline`  | The deadline date(s) for the call.  |
| `url`  | The url to the original call on the On the Move website.  |
| `organisation`  | The principal organisers involved in the opportunity.  |

## License and contact

This data is licensed under CC BY-NC 4.0, meaning you can share and adapt it for non-commerical purposes with proper credit. No permission needed, but we'd be pleased to hear from you if you're doing similar research, are interested in this area of work, or have any questions: data@on-the-move.org

On the Move will ultimately publish three Yearbooks over the period 2022-2024. The next edition in 2023 will have a special focus on green and sustainable mobility. The 2024 publication will focus on accessibility and inclusion.

<img src="https://ec.europa.eu/regional_policy/sources/information/logos_downloadcenter/eu_co_funded_en.jpg" width="300" height="auto" alt='Co-funded by the European Union'>