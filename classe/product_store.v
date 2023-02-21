module classes
import sqlite
import time
import strings
// import v.ast
// import strings
// import v.table
// import v.util


struct ProductStore {
pub mut:
	id                int
	id_lang           int
	title             string
	description       string
	content           string
	link_rewrite      string
	meta_description  string
	meta_keywords     string
	meta_title        string
	url               string
	tags              []int
	available		  int
	published_at      i64
	created_at        i64
	modified_at       i64  

mut:
	cache		map[string]string [skip]
}

pub fn (mut p Product) create() bool
{
	return true
}
