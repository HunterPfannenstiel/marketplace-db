DROP TABLE IF EXISTS market.listing_log;
DROP TABLE IF EXISTS market.currency;
DROP TABLE IF EXISTS market.listing;
DROP TABLE IF EXISTS market.listing_status;
DROP TABLE IF EXISTS market.listing_contract;
DROP TABLE IF EXISTS market.contract_type;
DROP TABLE IF EXISTS market."user";
DROP PROCEDURE IF EXISTS market.modify_listing_contract;
DROP PROCEDURE IF EXISTS market.modify_currency;
DROP PROCEDURE IF EXISTS market.get_user;
DROP PROCEDURE IF EXISTS market.insert_log_info;
DROP PROCEDURE IF EXISTS market.create_listing;
DROP PROCEDURE IF EXISTS market.update_listing;
DROP FUNCTION IF EXISTS market.view_collection_listings;
DROP FUNCTION IF EXISTS market.get_currencies;
DROP FUNCTION IF EXISTS market.view_collections;
DROP FUNCTION IF EXISTS market.view_activity; --Used to view global activity, user activity, or listing activity