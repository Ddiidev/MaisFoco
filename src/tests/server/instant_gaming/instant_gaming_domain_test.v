module instant_gaming

import server.features.instant_gaming.models

fn test_count_genres() ! {
	data := models.InstantGamingProduct{
		genders: 'fps, action'
	}

	assert data.genders.to_list() == ['fps', 'action']
}

fn test_count_tags() ! {
	data := models.InstantGamingProduct{
		tags: 'Steam Deck verified,acao'
	}

	assert data.tags.to_list() == ['Steam Deck verified', 'acao']
}
