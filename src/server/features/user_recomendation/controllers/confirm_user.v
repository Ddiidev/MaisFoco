module controllers

import shareds.handle_email.service
import server.features.user_recomendation.models
import server.features.user_recomendation.controllers.body_email

// Envia email de confirmação da recomendação que o usuário fez
fn send_confirm_email_user_recomendation(user_recomendation models.UserRecomendation) ! {
	hemail := service.get()

	hemail.send(user_recomendation.email, 'Mais Foco: Confirmação de sugestão', body_email.body_email_string(user_recomendation))!
}
