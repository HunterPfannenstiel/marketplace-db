CREATE OR REPLACE PROCEDURE market.modify_item_contract(address CHARACTER VARYING(42), title TEXT, description TEXT, 
	cover_image TEXT, contract_type_id SMALLINT, supply INTEGER, fee SMALLINT, is_active BOOLEAN)
SECURITY DEFINER
LANGUAGE plpgsql
AS
$$
BEGIN
	MERGE INTO market.listing_contract T
	USING (SELECT address, title, description, cover_image, contract_type_id, supply, fee, is_active) S ON S.address = T.address
	WHEN MATCHED THEN 
		UPDATE SET address = COALESCE(S.address, T.address), 
			title = COALESCE(S.title, T.title), description = COALESCE(S.description, T.description), 
			cover_image = COALESCE(S.cover_image, T.cover_image), contract_type_id = COALESCE(S.contract_type_id, T.contract_type_id),
			fee = COALESCE(S.fee, T.fee), is_active = COALESCE(S.is_active, T.is_active)
	WHEN NOT MATCHED THEN
		INSERT (address, title, description, cover_image, contract_type_id, supply, fee, is_active)
		VALUES (S.address, S.title, S.description, S.cover_image, S.contract_type_id, S.supply, S.fee, S.is_active);
END;
$$;

CREATE OR REPLACE PROCEDURE market.modify_currency(currency_id SMALLINT, contract_type_id SMALLINT, address CHARACTER VARYING(42), decimals SMALLINT,
	image TEXT, ticker TEXT, color CHARACTER VARYING(7), is_active BOOLEAN DEFAULT true)
SECURITY DEFINER
LANGUAGE plpgsql
AS
$$
BEGIN
	MERGE INTO market.currency T
	USING (SELECT currency_id, contract_type_id, address, decimals, image, ticker, color, is_active) S ON S.currency_id = T.currency_id
	WHEN MATCHED THEN
		UPDATE SET contract_type_id = COALESCE(S.contract_type_id, T.contract_type_id), 
			address = COALESCE(S.address, T.address), decimals = COALESCE(S.decimals, T.decimals), image = COALESCE(S.image, T.image), 
			ticker = COALESCE(S.ticker, T.ticker), color = COALESCE(S.color, T.color), is_active = S.is_active
	WHEN NOT MATCHED THEN
	INSERT (currency_id, contract_type_id, address, decimals, image, ticker, color)
	VALUES (S.currency_id, S.contract_type_id, S.address, S.decimals, S.image, S.ticker, S.color);
END;
$$;

CREATE OR REPLACE PROCEDURE market.get_user(user_address CHARACTER VARYING(42), OUT "id" INTEGER)
SECURITY DEFINER
LANGUAGE plpgsql
AS
$$
BEGIN
	SELECT user_id INTO "id"
	FROM market.user U
	WHERE U.address = user_address;
	
	IF "id" IS NULL THEN
		INSERT INTO market.user (address)
		VALUES (user_address)
		RETURNING user_id INTO "id";
	END IF;
END;
$$;

CREATE OR REPLACE PROCEDURE market.create_listing(new_listing_id INTEGER, item_address CHARACTER VARYING(42), listing_token_id INTEGER, 
	listing_amount INTEGER, listing_price INTEGER, listing_currency_id SMALLINT, lister_address CHARACTER VARYING(42))
SECURITY DEFINER
LANGUAGE plpgsql
AS
$$
DECLARE user_id INTEGER;
DECLARE contract_id SMALLINT;
BEGIN
	CALL market.get_user(lister_address, user_id);
	
	SELECT listing_contract_id INTO contract_id
	FROM market.listing_contract LC
	WHERE LC.address = item_address;
	
	INSERT INTO market.listing(listing_id, listing_contract_id, token_id, amount, price, currency_id, user_id)
	VALUES (new_listing_id, contract_id, listing_token_id, listing_amount, listing_price, listing_currency_id, user_id);
END;
$$;