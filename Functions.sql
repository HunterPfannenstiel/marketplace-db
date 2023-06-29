CREATE OR REPLACE FUNCTION market.view_collection_listings(collection_title TEXT, after_time TIMESTAMP(0) without time zone, page SMALLINT, page_size SMALLINT, filter_currency_id SMALLINT DEFAULT NULL)
RETURNS TABLE (token_id INTEGER, amount INTEGER, price INTEGER, currency_id SMALLINT, seller CHARACTER VARYING(42))
LANGUAGE plpgsql
SECURITY DEFINER
AS
$func$
BEGIN
	RETURN QUERY
	SELECT L.token_id, L.amount, L.price, L.currency_id, U.address
	FROM market.listing L
	JOIN market.user U ON U.user_id = L.user_id
	JOIN market.listing_contract LC ON LC.listing_contract_id = L.listing_contract_id 
		AND LC.title = collection_title
	WHERE L.created_on <= after_time AND L.listing_status_id IN (1, 2)
	ORDER BY LC.title ASC
	OFFSET (page * page_size) ROWS
	FETCH FIRST page_size ROW ONLY;
END;
$func$;

SELECT * FROM market.view_collection_listings('Macho Kats', NOW()::TIMESTAMP(0) without time zone, 0::SMALLINT, 10::SMALLINT);

--Let the view_collection_listings return a little extra data in order to just display a modal of the listing instead of navigating to a new page

CREATE OR REPLACE FUNCTION market.get_currencies(is_active_filter BOOLEAN DEFAULT NULL)
RETURNS TABLE (currency_id SMALLINT, decimals SMALLINT, fill_color CHARACTER VARYING(7), border_color CHARACTER VARYING(7), image TEXT, ticker TEXT, token_type TEXT, token_id INTEGER, address CHARACTER VARYING(42))
LANGUAGE plpgsql
SECURITY DEFINER
AS
$func$
BEGIN
	RETURN QUERY
	SELECT C.currency_id, C.decimals, C.fill_color, C.border_color, C.image, C.ticker, CT.type, C.token_id, C.address
	FROM market.currency C
	JOIN market.contract_type CT ON CT.contract_type_id = C.contract_type_id
	WHERE is_active_filter IS NULL OR C.is_active = is_active_filter;
END;
$func$;

SELECT * FROM market.get_currencies(true);

CREATE OR REPLACE FUNCTION market.view_collections(after_time TIMESTAMP(0) without time zone, page SMALLINT, page_size SMALLINT, search_term TEXT DEFAULT NULL)
RETURNS TABLE (title TEXT, description TEXT, image TEXT, supply INTEGER, token_type TEXT)
LANGUAGE plpgsql
SECURITY DEFINER
AS
$func$
BEGIN
	RETURN QUERY
	SELECT LC.title, LC.description, LC.cover_image, LC.supply, CT.type
	FROM market.listing_contract LC
	JOIN market.contract_type CT ON CT.contract_type_id = LC.contract_type_id
	WHERE (search_term IS NULL OR LC.title ILIKE '%' || search_term || '%') AND LC.added_on <= after_time
	ORDER BY LC.added_on
	OFFSET (page * page_size)
	FETCH FIRST page_size ROW ONLY;
END;
$func$;

SELECT * FROM market.view_collections(NOW()::TIMESTAMP(0) without time zone, 0::SMALLINT, 10::SMALLINT);

CREATE OR REPLACE FUNCTION market.view_activity(after_time TIMESTAMP(0) without time zone, page SMALLINT, page_size SMALLINT, 
		filter_user_address CHARACTER VARYING(42) DEFAULT NULL, filter_listing_id INTEGER DEFAULT NULL, filter_token_id INTEGER DEFAULT NULL)
RETURNS TABLE (listing_id INTEGER, token_id INTEGER, status TEXT, logged_on TIMESTAMP(0) without time zone, prev_price INTEGER, logged_price INTEGER, prev_amount INTEGER, logged_amount INTEGER, 
			   prev_currency SMALLINT, logged_currency SMALLINT, seller CHARACTER VARYING(42), buyer CHARACTER VARYING(42))
LANGUAGE plpgsql
SECURITY DEFINER
AS
$func$
BEGIN
	RETURN QUERY
	SELECT L.listing_id, L.token_id, LS.status, LL.logged_on, LAG(LL.price, 1) OVER(PARTITION BY L.listing_id ORDER BY LL.listing_log_id), LL.price, 
		LAG(LL.amount, 1) OVER(PARTITION BY L.listing_id ORDER BY LL.listing_log_id), LL.amount, LAG(LL.currency_id, 1) OVER(PARTITION BY L.listing_id ORDER BY LL.listing_log_id), LL.currency_id, U.address, 
		LU.address
	FROM market.listing_log LL
	JOIN market.listing L ON L.listing_id = LL.listing_id
	JOIN market.user U ON U.user_id = L.user_id
	LEFT JOIN market.user LU ON LU.user_id = L.buyer_id
	JOIN market.listing_status LS ON LS.listing_status_id = LL.listing_status_id
	WHERE (filter_user_address IS NULL OR U.address = filter_user_address)
		AND (filter_listing_id IS NULL OR LL.listing_id = filter_listing_id) 
		AND (filter_token_id IS NULL OR L.token_id = filter_token_id) AND LL.logged_on <= after_time
	ORDER BY LL.listing_log_id
	OFFSET (page * page_size) ROWS
	FETCH FIRST page_size ROW ONLY;
END;
$func$;

SELECT * FROM market.view_activity(NOW()::TIMESTAMP(0) without time zone, 0::SMALLINT, 10::SMALLINT);