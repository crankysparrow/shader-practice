precision mediump float;

varying vec2 vTexCoord;
varying vec3 vPosition;

uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;

#define PI 3.14159265358979323846

float circle(vec2 coord, float radius) {
  float dist = distance(coord, vec2(0.5));
  return smoothstep(radius + 0.001, radius - 0.001, dist);
}

float box(vec2 coord, float _size) {
  float edge = (1.0 - _size) * 0.5;
  vec2 bl = smoothstep(edge, edge + 0.001, coord);
  vec2 tr = smoothstep(edge, edge + 0.001, 1.0 - coord);
  return bl.x * bl.y * tr.x * tr.y;
}

float outline(vec2 coord, float _size) {
  float outer = box(coord, _size);
  float inner = box(coord, _size - 0.05);

  return outer - inner;
}

mat2 rotate2d(float _angle) {
  return mat2(cos(_angle), -sin(_angle), sin(_angle), cos(_angle));
}

float rect(vec2 coord, vec2 size) {
  vec2 edges = (vec2(1.0) - size) / 2.0;
  float bottom = step(edges.y, coord.y);
  float left = step(edges.x, coord.x);
  float right = 1.0 - step(edges.x + size.x, coord.x);
  float top = 1.0 - step(edges.y + size.y, coord.y);

  return bottom * left * right * top;
}

float outlinerect(vec2 coord, vec2 size) {
  float outer = rect(coord, size);
  float inner = rect(coord, size - vec2(0.05));
  return outer - inner;
}

void main() {
  vec2 st = vTexCoord;

  float col = 0.1;

  st *= 5.0;

  // st.y will be bw 0-1, 1-2, 2-3, 3-4, 4-5 
  // if st.y%2.0 > 1 (ex: st.y = 1.5 --> 1.5 / 2) --> row is odd 
  // if st.y%2.0 < 1 (ex: st.y = 2.5 --> 2.5 / 2) --> row is even
  float row_odd = step(1.0, mod(st.y, 2.0));
  float col_odd = step(1.0, mod(st.x, 2.0));

  // if u_time = 10.5 --> 10.5 % 2.0 = 0.5 --> 0.5 < 1.0 --> oddtime = 0
  float oddtime = step(1.0, mod(u_time, 2.0));
  float eventime = 1.0 - oddtime;
  // either oddtime = 0.0 and eventime = 1.0 or eventime = 0.0 and oddtime = 1.0

  // left/right (only takes effect if oddtime is 1.0)
  st.x += row_odd * u_time * oddtime; // makes odd rows move left 
  st.x += (1.0 - row_odd) * u_time * -1.0 * oddtime; // even rows move right 

  // up/down (only affects eventime is 1.0)
  st.y += col_odd * u_time * eventime;
  st.y += (1.0 - col_odd) * u_time * -1.0 * eventime;

  st = fract(st);
  col += outline(st, 0.7);

  gl_FragColor = vec4(vec3(col), 1.0);
}