#version 330 compatibility

uniform sampler2D colortex0;
uniform sampler2D depthtex0;

uniform mat4 gbufferProjectionInverse;

uniform vec3 fogColor;
uniform float far;

in vec2 texcoord;

const float FOG_START_BLOCKS = 30.0 * 16.0;
const float FOG_MIN_START_FRACTION = 0.97;
const float FOG_EXPONENTIAL_STRENGTH = 6.0;

vec3 projectAndDivide(mat4 projectionMatrix, vec3 position){
  vec4 homPos = projectionMatrix * vec4(position, 1.0);
  return homPos.xyz / homPos.w;
}

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

void main() {
  color = texture(colortex0, texcoord);

  float depth = texture(depthtex0, texcoord).r;
  if (depth >= 0.99999) {
    return;
  }

  vec3 ndcPos = vec3(texcoord.xy, depth) * 2.0 - 1.0;
  vec3 viewPos = projectAndDivide(gbufferProjectionInverse, ndcPos);

  float dist = length(viewPos) / far;
  float viewHeight = viewPos.y / max(length(viewPos), 1.0);
  float groundSettling = 1.0 - smoothstep(-0.1, 0.35, viewHeight);
  float settledDist = dist * (1.0 + groundSettling * 0.25);
  float fogStart = min(FOG_START_BLOCKS / far, FOG_MIN_START_FRACTION);
  float fogProgress = clamp((settledDist - fogStart) / max(1.0 - fogStart, 0.0001), 0.0, 1.0);
  float fogFactor = (exp(FOG_EXPONENTIAL_STRENGTH * fogProgress) - 1.0)
      / (exp(FOG_EXPONENTIAL_STRENGTH) - 1.0);

  color.rgb = mix(color.rgb, pow(fogColor, vec3(2.2)), clamp(fogFactor, 0.0, 1.0));
}
