#version 330 compatibility

uniform sampler2D gtexture;
uniform float frameTimeCounter;

uniform float alphaTestRef = 0.1;

in vec2 lmcoord;
in vec2 texcoord;
in vec4 glcolor;
in vec3 normal;
in vec3 worldPosition;

/* RENDERTARGETS: 0,1,2 */
layout(location = 0) out vec4 color;
layout(location = 1) out vec4 lightLevelData;
layout(location = 2) out vec4 encodedNormal;

void main() {
	color = texture(gtexture, texcoord) * glcolor;
	float phase1 = dot(worldPosition.xz, vec2(0.75, 1.2)) + frameTimeCounter * 1.3;
	float phase2 = dot(worldPosition.xz, vec2(-1.1, 0.65)) - frameTimeCounter * 0.9;
	float slopeX = 0.035 * 0.75 * cos(phase1) - 0.025 * 1.1 * cos(phase2);
	float slopeZ = 0.035 * 1.2 * cos(phase1) + 0.025 * 0.65 * cos(phase2);
	vec3 rippleNormal = normalize(vec3(-slopeX, 1.0, -slopeZ));
	vec3 waterNormal = normalize(mix(normalize(normal), rippleNormal, smoothstep(0.35, 0.85, abs(normal.y))));
	lightLevelData = vec4(lmcoord, 2.0, 1.0);
	encodedNormal = vec4(waterNormal * 0.5 + 0.5, 1.0);
	if (color.a < alphaTestRef) {
		discard;
	}
}
