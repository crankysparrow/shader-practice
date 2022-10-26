precision mediump float;

varying vec2 vTexCoord;
varying vec3 vPosition;

uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;

// methods of drawing diagonal line across the square wooo 

vec3 diag_sm_method1(vec2 _st, float _width) {
  float tri_big = smoothstep(_st.x - _width, _st.x, _st.y);
  // white part of triangle starts at top left 
  // hypotenuse is diagonal, a bit past the center

  float tri_small = smoothstep(_st.x, _st.x + _width, _st.y);
  // this triangle is a bit smaller... hypotenuse a bit before the center

  // uncomment for demo 
  // return vec3(tri_big, tri_small, 0.0);

  return vec3(tri_big - tri_small);
  // subtract the small triangle from the big one 
  // what's left is a line where they did not overlap 
}


vec3 diag_sm_method2(vec2 _st, float _width) {
  float tri_top = smoothstep(_st.x + _width, _st.x, _st.y);
  float tri_bottom = smoothstep(_st.x - _width, _st.x, _st.y);

  // uncomment demo: red for tri_bottom, blue for top, purple where they overlap
  // return vec3(tri_bottom, 0.0, tri_top);
  return vec3(tri_top * tri_bottom);
}

vec3 diag_step(vec2 _st, float _width) {
  float triangle_bigger = step(_st.x - _width / 2., _st.y); 
  // white part of triangle starts at top left 
  // hypotenuse is diagonal, a bit past the center
  float triangle_smaller = step(_st.x + _width / 2., _st.y);
  // this triangle is a bit smaller... hypotenuse a bit before the center

  // uncomment to see the 2 triangles
  // return vec3(triangle_bigger, triangle_smaller, 0.); 

  return vec3(triangle_bigger - triangle_smaller);
  // subtract the small triangle from the big one 
  // what's left is a line where they did not overlap 
}

vec2 tile(vec2 _st, float num) {
  _st *= num;
  return fract(_st);
}


void main() {
  vec2 st = vTexCoord;

  st = tile(st, 3.0);

  vec3 col = vec3(0.);

  col = diag_sm_method2(st, 0.02);
  // col = diag_sm_method1(st, 0.04);
  // col = diag_step(st, 0.02);

  gl_FragColor = vec4(col, 1.0);
}