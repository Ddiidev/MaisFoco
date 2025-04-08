module models

import time
import shareds.types

pub struct InstantGamingProduct {
pub:
	id                   int
	price                f64
	qtde_review          int
	price_old            ?f64
	discount             ?int
	review_general       string
	title                string
	about                string
	activating_plataform string
	studio               string
	publisher            string
	link                 string
	preview_video        string
	genders              types.Genders
	tags                 types.UserTags
	current_date         time.Time
	images               []InstantGamingProductImage
}
