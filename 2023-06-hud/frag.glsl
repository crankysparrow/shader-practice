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
  float _circ = 1.0 - smoothstep(_radius, _radius * 1.01, dot(dist, dist) * 4.0);
  return _circ;
}

float circle_outline(in vec2 _st, in float _radius, in float _width) {
  float circ1 = circle(_st, _radius);
  float circ2 = circle(_st, _radius - _width);
  return circ1 - circ2;
}


float line(vec2 _st) {
  float edge1 = step(0.000, _st.x);
  float edge2 = step(0.002, _st.x);
  float line = edge1 - edge2;

  return line;
}

float rect(vec2 _st, vec2 size) {
  float edgex = 1.0 - size.x;
  float edgey = 1.0 - size.y;

  float top = step(edgey * 0.5, _st.y);
  float bottom = step(edgey * 0.5, 1.0 - _st.y);
  float left = step(edgex * 0.5, _st.x);
  float right = step(edgex * 0.5, 1.0 - _st.x);

  return top * bottom * left * right;
}

float gradient(vec2 _st) {
  float shape = (1.0 - _st.x) * 0.5;
  shape *= smoothstep(-0.1, 1.0, _st.y);
  return shape;
}

vec3 demo(vec2 _st) {
  return vec3(_st.x, _st.y, 0.0);
}

vec3 gradientAndLine(vec2 _st, float _angle, float _radius) {

  float _circ = circle(_st, _radius);

  _st -= 0.5;
  _st *= rotate2d(_angle);
  _st += 0.5;

  vec2 fourth = _st * 2.0 - vec2(1.0, 1.0);
  float r = rect(fourth, vec2(1.0, 1.0));

  float line = line(fourth);
  vec3 _design = vec3(line, line, line);

  _design += gradient(fourth);
  _design *= r;
  _design *= _circ;

  return _design;
}

void main() {
  vec2 st = vTexCoord;
  vec3 col = vec3(0.0, 0.0, 0.0);


  float c = circle_outline(st, 0.25, 0.003);
  float c2 = circle_outline(st, 0.9, 0.005);
  col += c + c2;


  float angle = fract(u_time * 0.25) * PI * 2.0;

  col += gradientAndLine(st, angle, 0.9);

  gl_FragColor = vec4(col, 1.0);
}