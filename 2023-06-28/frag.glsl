precision mediump float;

varying vec2 vTexCoord;
varying vec3 vPosition;

uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;

#define PI 3.14159265358979323846

float map (float value, float inmin, float inmax, float outmin, float outmax) {
  return (value - inmin) * (outmax - outmin) / (inmax - inmin) + outmin;
}

vec2 rotate2d(vec2 _st, float _angle) {
  _st -= 0.5;
  _st *= mat2(cos(_angle), -sin(_angle), sin(_angle), cos(_angle));
  _st += 0.5;
  return _st;
}

vec2 tile(vec2 _st, float _zoom) {
  _st *= _zoom;
  return fract(_st);
}

float line(vec2 _st) {
  float edge1 = step(0.000, _st.x);
  float edge2 = step(0.002, _st.x);
  float line = edge1 - edge2;

  return line;
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

void main() {
  vec2 st = vTexCoord;
  vec3 col = vec3(0.0, 0.0, 0.0);

  st *= 5.0;
  vec2 odd = vec2(step(1.0, mod(st.x, 2.0)), step(1.0, mod(st.y, 2.0)));
  float oddx_eveny = odd.x * (1.0 - odd.y);
  float oddx_oddy = odd.x * odd.y;
  float evenx_eveny = (1.0 - odd.x) * (1.0 - odd.y);
  float evenx_oddy = (1.0 - odd.x) * odd.y;

  float check1 = oddx_eveny + evenx_oddy;
  float check2 = oddx_oddy + evenx_eveny;

  // float sm = rect(st, vec2(0.25)) * odd.x;
  float var = fract(u_time);
  st = fract(st);

  st = rotate2d(st, var * PI * check1);
  st = rotate2d(st, -var * PI * check2);


  float outeredge = 0.7 + map(cos(fract(u_time * 0.5) * PI * 2.0), -1.0, 1.0, -0.2, 0.8) * check1;
  float inneredge = 0.6 - check1 * 0.1;

  float md = rect(st, vec2(outeredge), 0.01) - rect(st, vec2(inneredge), 0.008);
  col = vec3(md);

  gl_FragColor = vec4(col, 1.0);
}