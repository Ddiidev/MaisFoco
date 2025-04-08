module errors

pub struct ErrorNotFoundRecommendation {
	Error
}

pub fn (e ErrorNotFoundRecommendation) msg() string {
	return 'Não foi encontrado sua recomendação!'
}
