module repository

import shareds.db
import server.features.instant_gaming.entities

pub fn import(entitie entities.InstantGamingProduct) ! {
	mut dbase := db.ConnectionDb.new()!
	defer {
		dbase.close()
	}

	sql dbase.conn {
		insert entitie into entities.InstantGamingProduct
	}!
}
