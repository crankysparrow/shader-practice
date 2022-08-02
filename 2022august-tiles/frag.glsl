precision mediump float;

varying vec2 vTexCoord;
varying vec3 vPosition;

uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;

float circle( vec2 coord, float radius ) {
    float dist = distance(coord, vec2(0.5));
    return smoothstep(radius + 0.001, radius - 0.001, dist);
}

float square(vec2 coord, float edge) {
    vec2 bottom_left = step(vec2(edge), coord);
    vec2 top_right =  step(vec2(edge), 1.0 - coord);

    return bottom_left.x * bottom_left.y * top_right.x * top_right.y;
}

mat2 rotate2d(float _angle) {
  return mat2(cos(_angle), -sin(_angle),
              sin(_angle), cos(_angle));
}

void main() {
  vec2 st = vTexCoord;
  vec3 color = vec3(0.0);
  float d = 0.0;

  vec2 sq1 = st;
  sq1 -= vec2(0.3, 0.3);
  sq1 = rotate2d(u_time) * sq1;
  sq1 += vec2(0.5, 0.5);

  vec2 sq2 = st - vec2(0.7, 0.7);
  sq2 = rotate2d(u_time * -1.0) * sq2;
  sq2 += vec2(0.5, 0.5);

  float col = square(sq1, 0.4);
  col += square(sq2, 0.4);

  gl_FragColor = vec4(vec3(col), 1.0);
}