precision mediump float;

varying vec2 vTexCoord;
varying vec3 vPosition;

uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;

void main() {
  vec3 blue = vec3(0.204, 0.552, 0.668);
  vec3 darkblue = vec3(0.044, 0.0, 0.204);
  vec3 yellow = vec3(0.988, 0.792, 0.274);
  vec3 lightgreen = vec3(0.69, 0.949, 0.706);

  vec2 st = vTexCoord;

  st *= 2.0;

  float odd_y = step(1.0, mod(st.y, 2.0));
  float odd_x = step(1.0, mod(st.x, 2.0));

  // find where in the grid the square is
  float top_right = odd_y * odd_x;
  float bottom_right = odd_x * (1. - odd_y);
  float top_left = (1.0 - odd_x) * odd_y;
  float bottom_left = (1.0 - odd_x) * (1.0 - odd_y);

  // st = fract(st);

  vec3 col = vec3(0.0, 0.0, 0.0);
  col += darkblue * top_right;
  col += blue * top_left;
  col += yellow * bottom_right;
  col += lightgreen * bottom_left;

  gl_FragColor = vec4(col, 1.0);
}