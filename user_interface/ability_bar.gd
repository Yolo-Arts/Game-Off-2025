extends HBoxContainer

var skills : Array
var unlocked_abilities: Array[Ability] = []

 
func _ready():
	skills = get_children()
	
	for skill in skills:
		skill.visible = false

	for i in get_child_count():
		skills[i].change_key = str(i+1)
		skills[i].cast.connect(_casted)

func unlock_ability(ability: Ability):
	for i in range(skills.size()):
		if not skills[i].ability:
			skills[i].ability = ability
			skills[i].texture_normal = ability.icon
			skills[i].visible = true
			skills[i].progress_bar.max_value = ability.cooldown
			skills[i].timer.wait_time = ability.cooldown
			return true
	return false



func _casted(ability_name):
	for skill in skills:
		if skill.name == ability_name and skill.ability:
			activate_ability(skill.ability)
			break

func activate_ability(ability: Ability):
	if ability.ability_scene:
		var handler = ability.ability_scene.instantiate()
		add_child(handler)
		handler.activate_ability(Globals.player)
