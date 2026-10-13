#version 330 compatibility

uniform sampler2D colortex0;
uniform sampler2D depthtex0;

uniform mat4 gbufferProjectionInverse;

uniform vec3 fogColor;
uniform float far;

in vec2 texcoord;

const float FOG_START_BLOCKS = 25.0 * 16.0;
const float FOG_MIN_START_FRACTION = 0.88;

#if MC_VERSION >= 260200
const float skyDepth = 0.0;
#else
const float skyDepth = 1.0;
#endif

vec3 projectAndDivide(mat4 projectionMatrix, vec3 position){
  vec4 homPos = projectionMatrix * vec4(position, 1.0);
  return homPos.xyz / homPos.w;
}

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

void main() {
  color = texture(colortex0, texcoord);

  float depth = texture(depthtex0, texcoord).r;
  if (depth == skyDepth){
    return;
  }

#if MC_VERSION >= 260200
  vec3 ndcPos = vec3(texcoord.xy * 2.0 - 1.0, depth);
#else
  vec3 ndcPos = vec3(texcoord.xy, depth) * 2.0 - 1.0;
#endif
  vec3 viewPos = projectAndDivide(gbufferProjectionInverse, ndcPos);

  float dist = length(viewPos) / far;
  float viewHeight = viewPos.y / max(length(viewPos), 1.0);
  float groundSettling = 1.0 - smoothstep(-0.1, 0.35, viewHeight);
  float settledDist = dist * (1.0 + groundSettling * 0.25);
  float fogStart = min(FOG_START_BLOCKS / far, FOG_MIN_START_FRACTION);
  float fogFactor = smoothstep(fogStart, 1.0, settledDist);

  color.rgb = mix(color.rgb, pow(fogColor, vec3(2.2)), clamp(fogFactor, 0.0, 1.0));
}
