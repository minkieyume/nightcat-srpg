class_name HP
extends Attribute

const ATTRIBUTE_NAME = "HP"


func _init(_attribute_name := ATTRIBUTE_NAME):
    attribute_name = _attribute_name
    

## We are telling the AttributeContainer that this attribute (HealthAttribute)
## is derived from the MaxHealthAttribute.
func _derived_from(attribute_set: AttributeSet) -> Array[AttributeBase]:
    return [
        attribute_set.find_by_name(MaxHP.ATTRIBUTE_NAME),
    ]


## We want to avoid health overflowing the max health.
## We are going to use the _compute_value method to do that.
func _compute_value(argument: AttributeComputationArgument) -> float:
    var parent_attributes := argument.get_parent_attributes()
    var max_health_attribute := parent_attributes[0]
    
    # Clamp the value between 0 (min health, fixed value) and MaxHealthAttribute's value
    return clamp(argument.operated_value, 0, max_health_attribute.get_buffed_value())
