module classes

pub struct Admin {
	AdminAbstract
	AdminEntity
mut:
	filter		Filter
	pragma      []string
	schema      []string
	schema_lang []string
	schema_name string
	cache		map[string]string [skip]
}