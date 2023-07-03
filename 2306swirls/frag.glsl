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

// ffmpeg -f image2 -r 10 -i %d.png -filter_complex
// "fps=10,scale=720:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse"
// output.gif

// vec2 rotate2d(vec2 _st, float _angle) {
//   _st -= 0.5;
//   _st *= mat2(cos(_angle), -sin(_angle), sin(_angle), cos(_angle));
//   _st += 0.5;
//   return _st;
// }

// float random(in float x) {
//   return fract(sin(x) * 1e4);
// }

float random(vec2 st) {
  return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

float random2(vec2 st) {
  st = vec2(dot(st, vec2(127.1, 311.7)), dot(st, vec2(269.5, 183.3)));

  return -1.0 +
         2.0 * fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Value noise by Inigo Quilez - iq/2013
// https://www.shadertoy.com/view/lsf3WH
float noise(vec2 st) {
  vec2 i = floor(st);
  vec2 f = fract(st);
  vec2 u = f * f * (3.0 - 2.0 * f);

  return mix(mix(random2(i + vec2(0.0, 0.0)), random2(i + vec2(1.0, 0.0)), u.x),
             mix(random2(i + vec2(0.0, 1.0)), random2(i + vec2(1.0, 1.0)), u.x),
             u.y);
}

mat2 rotate2d(float angle) {
  return mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
}

float lines(vec2 _st, float _width, float _num, float _smooth) {
  _st *= _num;
  float edge = (1.0 - _width) / 2.0;
  float right = smoothstep(edge, edge + _smooth, fract(_st.x));
  float left = smoothstep(edge, edge + _smooth, 1.0 - fract(_st.x));
  return left * right;
}

float swirls(vec2 _st, float _grid, float _time, float _linesnum) {
  _st *= _grid;
  vec2 pos = rotate2d(noise(_st - u_time * _time) * PI) * _st;
  return lines(pos, 0.5, _linesnum, 0.04);
}

// in --> -1 to 1
// out --> 2 to 3
float remap(float _in, float _inMin, float _inMax, float _outMin,
            float _outMax) {
  return _outMin + (_outMax - _outMin) * (_in - _inMin) / (_inMax - _inMin);
}

void main() {
  vec2 st = vTexCoord;

  // float grid1 = 2.0 * (sin(u_time * 0.5) * 0.5 + 1.0);
  // float grid1 = remap(sin(u_time * 0.5), -1.0, 1.0, 1.5, 2.5);
  float grid1 = 2.0;
  float grid2 = grid1 - sin(u_time) * 0.1;

  float p1 = swirls(st, grid1, 0.5, 4.0);
  float p2 = swirls(st, grid2, 0.5, 4.1);

  vec3 col = indigo;
  col = mix(rose, col, p1);
  col += teal * p2;

  // col = mix(indigo, col, p1);

  gl_FragColor = vec4(vec3(col), 1.0);
}