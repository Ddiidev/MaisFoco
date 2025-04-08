module types

pub enum TypeRecomendation {
	watch = 0
	read  = 1
	play  = 2
}

pub fn (tr TypeRecomendation) str() string {
	return match tr {
		.watch { 'Assistir' }
		.read { 'Ler' }
		.play { 'Jogar' }
	}
}
