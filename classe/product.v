module classes

import mysql
import time

pub struct Product {
pub mut:
	id    int
	sku   string
	ean13 string

	collections string
	ptype       string
	// images              []Image
	featured_image string
	featured_media string

	handle                              string
	variants                            string
	selected_variant                    string
	selected_or_first_available_variant string
	first_available_variant             string
	has_only_default_variant            string

	options                 string
	options_with_values     string
	price                   int
	price_max               int
	price_min               int
	price_varies            int
	compare_at_price_max    int
	compare_at_price_min    int
	compare_at_price_varies int
	brand                   int
	vendor                  int
	template_suffix         string

	id_lang          int
	title            string
	description      string
	content          string
	link_rewrite     string
	meta_description string
	meta_keywords    string
	meta_title       string
	url              string
	tags             []int
	available        int
	published_at     i64
	created_at       i64
	modified_at      i64
mut:
	filter      Filter
	pragma      []string
	schema      []string
	schema_lang []string
	schema_name string
	db          mysql.Connection  [skip]
	cache       map[string]string [skip]
}

pub const (
	visibility_not_visible = 1
	visibility_in_catalog  = 2
	visibility_in_search   = 3
	visibility_both        = 4
)

pub fn (mut p Product) save() ?Product {
	today := time.now()

	mut condition_where := ';'
	mut condition_where_lang := ';'
	mut type_query := 'INSERT INTO '

	fields, values, update := dehydrate_product(p)
	fieldsl, valuesl, updatel := dehydrate_product_lang(p)
	if p.id == 0 {
		// next_id := p.db.q_int('SELECT MAX(id) from product') + 1
		// p.id = next_id

		// query := "INSERT INTO `product` ($fields)  VALUES ($values)"
		// sig, code := p.db.exec(query)

		// queryl := "INSERT INTO `product_lang` ($fieldsl)  VALUES ($valuesl)"
		// sigl, codel := p.db.exec(queryl)
	} else {
		condition_where = 'id = $p.id; '
		condition_where_lang = 'id_product = $p.id; '
		// mut data := unify_data_for_update(fields, values)

		query := 'UPDATE `product` SET $update WHERE $condition_where;'
		sig := p.db.query(query) ?

		queryl := 'UPDATE `product_lang` SET $updatel WHERE $condition_where_lang;'
		sigl := p.db.query(queryl) ?
	}

	return p
}

pub fn (mut p Product) delete() Product {
	return p
}
