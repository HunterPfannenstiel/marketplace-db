ALTER SEQUENCE market.contract_type_contract_type_id_seq RESTART WITH 1;

INSERT INTO market.contract_type("type")
VALUES ('ERC20'), ('ERC721'), ('ERC721T'), ('ERC1155'), ('ERC1155T'), ('ETHER');

ALTER SEQUENCE market.listing_status_listing_status_id_seq RESTART WITH 1;

INSERT INTO market.listing_status(status)
VALUES ('Active'), ('Updated'), ('Purchased'), ('Removed');

CALL market.modify_item_contract('0x6C2F72CC495658e9e690aF821EB166847B45EFEb', 'Macho Kats', 'A collection of meerkats that are macho.', 
	'https://bafybeifnrceguerrlx23gfi7hd3qxdwrflgs3y6bqcuhif4mhbtpmqy37y.ipfs.dweb.link/1.png', 3::SMALLINT, 20, 5::SMALLINT, true);
	
CALL market.modify_currency(0::SMALLINT, 6::SMALLINT, '0x0000000000000000000000000000000000000000', 18::SMALLINT, 
	'https://s2.coinmarketcap.com/static/img/coins/64x64/1027.png', 'ETH', '#123445');
	
CALL market.create_listing(1, '0x6C2F72CC495658e9e690aF821EB166847B45EFEb', 1, 1, 1000, 0::SMALLINT, '0xf8c2099B8F5403356ACA29cB5aFFf4f861D7fd99');

CALL market.update_listing(1, 2::SMALLINT, 1001, NULL, NULL);

CALL market.modify_currency(0::SMALLINT, NULL, NULL, NULL, NULL, NULL, '#716b94');