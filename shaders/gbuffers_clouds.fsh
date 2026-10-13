#version 330 compatibility

uniform sampler2D gtexture;

uniform float alphaTestRef = 0.1;

in vec2 texcoord;
in vec4 glcolor;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

void main() {
	color = texture(gtexture, texcoord) * glcolor;
	float alphaGradient = length(vec2(dFdx(color.a), dFdy(color.a)));
	float cloudOutline = smoothstep(0.035, 0.12, alphaGradient);
	color.rgb = mix(color.rgb, vec3(1.0), cloudOutline * 0.42);
	if (color.a < alphaTestRef) {
		discard;
	}
}
