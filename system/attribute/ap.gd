class_name AP
extends Attribute

const ATTRIBUTE_NAME = "ap"


func _init(_attribute_name := ATTRIBUTE_NAME):
    attribute_name = _attribute_name
    

## 告诉AttributeContainer，本Attribute(AP)是MaxAP的子Attribute
func _derived_from(attribute_set: AttributeSet) -> Array[AttributeBase]:
    return [
        attribute_set.find_by_name(MaxAP.ATTRIBUTE_NAME),
    ]


## 用于获取值区间的比较方法。
func _compute_value(argument: AttributeComputationArgument) -> float:
    var parent_attributes := argument.get_parent_attributes()
    var max_ap_attribute := parent_attributes[0]
    
    # 将值控制在0~max值之间，并去掉舍入。
    return float(round(clamp(argument.operated_value, 0, max_ap_attribute.get_buffed_value())))
