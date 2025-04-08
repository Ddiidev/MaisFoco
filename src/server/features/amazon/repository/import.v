module repository

import shareds.db
import server.features.amazon.entities

pub fn import(entitie entities.AmazonProduct) ! {
	mut dbase := db.ConnectionDb.new()!

	defer {
		dbase.close()
	}

	sql dbase.conn {
		insert entitie into entities.AmazonProduct
	}!
}
