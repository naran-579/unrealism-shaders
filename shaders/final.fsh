#version 330 compatibility

uniform sampler2D colortex0;


in vec2 texcoord;

layout(location = 0) out vec4 color;

float luminance(vec3 rgb) {
	return dot(rgb, vec3(0.2126, 0.7152, 0.0722));
}

void main() {
  

  




	vec2 texel = 1.5 / vec2(textureSize(colortex0, 0));
	float tl = luminance(texture(colortex0, texcoord + texel * vec2(-1.0,  1.0)).rgb);
	float tc = luminance(texture(colortex0, texcoord + texel * vec2( 0.0,  1.0)).rgb);
	float tr = luminance(texture(colortex0, texcoord + texel * vec2( 1.0,  1.0)).rgb);
	float ml = luminance(texture(colortex0, texcoord + texel * vec2(-1.0,  0.0)).rgb);
	float mr = luminance(texture(colortex0, texcoord + texel * vec2( 1.0,  0.0)).rgb);
	float bl = luminance(texture(colortex0, texcoord + texel * vec2(-1.0, -1.0)).rgb);
	float bc = luminance(texture(colortex0, texcoord + texel * vec2( 0.0, -1.0)).rgb);
	float br = luminance(texture(colortex0, texcoord + texel * vec2( 1.0, -1.0)).rgb);

	float gx = -tl + tr - 2.0 * ml + 2.0 * mr - bl + br;
	float gy = -tl - 2.0 * tc - tr + bl + 2.0 * bc + br;
	float edge = smoothstep(0.035, 0.14, length(vec2(gx, gy)) * 0.25);

	color = texture(colortex0, texcoord);
	color.rgb *= mix(1.0, 0.025, edge);
	color.rgb = pow(color.rgb, vec3(1.0 / 2.2));
}
