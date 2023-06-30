precision mediump float;

varying vec2 vTexCoord;
varying vec3 vPosition;

uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;

#define PI 3.14159265358979323846


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


float rect(vec2 _st, vec2 size, float smoothness) {
  float edgex = (1.0 - size.x) * 0.5;
  float edgey = (1.0 - size.y) * 0.5;
  float smhalf = smoothness * 0.5;

  float bottom = smoothstep(edgey - smhalf, edgey + smhalf, _st.y);
  float top = smoothstep(edgey - smhalf, edgey + smhalf, 1.0 - _st.y);
  float left = smoothstep(edgex - smhalf, edgex + smhalf, _st.x);
  float right = smoothstep(edgex - smhalf, edgex + smhalf, 1.0 - _st.x);

  return top * bottom * left * right;
}

float circle(vec2 _st, float _radius, float _smoothness) {
  float dist = distance(_st, vec2(0.5));
  return smoothstep(_radius + _smoothness * 0.5, _radius - _smoothness * 0.5, dist);
}

float random(vec2 st) {
  return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void main() {
  vec2 st = vTexCoord;
  
  st *= vec2(50.0, 3.0);
  // vec2 fpos = fract(st); // fractional coords

  float odd = step(1.0, mod(st.y, 2.0));
  float even = 1.0 - odd;

  st.x += u_time * odd * 10.0;
  st.x -= odd * max(0.0, 0.5 + sin(u_time)) * random(st) * 10.0;
  // st.x -= u_time * even * random(st) * 10.0;

  vec2 ipos = floor(st); // integer coords 
  vec2 fpos = fract(st);
  float r = rect(fpos, vec2(0.7, 0.5), 0.01);
  float c = random(ipos);
  c = step(0.3, c);

  gl_FragColor = vec4(vec3(c), 1.0);
}