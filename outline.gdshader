shader_type spatial;

void vertex() {
	
}

void fragment() {
	if (VERTEX.x > 0.5 || VERTEX.y > 0.5 || VERTEX.z > 0.5)
	{
		ALBEDO = vec3 (0,0,0);
	}
	if (VERTEX.x < -0.5 || VERTEX.y < -0.5 || VERTEX.z > -0.5)
	{
		ALBEDO = vec3 (0,0,0);
	}
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
