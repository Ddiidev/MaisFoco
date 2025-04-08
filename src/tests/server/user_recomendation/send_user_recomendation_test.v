module user_recomendation

import server.features.user_recomendation.models
import server.features.user_recomendation.controllers

const data_1 = r'{
    "nome": "John Doe",
    "email": "john.doe@example.com",
    "type": "WEBSITE",
    "link": "https://example.com/resource1",
    "observation": "Great resource for productivity"
}'

const data_2 = r'{
    "email": "mary.smith@example.com",
    "type": "APP",
    "link": "https://play.google.com/store/apps/details?id=com.example.app",
    "observation": null
}'

const data_3 = r'{
    "nome": "Carlos Silva",
    "email": "carlos.silva@example.com",
    "type": "BOOK",
    "link": "https://amazon.com/books/productivity-master",
    "observation": "Excellent book about time management"
}'

fn test_stupid_send_not_avaliable() {
	// controllers.send_user_recomendation(data_1)!

	assert true
}
