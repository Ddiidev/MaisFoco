module generate_page

import mf_core.logger
import shareds.components.badge
import shareds.components.menu_floating
import shareds.components.register_contact
import server.features.amazon.controllers as control_amazon
import server.features.netflix.controllers as control_netflix
import mf_core.features.netflix.models as models_netflix
import server.features.instant_gaming.controllers as control_instant_gaming
import mf_core.features.instant_gaming.models as models_instant_gaming
import server.features.mercado_livre_play.controllers as control_mercado_livre_play
import mf_core.features.mercado_livre_play.models as models_mercado_livre_play
import server.features.livros_gratuitos.controllers as control_livros_gratuitos
import mf_core.features.livros_gratuitos.models as models_livros_gratuitos

pub fn generate(mut log logger.ILogger) string {
	comp_badge := badge.construct
	construct_menu_floating := menu_floating.construct
	construct_register_contract := register_contact.construct

	mercadolivre_play_products := control_mercado_livre_play.get_recomendation(mut log) or {
		models_mercado_livre_play.MercadoLivrePlayProduct{}
	}

	netflix_products := control_netflix.get_recomendation(mut log) or {
		models_netflix.NetflixProduct{}
	}

	instant_gaming_products := control_instant_gaming.get_recomendation(mut log) or {
		models_instant_gaming.InstantGamingProduct{}
	}

	amazon_products := control_amazon.get_recomendation(mut log) or { [] }

	livros_gratuitos_product := control_livros_gratuitos.get_recomendation(mut log) or {
		models_livros_gratuitos.LivrosGratuitosProduct{}
	}

	return $tmpl('view/index.html')
}
