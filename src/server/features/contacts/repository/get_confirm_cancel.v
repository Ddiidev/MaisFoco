module repository

import shareds.db
import server.features.contacts.entities

// get_confirm_cancel retorna o contato com o uuid de confirmação de cancelamento
pub fn get_confirm_cancel(uuid string) ?entities.Contact {
	mut dbase := db.ConnectionDb.new() or { return none }

	defer {
		dbase.close()
	}

	res := sql dbase.conn {
		select from entities.Contact where uuid_confirm_cancel == uuid
	} or { return none }

	return res[0] or { none }
}
