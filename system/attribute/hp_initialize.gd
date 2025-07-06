class_name InitializeAttributesBuff
extends AttributeBuff

@export var max_health: float = 100.0
@export var health: float = 100.0

func _applies_to(attribute_set: AttributeSet) -> Array[AttributeBase]:
    # note: remember to apply a buff to "base" attributes first and to "derived" later
    return [
        attribute_set.find_by_name(MaxHP.ATTRIBUTE_NAME),
        attribute_set.find_by_name(HP.ATTRIBUTE_NAME),
    ]


func _operate(_values, _attribute_set: AttributeSet) -> Array[AttributeOperation]:
    # note: the order must be the same as  the one in _applies_to
    return [
        AttributeOperation.forcefully_set_value(max_health),
        AttributeOperation.forcefully_set_value(health),
    ]
