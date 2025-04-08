module amazon

import server.features.amazon.models

fn test_product_both_is_paid() ! {
	data := models.AmazonProduct{
		price_printed:      2.0
		price_kindle_ebook: 0.5
	}

	assert !data.is_free()
}

fn test_product_only_printed_is_paid() ! {
	data := models.AmazonProduct{
		price_printed:      2.0
		price_kindle_ebook: 0.0
	}

	assert !data.is_free()
}

fn test_product_only_ebook_is_paid() ! {
	data := models.AmazonProduct{
		price_printed:      0.0
		price_kindle_ebook: 0.5
	}

	assert !data.is_free()
}

fn test_validate_product_is_free() ! {
	data := models.AmazonProduct{}

	assert data.is_free()
}
