precision mediump float;

varying vec2 vTexCoord;
varying vec3 vPosition;

uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;

#define PI 3.14159265358979323846

vec3 tearose = vec3(0.8828125, 0.7578125, 0.7734375);
vec3 eggplant = vec3(0.4375, 0.28125, 0.33203125);
vec3 plum = vec3(0.609375, 0.32421875, 0.546875);
vec3 violet = vec3(0.18359375, 0.00390625, 0.27734375);
vec3 purple = vec3(0.21875, 0.07421875, 0.1171875);

vec3 random3(vec3 c) {
  float j = 4096.0 * sin(dot(c, vec3(17.0, 59.4, 15.0)));
  vec3 r;
  r.z = fract(512.0 * j);
  j *= .125;
  r.x = fract(512.0 * j);
  j *= .125;
  r.y = fract(512.0 * j);
  return r - 0.5;
}

// https://thebookofshaders.com/edit.php#11/iching-03.frag
const float F3 = 0.3333333;
const float G3 = 0.1666667;
float snoise(vec3 p) {

  vec3 s = floor(p + dot(p, vec3(F3)));
  vec3 x = p - s + dot(s, vec3(G3));

  vec3 e = step(vec3(0.0), x - x.yzx);
  vec3 i1 = e * (1.0 - e.zxy);
  vec3 i2 = 1.0 - e.zxy * (1.0 - e);

  vec3 x1 = x - i1 + G3;
  vec3 x2 = x - i2 + 2.0 * G3;
  vec3 x3 = x - 1.0 + 3.0 * G3;

  vec4 w, d;

  w.x = dot(x, x);
  w.y = dot(x1, x1);
  w.z = dot(x2, x2);
  w.w = dot(x3, x3);

  w = max(0.6 - w, 0.0);

  d.x = dot(random3(s), x);
  d.y = dot(random3(s + i1), x1);
  d.z = dot(random3(s + i2), x2);
  d.w = dot(random3(s + 1.0), x3);

  w *= w;
  w *= w;
  d *= w;

  return dot(d, vec4(52.0));
}

float rect(vec2 coord, vec2 size) {
  vec2 edges = (vec2(1.0) - size) / 2.0;
  float bottom = step(edges.y, coord.y);
  float top = 1.0 - step(edges.y + size.y, coord.y);
  float left = step(edges.x, coord.x);
  float right = 1.0 - step(edges.x + size.x, coord.x);

  return bottom * top * left * right;
}

mat2 rotate2d(float angle) {
  return mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
}

float r1(vec2 _st, float _time) {
  float adj = snoise(vec3(_st.x * 40.0, _st.y * 70.0, _st.x + _time)) * 0.03;

  _st += adj;

  float r = rect(_st + vec2(0.15, 0.05), vec2(0.45, 0.8));
  r += rect(_st + vec2(-0.2, -0.1), vec2(0.4, 0.7));

  return r;
}

float r2(vec2 _st, float _time) {
  _st *= vec2(3.0, 2.0) + vec2(0.05, 0.01);

  vec2 ipos = floor(_st);
  vec2 fpos = fract(_st);

  float adj = snoise(vec3(_st.x * 20.0, _st.y * 30.0, fpos.x + _time)) * 0.05;
  fpos += adj;

  float second = 1.0 - step(1.0, mod(ipos.x - 1.0, 3.0));
  float r = rect(fpos, vec2(0.9, 0.86));
  return r * second;
}

vec3 rects(vec2 _st) {
  _st *= vec2(3.0, 1.0);

  vec2 ipos = floor(_st);
  vec2 fpos = fract(_st);
  float one = 1.0 - step(1.0, mod(ipos.x, 3.0));
  float two = 1.0 - step(1.0, mod(ipos.x - 1.0, 3.0));
  float three = 1.0 - step(1.0, mod(ipos.x - 2.0, 3.0));

  float t = u_time * 0.5;
  float adj = snoise(vec3(_st.x * 20.0, _st.y * 50.0, fpos.x + t)) * 0.05;

  fpos += adj;

  float subtract = adj * 0.8;

  // https://graphtoy.com/?f1(x,t)=smoothstep(0.4,0.9,sin(x))
  fpos -= subtract * smoothstep(0.7, 0.9, sin(t)) * one;
  fpos -= subtract * smoothstep(0.7, 0.9, sin(t + 1.5)) * two;
  fpos -= subtract * smoothstep(0.7, 0.9, sin(t + 3.5)) * three;

  float r = rect(fpos, vec2(0.9, 0.8));

  vec3 col = eggplant;
  col = mix(col, purple, one * r);
  col = mix(col, purple, three * r);
  col = mix(col, tearose, two * r);

  return col;
}

void main() {
  vec2 st = vTexCoord;

  vec3 col = eggplant;
  col = mix(col, purple, r1(st, u_time * 0.5));
  col += purple * r2(st, u_time * 0.5);

  gl_FragColor = vec4(vec3(col), 1.0);
}