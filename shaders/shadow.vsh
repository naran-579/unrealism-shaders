#version 330 compatibility

#include "/lib/shadowDistort.glsl"

out vec2 texcoord;
out vec4 glcolor;

in vec2 mc_Entity;

uniform mat4 shadowModelView;
uniform mat4 shadowModelViewInverse;
uniform vec3 cameraPosition;
uniform float frameTimeCounter;

void main() {
  texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
  glcolor = gl_Color;
	vec4 viewPosition = gl_ModelViewMatrix * gl_Vertex;
	if (mc_Entity.x == 100.0) {
		vec3 worldPosition = (shadowModelViewInverse * viewPosition).xyz + cameraPosition;
		vec2 blockPosition = floor(worldPosition.xz);
		float phase = frameTimeCounter * 1.4 + dot(blockPosition, vec2(0.73, 0.91));
		vec3 windOffset = vec3(sin(phase), 0.0, cos(phase * 0.83)) * 0.025;
		viewPosition.xyz += mat3(shadowModelView) * windOffset;
	}
	gl_Position = gl_ProjectionMatrix * viewPosition;
  gl_Position.xyz = distortShadowClipPos(gl_Position.xyz);
}
