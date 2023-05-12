// article.v
module classes

struct StructModel {
pub mut:
	id int
mut:
	table                string
	identifier           int
	fields_required      []string
	fields_size          []int
	fields_validate      []int
	fields_required_lang []int
	fields_size_lang     []int
	fields_validate_lang []int
	tables               []int
}

/*
pub fn init ()
{

}*/
