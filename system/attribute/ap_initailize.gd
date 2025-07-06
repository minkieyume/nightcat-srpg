class_name APInitailizeBuff
extends AttributeBuff

@export var max_ap: float = 10.0
@export var ap: float = 10.0

func _applies_to(attribute_set: AttributeSet) -> Array[AttributeBase]:
    # note: remember to apply a buff to "base" attributes first and to "derived" later
    return [
        attribute_set.find_by_name(MaxAP.ATTRIBUTE_NAME),
        attribute_set.find_by_name(AP.ATTRIBUTE_NAME),
    ]


func _operate(_values, _attribute_set: AttributeSet) -> Array[AttributeOperation]:
    # note: the order must be the same as  the one in _applies_to
    return [
        AttributeOperation.forcefully_set_value(max_ap),
        AttributeOperation.forcefully_set_value(ap),
    ]
