precision mediump float;

varying vec2 vTexCoord;
varying vec3 vPosition;

uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;

// a zillion ways to do this i guess
// another example: https://thebookofshaders.com/edit.php#09/grid-side.frag
// ways to draw diagonal lines are in august-04-diagonals

float X_step(vec2 _st, float _width) {
  float line1 = step(_st.x - _width / 2., _st.y);
  line1 -= step(_st.x + _width / 2., _st.y);

  float line2 = step(_st.x - _width / 2., 1.0 - _st.y);
  line2 -= step(_st.x + _width / 2., 1.0 - _st.y);

  return (line1 + line2);
}

float X_2(vec2 _st, float _width) {
  float line1 = smoothstep(_st.x + _width, _st.x, _st.y);
  line1 *= smoothstep(_st.x - _width, _st.x, _st.y);

  float line2 = smoothstep(_st.x + _width, _st.x, 1.0 - _st.y);
  line2 *= smoothstep(_st.x - _width, _st.x, 1.0 - _st.y);

  return line1 + line2;
}

float X(vec2 _st, float _width) {
  float line1 = smoothstep(_st.x - _width, _st.x, _st.y);
  line1 -= smoothstep(_st.x, _st.x + _width, _st.y);

  float line2 = smoothstep(_st.x - _width, _st.x, 1.0 - _st.y);
  line2 -= smoothstep(_st.x, _st.x + _width, 1.0 - _st.y);

  return (line2 + line1);
}

vec2 tile(vec2 _st, float num) {
  _st *= num;
  return fract(_st);
}

void main() {
  vec2 st = vTexCoord;

  st = tile(st, 3.0);

  vec3 col = vec3(0.);

  col = vec3(X(st, 0.02));
  // col = vec3(X_2(st, 0.02));
  // col = vec3(X_step(st, 0.02));

  gl_FragColor = vec4(col, 1.0);
}