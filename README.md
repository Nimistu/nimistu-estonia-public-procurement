# Estonia Public Procurement Contracts (2024–present)

A **living** [Frictionless Fiscal Data Package](https://specs.frictionlessdata.io/fiscal-data-package/)
of awarded public procurement contracts in Estonia from **2024 onward**, published by
**[Nimistu MTÜ](https://nimistu.ee)** — an Estonian non-profit operating public-registry
transparency infrastructure.

Each row is one awarded supplier on a public procurement contract. Every supplier is
**cross-referenced with the Estonian Business Register (äriregister)** — the value this
dataset adds over the raw procurement feed. The dataset is regenerated from the
register's daily-updated data, so new awards appear continuously.

## At a glance

| | |
|---|---|
| Contracts (value-disclosed) | **17,455** |
| Contracting authorities | **1,219** |
| Distinct suppliers | **4,332** |
| Total disclosed value | **≈ €10.2 billion** |
| Suppliers matched to äriregister | **16,450 (94%)** |
| Coverage | 2024-01-01 → present (ongoing) |
| Currency | EUR |
| License | CC-BY-SA-4.0 |

By year: 2024 — 7,263 contracts (€3.85B) · 2025 — 7,812 (€5.37B) · 2026 — 2,380 and counting.

## Scope

- **All public buyers** — state agencies, local governments, foundations and other
  contracting authorities that publish in the Estonian procurement register.
- **Awarded contracts only** (contract-award notices), one row per winning supplier.
- **2024 onward** — the eForms-era feed, which carries full field coverage (procedure
  type, number of tenders, register reference). No end date; the dataset grows as new
  awards are published.
- **Value-disclosed only** — only awards that publish a contract value are included.
  Awards without a disclosed value are excluded here (they remain browsable on nimistu.ee).

## Sources & methodology

1. **Estonian Public Procurement Register** (riigihangete register,
   [riigihanked.riik.ee](https://riigihanked.riik.ee)) — the authoritative source. Nimistu ingests the
   register's open-data contract-award feed (eForms format) daily.
2. **Estonian Business Register** (äriregister, [ariregister.rik.ee](https://ariregister.rik.ee)) — each
   winning supplier's registry code is matched to its current business-register entry;
   `winner_in_ariregister` and `winner_status` carry the result.

The package is generated from Nimistu's `procurements` table with
[`scripts/export.sql`](scripts/export.sql) and validated with
[`frictionless`](https://framework.frictionlessdata.io/) before each release:

```bash
frictionless validate datapackage.json
```

## Fields

See [`datapackage.json`](datapackage.json) for the full Table Schema. Key fields:

| Field | Description |
|---|---|
| `notice_id` | Stable contract-folder identifier (UUID) from the register |
| `register_number` | Public reference number on riigihanked.riik.ee |
| `buyer_name`, `buyer_reg_code` | Contracting authority (fiscal *payer*) |
| `winner_name`, `winner_reg_code` | Awarded supplier (fiscal *payee*) |
| `winner_in_ariregister`, `winner_status` | äriregister cross-reference |
| `amount`, `currency` | Awarded contract value (fiscal *measure*) |
| `award_date` | Contract award / notice date |
| `cpv_main`, `cpv_all` | Common Procurement Vocabulary classification |
| `procedure_type`, `procedure_label` | Procurement procedure (open, restricted, …) |
| `bidder_count` | Number of tenders received |
| `source_url` | Link to the procurement in the register |

## Known limitations

- **Value coverage** — only awards with a disclosed value are included. Treat the count
  and total as a lower bound on total procurement activity.
- **Notice-level attributes** — `register_number`, `procedure_type` and `source_url` are
  captured at the procurement (notice) level and apply to all winner rows of that notice;
  for multi-lot procurements they describe the procurement, not the individual lot.
- **Award date** — taken from the contract-award notice; the register's own `AwardDate`
  field is a placeholder in the source feed and is not used.
- **Foreign suppliers** — suppliers without an Estonian registry entry are unmatched
  (`winner_in_ariregister = false`); their registry code is the foreign identifier as
  published.
- **Pre-2024** — earlier procurement (TED-format, 2017–2023) is not included here because
  it lacks the procedure/tender/reference fields; it may be added as a separate resource.

## Update frequency

Living dataset. The underlying register data refreshes daily; this package is
regenerated and re-published on a recurring schedule. The `version` and `created` fields
in `datapackage.json` record each release.

## License & attribution

Released under [Creative Commons Attribution-ShareAlike 4.0](https://creativecommons.org/licenses/by-sa/4.0/)
(CC-BY-SA-4.0). See [`LICENSE`](LICENSE).

**Attribution is required.** Under CC-BY-SA-4.0, any use, republication or derivative —
including hosting on a third-party portal — must credit **Nimistu MTÜ** with a link to
**[nimistu.ee](https://nimistu.ee)** and keep the same licence. Please use:

> Estonia Public Procurement Contracts — [Nimistu MTÜ](https://nimistu.ee), derived from the
> Estonian Public Procurement Register and the Estonian Business Register. CC-BY-SA-4.0.

HTML for web display:

```html
Source: <a href="https://nimistu.ee">Nimistu MTÜ</a> · CC-BY-SA-4.0
```

## Contact

Nimistu MTÜ · [info@nimistu.ee](mailto:info@nimistu.ee) · [nimistu.ee](https://nimistu.ee)

## Update history

- **2026-05-25** — initial release; live coverage 2024-01-01 onward, value-disclosed.
