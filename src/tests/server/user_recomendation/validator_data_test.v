module user_recomendation

import json
import server.features.user_recomendation.models
import server.features.user_recomendation.controllers

fn test_email_is_not_valid() {
	m := models.UserRecomendation{
		email: 'testenoemail.com'
	}

	m.validate() or {
		assert true, err.msg()
		return
	}

	assert false, 'Email não é válido, mas foi interpretado como válido!'
}

fn test_observation_is_not_valid() {
	m := models.UserRecomendation{
		observation: 'testenoemail.com'.repeat(150)
	}

	m.validate() or {
		assert true, err.msg()
		return
	}

	assert false, 'Observação não é válida, mas foi interpretada como válida!'
}

fn test_email_is_valid() ! {
	m := models.UserRecomendation{
		email: 'andreluiz.ddev@gmail.com'
	}

	m.validate()!
}

const data_3 = r'{
    "nome": "Carlos Silva",
    "email": "carlos.silva@example.com",
    "type": "BOOK",
    "link": "https://amazon.com/books/productivity-master",
    "observation": "Excellent book about time management"
}'

fn test_parser_data() ! {
	res := json.decode(models.UserRecomendation, data_3)!

	res.validate()!
}
