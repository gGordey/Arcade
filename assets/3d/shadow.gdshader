shader_type spatial;
render_mode unshaded;

uniform vec3 color;

uniform vec3 darkness_change;

uniform float first_layer_end;
uniform float second_layer_end;

void vertex() {
	
}

void fragment() {
	ALBEDO = color;
	if (FRAGCOORD.z > first_layer_end)
	{
		ALBEDO -= darkness_change;
	}
}

