GRANT USAGE ON SCHEMA market TO web3;

GRANT EXECUTE ON FUNCTION market.get_currencies(is_active_filter boolean) TO web3;

GRANT EXECUTE ON FUNCTION market.view_activity(after_time timestamp without time zone, page smallint, page_size smallint, filter_user_address character varying, filter_listing_id integer, filter_token_id integer) TO web3;

GRANT EXECUTE ON FUNCTION market.view_collection_listings(collection_title text, after_time timestamp without time zone, page smallint, page_size smallint, filter_currency_id smallint) TO web3;

GRANT EXECUTE ON FUNCTION market.view_collections(after_time timestamp without time zone, page smallint, page_size smallint, search_term text) TO web3;

GRANT EXECUTE ON PROCEDURE market.update_listing(IN update_listing_id integer, IN new_listing_status_id smallint, IN new_price integer, IN new_amount integer, IN new_currency_id smallint, IN buyer character varying) TO web3;

