#version 330 compatibility

out vec2 lmcoord;
out vec2 texcoord;
out vec4 glcolor;
out vec3 normal;

in vec2 mc_Entity;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;
uniform float frameTimeCounter;

void main() {
	vec4 viewPosition = gl_ModelViewMatrix * gl_Vertex;
	if (mc_Entity.x == 100.0) {
		vec3 worldPosition = (gbufferModelViewInverse * viewPosition).xyz + cameraPosition;
		float phase = frameTimeCounter * 1.4 + dot(worldPosition.xz, vec2(0.11, 0.13));
		vec3 windOffset = vec3(sin(phase), 0.0, cos(phase * 0.83)) * 0.06;
		viewPosition.xyz += mat3(gbufferModelView) * windOffset;
	}
	gl_Position = gl_ProjectionMatrix * viewPosition;
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
	glcolor = gl_Color;


	normal = gl_NormalMatrix * gl_Normal; // this gives us the normal in view space
    normal = mat3(gbufferModelViewInverse) * normal; // this converts the normal to world/player space

}
