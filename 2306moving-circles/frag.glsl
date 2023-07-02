precision mediump float;

varying vec2 vTexCoord;
varying vec3 vPosition;

uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;

#define PI 3.14159265358979323846

// float map (float value, float inmin, float inmax, float outmin, float outmax) {
//   return (value - inmin) * (outmax - outmin) / (inmax - inmin) + outmin;
// }


vec3 indigo = vec3(0.0, 0.161, 0.432);
vec3 rose = vec3(0.851, 0.012, 0.408);
vec3 orange = vec3(1.0, 0.467, 0.0);
vec3 peach = vec3(0.933, 0.824, 0.553);
vec3 teal = vec3(0.0, 0.686, 0.71);

vec2 rotate2d(vec2 _st, float _angle) {
  _st -= 0.5;
  _st *= mat2(cos(_angle), -sin(_angle), sin(_angle), cos(_angle));
  _st += 0.5;
  return _st;
}

// vec2 tile(vec2 _st, float _zoom) {
//   _st *= _zoom;
//   return fract(_st);
// }

// float line(vec2 _st) {
//   float edge1 = step(0.000, _st.x);
//   float edge2 = step(0.002, _st.x);
//   float line = edge1 - edge2;

//   return line;
// }

// float rect(vec2 _st, vec2 size, float smoothness) {
//   float edgex = (1.0 - size.x) * 0.5;
//   float edgey = (1.0 - size.y) * 0.5;
//   float smhalf = smoothness * 0.5;

//   float bottom = smoothstep(edgey - smhalf, edgey + smhalf, _st.y);
//   float top = smoothstep(edgey - smhalf, edgey + smhalf, 1.0 - _st.y);
//   float left = smoothstep(edgex - smhalf, edgex + smhalf, _st.x);
//   float right = smoothstep(edgex - smhalf, edgex + smhalf, 1.0 - _st.x);

//   return top * bottom * left * right;
// }

float circle(vec2 _st, float _radius, float _smoothness) {
  float dist = distance(_st, vec2(0.5));
  return smoothstep(_radius + _smoothness * 0.5, _radius - _smoothness * 0.5, dist);
}

float pattern1(vec2 _st, float tile) {
  _st *= tile;
  _st += vec2(0.02 * floor(_st.x) * sin(u_time), -0.01 * floor(_st.y) * cos(u_time * 2.0));
  _st = fract(_st);
  float circ = circle(_st, 0.35, 0.01);
  return circ;
}

float pattern2(vec2 _st, float tile) {
  _st *= tile;
  _st = fract(_st);
  float c1 = circle(_st, 0.2, 0.01);
  return c1;
}

float pattern3(vec2 _st, float tile) {
  _st *= tile;
  vec2 adjust = vec2(0.04 * floor(_st.x) * cos(u_time * 1.2), -0.05 * floor(1.0 - _st.y) * cos(u_time * 0.8));
  _st = fract(_st);
  float c2 = circle(_st + adjust, 0.06, 0.01);
  return c2;
}

void main() {
  vec2 st = vTexCoord;
  // st = rotate2d(st, u_time * 0.1);
  vec3 color = vec3(0.0);
  float tile = 7.0;

  float p1 = pattern1(st, tile);
  color = mix(indigo, peach, p1);

  float p2 = pattern2(st, tile);
  color = mix(color, rose, p2 * p1);

  float p3 = pattern3(st, tile);
  color = mix(color, orange, p3);

  gl_FragColor = vec4(color, 1.0);
}