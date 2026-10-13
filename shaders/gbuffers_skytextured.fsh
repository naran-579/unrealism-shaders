#version 330 compatibility

uniform sampler2D gtexture;

uniform float alphaTestRef = 0.1;

in vec2 texcoord;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

void main() {
	// In Minecraft 26.2, Iris draws this program with POSITION_TEX only.
	// There is no color attribute to safely multiply into the sun/moon texture.
	color = texture(gtexture, texcoord);
	if (color.a < alphaTestRef) {
		discard;
	}
}
