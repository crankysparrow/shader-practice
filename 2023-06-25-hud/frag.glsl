precision mediump float;

varying vec2 vTexCoord;
varying vec3 vPosition;

uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;

#define PI 3.14159265358979323846

float smoothen(in float _value, in float _threshold) {
  return smoothstep(_threshold - 1.0 / u_resolution.x, _threshold + 1.0 / u_resolution.x, _value);
}

mat2 rotate2d(in float _angle) {
  return mat2(cos(_angle), -sin(_angle), sin(_angle), cos(_angle));
}

float circle(in vec2 _st, in float _radius) {
  // vec2 dist = _st - vec2(0.5);
  // float _circ = 1.0 - smoothstep(_radius, _radius * 1.01, dot(dist, dist) * 4.0);
  // float _circ = 1.0 - step(_radius, dot(dist, dist) * 4.0);
  // float _circ = 1.0 - dot(dist, dist) * 4.0;
  float dist = distance(_st, vec2(0.5));
  return smoothstep(_radius + 0.001, _radius - 0.001, dist);
  // return smoothstep(_circ, _circ - 1.0 / u_resolution.x, 1.0 - _radius);
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

vec3 blip(vec2 _st, float _radius) {
  float dist = distance(_st, vec2(0.5));
  float b = smoothstep(_radius * 0.5, _radius * 1.8, dist);
  // float c = circle(_st, _radius);
  float c = smoothstep(_radius + 0.001, _radius - 0.001, dist);
  return vec3(c * b, 0.0, 0.0);
}

void main() {
  vec2 st = vTexCoord;
  vec3 col = vec3(0.0, 0.0, 0.0);

  col += circle_outline(st, 0.01, 0.002);
  col += circle_outline(st, 0.25, 0.002);
  col += circle_outline(st, 0.4, 0.002);

  float angle = fract(u_time * 0.25) * PI * 2.0;
  col += gradientAndLine(st, angle, 0.4);

  float bliptime = fract(u_time * 1.6) * 0.06 + 0.01;
  col += blip(st + vec2(0.2, 0.28), bliptime);

  float blipmid = circle(st + vec2(0.2, 0.28), 0.005);
  col += vec3(blipmid, blipmid * 0.2, blipmid * 0.2);

  gl_FragColor = vec4(col, 1.0);
}