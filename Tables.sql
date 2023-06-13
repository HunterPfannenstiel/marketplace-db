BEGIN;

CREATE TABLE IF NOT EXISTS market."user"
(
    user_id serial NOT NULL,
    address character varying(42) NOT NULL,
    PRIMARY KEY (user_id)
);

CREATE TABLE IF NOT EXISTS market.contract_type
(
    contract_type_id smallserial NOT NULL,
    type text NOT NULL,
    PRIMARY KEY (contract_type_id)
);

CREATE TABLE IF NOT EXISTS market.listing_contract
(
    listing_contract_id smallserial NOT NULL,
    address character varying(42) NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    cover_image text NOT NULL,
    contract_type_id smallint NOT NULL,
    supply integer,
	fee smallint NOT NULL DEFAULT 0,
    is_active boolean NOT NULL DEFAULT true,
	UNIQUE (address),
    PRIMARY KEY (listing_contract_id)
);

CREATE TABLE IF NOT EXISTS market.listing_status
(
    listing_status_id smallserial NOT NULL,
    status text NOT NULL,
    PRIMARY KEY (listing_status_id)
);

CREATE TABLE IF NOT EXISTS market.listing
(
    listing_id integer NOT NULL,
    listing_contract_id smallint NOT NULL,
    token_id integer NOT NULL,
    amount integer NOT NULL,
    price integer NOT NULL,
    listing_status_id smallint NOT NULL DEFAULT 1,
    created_on timestamp(0) without time zone NOT NULL DEFAULT NOW(),
    ended_on timestamp(0) without time zone,
    currency_id smallint NOT NULL,
    user_id integer NOT NULL,
	buyer_id integer,
    PRIMARY KEY (listing_id)
);

CREATE TABLE IF NOT EXISTS market.currency
(
    currency_id smallint NOT NULL,
    contract_type_id smallint NOT NULL,
    address character varying(42) NOT NULL,
    decimals smallint NOT NULL,
	image text NOT NULL,
	ticker text NOT NULL,
	color character varying(7) NOT NULL,
    is_active boolean NOT NULL DEFAULT true,
    PRIMARY KEY (currency_id)
);

CREATE TABLE IF NOT EXISTS market.listing_log
(
    listing_log_id serial NOT NULL,
    listing_id integer NOT NULL,
    listing_status_id smallint NOT NULL,
    logged_on timestamp(0) without time zone NOT NULL,
    listing_log_info_id integer,
    PRIMARY KEY (listing_log_id)
);

CREATE TABLE IF NOT EXISTS market.listing_log_info
(
    listing_log_info_id serial NOT NULL,
    new_price integer,
    new_amount integer,
    PRIMARY KEY (listing_log_info_id)
);

ALTER TABLE IF EXISTS market.listing_contract
    ADD FOREIGN KEY (contract_type_id)
    REFERENCES market.contract_type (contract_type_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS market.listing
    ADD FOREIGN KEY (listing_contract_id)
    REFERENCES market.listing_contract (listing_contract_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS market.listing
    ADD FOREIGN KEY (listing_status_id)
    REFERENCES market.listing_status (listing_status_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS market.listing
    ADD FOREIGN KEY (user_id)
    REFERENCES market."user" (user_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

ALTER TABLE IF EXISTS market.listing
    ADD FOREIGN KEY (buyer_id)
    REFERENCES market."user" (user_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

ALTER TABLE IF EXISTS market.currency
    ADD FOREIGN KEY (contract_type_id)
    REFERENCES market.contract_type (contract_type_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

ALTER TABLE IF EXISTS market.listing_log
    ADD FOREIGN KEY (listing_log_info_id)
    REFERENCES market.listing_log_info (listing_log_info_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS market.listing_log
    ADD FOREIGN KEY (listing_id)
    REFERENCES market.listing (listing_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS market.listing_log
    ADD FOREIGN KEY (listing_status_id)
    REFERENCES market.listing_status (listing_status_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

END;