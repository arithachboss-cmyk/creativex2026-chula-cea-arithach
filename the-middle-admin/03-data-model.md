# Data Model

## Entity Types

### Person

Used for founders, members, collaborators, witnesses, advisors, officials, or referenced people.

Fields:

- id
- name
- name_th
- aliases
- role
- organization_ids
- contact_refs
- notes
- source_ids
- confidence

### Organization

Used for companies, public agencies, teams, projects, communities, or institutional bodies.

Fields:

- id
- name
- name_th
- type
- mission
- location_ids
- website
- related_person_ids
- notes
- source_ids
- confidence

### Location

Used for physical or symbolic places.

Fields:

- id
- name
- name_th
- address
- coordinates
- type
- related_event_ids
- notes
- source_ids
- confidence

### Case

Used for legal, social, administrative, research, or organizational matters.

Fields:

- id
- title
- case_type
- status
- summary
- person_ids
- organization_ids
- document_ids
- evidence_ids
- event_ids
- risk_level
- notes
- source_ids
- confidence

### Document

Used for files, webpages, contracts, letters, PDFs, forms, official notices, transcripts, and internal notes.

Fields:

- id
- title
- document_type
- date_created
- date_received
- author
- custodian
- file_path
- url
- summary
- extracted_entities
- evidence_ids
- source_ids
- confidence

### Evidence

Used for facts, exhibits, media, excerpts, screenshots, records, or claims tied to a case or document.

Fields:

- id
- title
- evidence_type
- description
- claim
- source_document_id
- related_case_ids
- related_event_ids
- verification_status
- confidence

### Event

Used for dated actions, meetings, filings, decisions, incidents, uploads, communications, and milestones.

Fields:

- id
- title
- date_start
- date_end
- date_precision
- location_ids
- person_ids
- organization_ids
- case_ids
- document_ids
- evidence_ids
- summary
- confidence

### Concept

Used for ideas, principles, philosophies, keywords, frameworks, and semantic categories.

Fields:

- id
- term
- term_th
- definition
- related_concept_ids
- source_ids
- notes
- confidence

### Project

Used for internal initiatives and systems.

Fields:

- id
- name
- name_th
- objective
- status
- module_ids
- organization_ids
- document_ids
- decision_ids
- notes

## Relationship Types

- `member_of`: person -> organization
- `founder_of`: person -> organization
- `participant_in`: person -> case/event/project
- `located_at`: organization/event -> location
- `documents`: document -> case/event/evidence
- `supports_claim`: evidence -> claim/case
- `contradicts_claim`: evidence -> claim/case
- `related_to`: entity -> entity
- `depends_on`: project/module/decision -> entity
- `derived_from`: summary/concept -> source/document
- `precedes`: event -> event

## Confidence Levels

- verified
- probable
- possible
- unclear
- disputed

## Source Handling

Every record should include source references. If no source exists, mark the record as an unsourced note.
