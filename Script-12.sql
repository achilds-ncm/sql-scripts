alter table appointment_reasons disable trigger all;
alter table appointment_resources disable trigger all;

ALTER TABLE public.appointments ALTER COLUMN id TYPE varchar USING id::varchar;
ALTER TABLE public.appointment_reasons ALTER COLUMN appointment_id TYPE varchar USING appointment_id::varchar;
ALTER TABLE public.appointment_resources ALTER COLUMN appointment_id TYPE varchar USING appointment_id::varchar;

alter table appointment_reasons enable trigger all;
alter table appointment_resources enable trigger all;

SELECT con.*
    FROM pg_catalog.pg_constraint con
        INNER JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
        INNER JOIN pg_catalog.pg_namespace nsp ON nsp.oid = connamespace
        WHERE nsp.nspname = 'public'
             AND rel.relname = 'appointment_resources';
             
SELECT con.*
    FROM pg_catalog.pg_constraint con
        INNER JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
        INNER JOIN pg_catalog.pg_namespace nsp ON nsp.oid = connamespace
        WHERE nsp.nspname = 'public'
             AND rel.relname = 'appointment_reasons';
             
drop table appointment_reasons;
drop table appointment_resources;
drop table insurance_payment_applications ;
drop table payment_applications;
drop table payments;
drop table encounter_diagnoses ;
drop table charges;
drop table charge_modifiers ;
drop table encounters;
drop table appointments;

CREATE TABLE IF NOT EXISTS appointments (
    id varchar PRIMARY KEY,
    practice_id int NOT NULL REFERENCES practices(id) ON DELETE CASCADE ON UPDATE CASCADE,
    service_location_id int NOT NULL REFERENCES service_locations(id) ON DELETE CASCADE ON UPDATE CASCADE,
    patient_id int NOT NULL REFERENCES patients(id) ON DELETE CASCADE ON UPDATE CASCADE,
    start_date timestamp NOT NULL,
    end_date timestamp NOT NULL,
    recurring boolean NOT NULL,
    confirmation_status text NOT NULL,
    type text NOT NULL,
    notes text,
    case_id int REFERENCES cases(id) ON DELETE SET NULL ON UPDATE CASCADE,
    created_date timestamp NOT NULL,
    last_modified_date timestamp NOT NULL
);

CREATE INDEX ON appointments (practice_id);

CREATE INDEX ON appointments (service_location_id);

CREATE INDEX ON appointments (patient_id);

CREATE INDEX ON appointments (start_date);

CREATE INDEX ON appointments (end_date);

CREATE INDEX ON appointments (case_id);

CREATE TABLE IF NOT EXISTS appointment_reasons (
    appointment_id varchar NOT NULL REFERENCES appointments(id) ON DELETE CASCADE ON UPDATE CASCADE,
    reason_id int NOT NULL REFERENCES reasons(id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (appointment_id, reason_id)
);

CREATE INDEX ON appointment_reasons (appointment_id);

CREATE INDEX ON appointment_reasons (reason_id);

CREATE TABLE IF NOT EXISTS appointment_resources (
    appointment_id varchar NOT NULL REFERENCES appointments(id) ON DELETE CASCADE ON UPDATE CASCADE,
    resource_id int NOT NULL REFERENCES resources(id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (appointment_id, resource_id)
);

CREATE INDEX ON appointment_resources (appointment_id);

CREATE INDEX ON appointment_resources (resource_id);

CREATE TABLE IF NOT EXISTS payments (
    id int PRIMARY KEY,
    practice_id int NOT NULL REFERENCES practices(id) ON DELETE CASCADE ON UPDATE CASCADE,
    appointment_id varchar REFERENCES appointments(id) ON DELETE SET NULL ON UPDATE CASCADE,
    amount numeric(15,6) NOT NULL DEFAULT 0.00,
    adjustments numeric(15,6) NOT NULL DEFAULT 0.00,
    refunds numeric(15,6) NOT NULL DEFAULT 0.00,
    applied numeric(15,6) NOT NULL DEFAULT 0.00,
    unapplied numeric(15,6) NOT NULL DEFAULT 0.00,
    post_date date NOT NULL,
    adjudication_date date NOT NULL,
    payment_method text NOT NULL,
    payer_type text NOT NULL,
    payer_name text NOT NULL,
    insurance_id int REFERENCES plans(id) ON DELETE SET NULL ON UPDATE CASCADE,
    patient_id int REFERENCES patients(id) ON DELETE SET NULL ON UPDATE CASCADE,
    batch_number text,
    reference_number text,
    category text,
    created_date timestamp NOT NULL,
    last_modified_date timestamp NOT NULL
);

CREATE INDEX ON payments (practice_id);

CREATE INDEX ON payments (appointment_id);

CREATE INDEX ON payments (post_date);

CREATE INDEX ON payments (payer_name);

CREATE INDEX ON payments (insurance_id);

CREATE INDEX ON payments (patient_id);

CREATE INDEX ON payments (batch_number);

CREATE TABLE IF NOT EXISTS encounters (
    id int PRIMARY KEY,
    practice_id int NOT NULL REFERENCES practices(id) ON DELETE CASCADE ON UPDATE CASCADE,
    patient_id int NOT NULL REFERENCES patients(id) ON DELETE CASCADE ON UPDATE CASCADE,
    case_id int NOT NULL REFERENCES cases(id) ON DELETE CASCADE ON UPDATE CASCADE,
    service_location_id int NOT NULL REFERENCES service_locations(id) ON DELETE CASCADE ON UPDATE CASCADE,
    start_date date NOT NULL,
    end_date date NOT NULL,
    appointment_id varchar REFERENCES appointments(id) ON DELETE SET NULL ON UPDATE CASCADE,
    rendering_provider_id int REFERENCES providers(id) ON DELETE SET NULL ON UPDATE CASCADE,
    referring_provider_id int REFERENCES providers(id) ON DELETE SET NULL ON UPDATE CASCADE,
    scheduling_provider_id int REFERENCES providers(id) ON DELETE SET NULL ON UPDATE CASCADE,
    supervising_provider_id int REFERENCES providers(id) ON DELETE SET NULL ON UPDATE CASCADE,
    minutes int NOT NULL,
    status text NOT NULL
);

CREATE INDEX ON encounters (practice_id);

CREATE INDEX ON encounters (patient_id);

CREATE INDEX ON encounters (case_id);

CREATE INDEX ON encounters (service_location_id);

CREATE INDEX ON encounters (start_date);

CREATE INDEX ON encounters (end_date);

CREATE INDEX ON encounters (appointment_id);

CREATE INDEX ON encounters (rendering_provider_id);

CREATE INDEX ON encounters (referring_provider_id);

CREATE INDEX ON encounters (scheduling_provider_id);

CREATE INDEX ON encounters (supervising_provider_id);

CREATE TABLE IF NOT EXISTS encounter_diagnoses (
    encounter_id int NOT NULL REFERENCES encounters(id) ON DELETE CASCADE ON UPDATE CASCADE,
    diagnosis text NOT NULL,
    PRIMARY KEY (encounter_id, diagnosis)
);

CREATE TABLE IF NOT EXISTS charges (
    id int PRIMARY KEY,
    encounter_id int NOT NULL REFERENCES encounters(id) ON DELETE CASCADE ON UPDATE CASCADE,
    procedure_code text NOT NULL,
    procedure_name text NOT NULL,
    unit_charge numeric(15,6) NOT NULL DEFAULT 0.00,
    units int NOT NULL DEFAULT 1,
    billed_to text NOT NULL,
    status text NOT NULL,
    posting_date date NOT NULL,
    batch_number text,
    line_note text,
    created_date timestamp NOT NULL,
    last_modified_date timestamp NOT NULL
);

CREATE INDEX ON charges (encounter_id);

CREATE INDEX ON charges (procedure_code);

CREATE INDEX ON charges (billed_to);

CREATE INDEX ON charges (posting_date);

CREATE TABLE IF NOT EXISTS payment_applications (
    id int PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    payment_id int NOT NULL REFERENCES payments(id) ON DELETE CASCADE ON UPDATE CASCADE,
    charge_id int NOT NULL REFERENCES charges(id) ON DELETE CASCADE ON UPDATE CASCADE,
    payer text NOT NULL,
    paid_amount numeric(15,6) NOT NULL DEFAULT 0.00,
    adjustment numeric(15,6) NOT NULL DEFAULT 0.00,
    copay numeric(15,6) NOT NULL DEFAULT 0.00,
    UNIQUE (payment_id, charge_id, payer)
);

CREATE INDEX ON payment_applications (payment_id);

CREATE INDEX ON payment_applications (charge_id);

CREATE TABLE IF NOT EXISTS insurance_payment_applications (
    payment_application_id int PRIMARY KEY REFERENCES payment_applications(id) ON DELETE CASCADE ON UPDATE CASCADE,
    allowed numeric(15,6) NOT NULL DEFAULT 0.00,
    coinsurance numeric(15,6) NOT NULL DEFAULT 0.00,
    deductible numeric(15,6) NOT NULL DEFAULT 0.00,
    contract_adjustment numeric(15,6) NOT NULL DEFAULT 0.00,
    contract_adjustment_reason text,
    secondary_adjustment numeric(15,6) NOT NULL DEFAULT 0.00,
    secondary_adjustment_reason text
);

CREATE INDEX ON insurance_payment_applications (payment_application_id);

CREATE TABLE IF NOT EXISTS modifiers (
    id int PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    modifier text NOT NULL
);

CREATE TABLE IF NOT EXISTS charge_modifiers (
    charge_id int NOT NULL REFERENCES charges(id) ON DELETE CASCADE ON UPDATE CASCADE,
    modifier_id int NOT NULL REFERENCES modifiers(id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (charge_id, modifier_id)
);

CREATE INDEX ON charge_modifiers (charge_id);

CREATE INDEX ON charge_modifiers (modifier_id);