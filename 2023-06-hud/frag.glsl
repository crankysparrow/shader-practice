precision mediump float;

varying vec2 vTexCoord;
varying vec3 vPosition;

uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;

#define PI 3.14159265358979323846

mat2 rotate2d(float _angle) {
  return mat2(cos(_angle), -sin(_angle), sin(_angle), cos(_angle));
}

float circle(in vec2 _st, in float _radius) {
  vec2 dist = _st - vec2(0.5);
  return 1.0 - smoothstep(_radius - (_radius * 0.01), _radius + (_radius * 0.01), dot(dist, dist) * 4.0);
}

float circle_outline(in vec2 _st, in float _radius, in float _width) {
  float circ1 = circle(_st, _radius);
  float circ2 = circle(_st, _radius - _width);
  return circ1 - circ2;
}

float centerline(vec2 _st) {
  float edge1 = step(0.499, _st.x);
  float edge2 = step(0.501, _st.x);
  float line = edge1 - edge2;
  line -= step(0.5, _st.y);

  return line;
}

void main() {
  vec2 st = vTexCoord;
  float angle = fract(u_time * 0.25) * PI * 2.0;
  st -= 0.5;
  st *= rotate2d(angle);
  st += 0.5;

  vec3 col = vec3(0.0, 0.0, 0.0);

  float c = circle_outline(st, 0.25, 0.005);
  col += c;

  float line = centerline(st);
  col += vec3(line, line, line);

  gl_FragColor = vec4(col, 1.0);
}