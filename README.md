# Estonia Public Procurement Contracts 2024

A [Frictionless Fiscal Data Package](https://specs.frictionlessdata.io/fiscal-data-package/)
of awarded public procurement contracts in Estonia during calendar year **2024**,
published by **[Nimistu MTÜ](https://nimistu.ee)** — an Estonian non-profit operating
public-registry transparency infrastructure.

Each row is one awarded supplier on a public procurement contract. Every supplier is
**cross-referenced with the Estonian Business Register (äriregister)** — the value this
dataset adds over the raw procurement feed.

## At a glance

| | |
|---|---|
| Contracts (value-disclosed) | **7,263** |
| Contracting authorities | **704** |
| Distinct suppliers | **2,585** |
| Total disclosed value | **≈ €3.85 billion** |
| Suppliers matched to äriregister | **6,823 (94%)** |
| Period | 2024-01-01 – 2024-12-31 (award date) |
| Currency | EUR |
| License | CC-BY-SA-4.0 |

## Scope

- **All public buyers** — state agencies, local governments, foundations and other
  contracting authorities that publish in the Estonian procurement register.
- **Awarded contracts only** (contract-award notices), one row per winning supplier.
- **Value-disclosed only** — this package contains the awards that publish a contract
  value. Roughly 31% of 2024 awards do not disclose a value and are *excluded* here
  (they remain browsable on nimistu.ee).

## Sources & methodology

1. **Estonian Public Procurement Register** (riigihangete register,
   <https://riigihanked.riik.ee>) — the authoritative source. Nimistu ingests the
   register's open-data contract-award feed (eForms format) daily.
2. **Estonian Business Register** (äriregister, <https://ariregister.rik.ee>) — each
   winning supplier's registry code is matched to its current business-register entry;
   `winner_in_ariregister` and `winner_status` carry the result.

The package is generated from Nimistu's `procurements` table with
[`scripts/export.sql`](scripts/export.sql). It is validated with
[`frictionless`](https://framework.frictionlessdata.io/) before publication:

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

- **Value coverage** — only awards with a disclosed value are included (~69% of all 2024
  awards). Use the count + total as a lower bound on total procurement activity.
- **Notice-level attributes** — `register_number`, `procedure_type` and `source_url` are
  captured at the procurement (notice) level and apply to all winner rows of that notice;
  for multi-lot procurements they describe the procurement, not the individual lot.
- **Award date** — taken from the contract-award notice; the register's own `AwardDate`
  field is a placeholder in the source feed and is not used.
- **Foreign suppliers** — suppliers without an Estonian registry entry are unmatched
  (`winner_in_ariregister = false`); their registry code is the foreign identifier as
  published.

## Update frequency

Living dataset. Nimistu refreshes the underlying register data daily; this package is
regenerated from the latest data. The `version` and `created` fields in
`datapackage.json` record each release.

## License & citation

Released under [Creative Commons Attribution-ShareAlike 4.0](https://creativecommons.org/licenses/by-sa/4.0/)
(CC-BY-SA-4.0). See [`LICENSE`](LICENSE).

> Estonia Public Procurement Contracts 2024 — Nimistu MTÜ, derived from the Estonian
> Public Procurement Register and the Estonian Business Register. CC-BY-SA-4.0.

## Contact

Nimistu MTÜ · <info@nimistu.ee> · <https://nimistu.ee>

## Update history

- **2026-05-25** — v1.0.0, initial release (2024 awards, value-disclosed).
