module classes

import mysql
//
//  classes
//  _____________________________________________
// import crypto.sha256
// import rand
// import os
// import time
// import sqlite
import strings

struct Filter {
	db mysql.Connection
pub mut:
	id      int
	title   string
	text    string
	page    int
	nr_view int
	sku     string
}

pub fn (mut p Product) filter_id(q int) ?Product {
	res := p.db.query('SELECT * FROM product WHERE id_product == $q;') ?
	if res.maps().len == 0 {
		return Product{}
	}
	return Product{}
}

pub fn (pp Product) filter_by_id(criteria map[string]string) ?Product {
	mut p := pp
	fileds_required := make_query_fileds_required(p)

	filter := make_query_condition(criteria, p.schema_name)

	query := 'SELECT $fileds_required FROM `product` INNER JOIN `product_lang` ON (`product`.`id` = `product_lang`.`id_product`) $filter;'

	res := p.db.query(query) ?
	if res.maps().len == 0 {
		return Product{}
	}

	mut result := Product{}

	// result << p.hydrate(res[0])

	return result
}

pub fn (pp Product) filter_by_query(criteria map[string]string) ?[]Product {
	mut p := pp

	filter := make_query_condition(criteria, p.schema_name)
	query := 'SELECT * FROM `product` p INNER JOIN `product_lang` pl ON (p.`id` = pl.`id_product`) $filter;'
	rows := p.db.query(query) ?

	if rows.maps().len == 0 {
		return [Product{}]
	}

	mut result := []Product{}
	// for row in rows {
	// 	// mut pp := p.hydrate(row)

	// 	result << p.hydrate(row)
	// }
	return result
}

pub fn make_query_fileds_required(p Product) string {
	mut fileds_required := strings.new_builder(1024)

	for _, name_field in p.schema {
		fileds_required.write_string('\r\n`' + p.schema_name + '`.' + name_field + ',')
	}
	for iii, name_field in p.schema_lang {
		fileds_required.write_string('\r\n`' + p.schema_name + '_lang`.' + name_field)
		if p.schema_lang.len > (iii + 1) {
			fileds_required.write_string(',')
		}
	}
	return fileds_required.str()
}

pub fn make_query_condition(query map[string]string, schema_name string) string {
	nb_page := 10

	mut conjonction := ' WHERE'
	mut condition := ''

	if query['id'].len > 0 {
		id := query['id']
		condition += conjonction + ' $schema_name' + '.id = $id'
		conjonction = ' AND'
	}

	if query['password'].len > 0 {
		password := query['password']
		condition += conjonction + " `password` = '$password'"
		conjonction = ' AND'
	}

	if query['email'].len > 0 {
		email := query['email']
		condition += conjonction + " `email` = '$email'"
		conjonction = ' AND'
	}

	if query['order_by'].len > 0 {
	}

	if query['page'].len > 0 {
		page := query['page'].int()
		min := page + (nb_page - 1) * (page - 1) - 1
		max := page + (nb_page - 1) * page
		condition += ' LIMIT $max OFFSET $min'
	}

	return condition
}
