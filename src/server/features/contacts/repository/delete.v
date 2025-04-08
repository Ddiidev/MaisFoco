module repository

import shareds.db
import server.features.contacts.entities

pub fn delete_whatsapp(number string) ! {
	mut dbase := db.ConnectionDb.new()!

	defer {
		dbase.close()
	}

	sql dbase.conn {
		delete from entities.Contact where whatsapp == number
	}!
}

pub fn delete_email(email string) ! {
	mut dbase := db.ConnectionDb.new()!

	defer {
		dbase.close()
	}

	sql dbase.conn {
		delete from entities.Contact where email == email
	}!
}
